//==============================================================================
//                        Cartridge Example 6
//
//  This example has 3 ROM banks, this example is similar to the previous 
//  example except now the rom banck are in different files
//==============================================================================
#import "libDefines.asm"
#import "../../CartridgeLibrary/libCartridgeIncludes.asm"
#import "Bank_01_0.asm"
#import "Bank_02_0.asm"

.segment CARTRIDGE_FILE [outBin="CartridgeTest6.bin"]
.segmentout [segments = "Bank_00_0"]
.segmentout [segments = "Bank_01_0"]
.segmentout [segments = "Bank_02_0"]
.segmentout [segments = "Bank_End"]

.segmentdef Bank_00_0 [start=$8000, min=$8000, max=$9fff, fill]
.segmentdef Bank_End [start=$9FFF, min=$0, max=$79fff, fill]

.segment Bank_00_0
{
     .const copyProgramRomAddress = $8060
     .const copyProgramRamAddress = $0801
     .const bootLoaderRomAddress = $8080
     .const bootLoaderRamAddress = $1000

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
          lda #1
          sta XMAX            // disable keyboard buffer
          lda #127
          sta RPTFLG          // disable key repeat

          jsr copyRelocateCodeToRam
          jmp copyProgramRamAddress
     }


     // Copy the RelocateCode to $0801 so we are protected from bankswitching
     copyRelocateCodeToRam:
     {    
          ldx #$00  
          
          copyloop:
               lda copyProgramRomAddress,x    // load byte from source address
               sta copyProgramRamAddress,x    // store byte at destination address
               inx                           // increment low byte of source address
               cpx #$20                      // Compare the low byte of the source address to $20
               bne copyloop                  // if not, continue copying
               rts
     }

     *=copyProgramRomAddress
     .pseudopc copyProgramRamAddress 
     {
          RelocateCode: 
          {
               ldx #$00

               RELsource:   
                    lda bootLoaderRomAddress,x
               RELdestination:   
                    sta bootLoaderRamAddress,x
                    inx
                    bne RELsource

                    inc RELsource+2
                    inc RELdestination+2

                    lda RELsource+2
                    cmp #>$a0000
                    bne RELsource

                    jmp bootLoaderRamAddress
          }
     }


     *=bootLoaderRomAddress
     .pseudopc bootLoaderRamAddress
     {
          bootLoader:
          {
               // Set text in cartridge
               SET_CARTRIDGE_ROM_BANK_V(1)
               jsr displayTextAddress

               loop:
               {
                    inc EXTCOL          // Make the border flash
                    jsr checkKeypress
                    jmp loop            // infinite loop
               }
               
               checkKeypress:
               {
                    jsr SCNKEY
                    jsr GETIN

                    spacebarCheck:
                    {
                         cmp #$20
                         bne checkKeysEnd
                         inc EXTCOL
                         jmp switchRomBank
                    }

                    checkKeysEnd:
                    {
                         ldy #28
                    }   
                    rts
               } 

               switchRomBank:
               {
                    SET_CARTRIDGE_ROM_BANK_V(2)
                    jsr displayTextAddress
                    jmp loop            
               }
          }
     }
}

.segment Bank_End
     .byte 0