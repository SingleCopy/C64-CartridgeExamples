//==============================================================================
//                        Cartridge Example 3
//
//  Use segmentdef to define the memory in the correct place in memory. 
//  Convert to cartridge to run
//==============================================================================

#import "../../CartridgeLibrary/libCartridgeIncludes.asm"

.segment CARTRIDGE_FILE [outBin="CartridgeExample3.bin"]
.segmentout [segments = "Bank_00_0"]
.segmentout [segments = "Bank_End"]

.segmentdef Bank_00_0 [start=$8000, min=$8000, max=$9fff, fill]
.segmentdef Bank_End [start=$9FFF, min=$0, max=$7dfff, fill]

.encoding "screencode_upper"

.segment Bank_00_0
{
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
     }

     loop:
     {
          inc $D020
          jmp loop            // infinite loop
     }
}

.segment Bank_End
* = $9FFF
     .byte 0