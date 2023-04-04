//==============================================================================
//                        Cartridge Example 1
//
//  Start address at $8000 as this is where the cartridge address range begins
//==============================================================================

* = $8000
     .word coldstart            // coldstart vector
     .word warmstart            // warmstart vector
     .byte $C3, $C2, $CD, $38, $30  // "CBM8O". autostart string

coldstart:
{
     //	KERNAL RESET ROUTINE
     sei
     stx $D016
     jsr $FDA3           // prepare IRQ
     jsr $FD50           // init memory. Rewrite this routine to speed up boot process.
     jsr $FD15           // init I/O
     jsr $FF5B           // init video
     cli                 // disable interrupts
}

warmstart:
{
     jsr textSetup
     jmp loop

     textSetup: 
     {
          ldx #0
          
          loop: 
               lda text,x     // Load next char value
               cmp #$FF       // Have we reached the end of the string
               beq out        // If null, jump to out:
               sta $0400,x    // Write char to screen
               inx
               jmp loop
          out:
               rts

          text: 
               .text "ROM BANK 0"
               .byte $FF
     }
     
     loop: 
     {
          inc $D020
          jmp loop            // infinite loop
     } 
}

* = $9FFF
     .byte 0