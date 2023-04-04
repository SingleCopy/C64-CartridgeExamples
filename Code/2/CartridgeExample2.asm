//==============================================================================
//                        Cartridge Example 2
//
//  Use segmentdef to define the memory in the correct place in the file, 
//  use .pseudopc to execute the .segment Bank_00_0 at address $8000 when
//  the C64 starts up.
//==============================================================================

#import "../../CartridgeLibrary/libCartridgeIncludes.asm"

.segment CARTRIDGE_FILE [outBin="CartridgeExample2.crt"]
.segmentout [segments = "Cartridge_Header"]
.segmentout [segments = "Bank_00_0"]
.segmentout [segments = "Bank_End"]

.segmentdef Cartridge_Header [start=$0000, min=$0000, max=$004F, fill]
.segmentdef Bank_00_0 [start=$0050, min=$0050, max=$1FFF, fill]
.segmentdef Bank_End [start=$2000, min=$0, max=$7e04f, fill]

.encoding "ascii"
.segment Cartridge_Header
	.text "C64 CARTRIDGE   "
	.byte $00, $00      //header length
	.byte $00, $40      //header length
	.word $0001         //version
	.word $0500         //crt type
	.byte $00           //exrom line
	.byte $00           //game line
	.byte $00, $00, $00, $00, $00, $00  //unused
	.text "Cartridge Example 2"

*=$0040
     SET_CARTRIDGE_HEADER_V(0);

.segment Bank_00_0
.pseudopc $8000 
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
                    .encoding "screencode_upper"
                    .text "ROM BANK 0"
                    .byte $FF
          }
          
          loop: 
          {
               inc $D020
               jmp loop            // infinite loop
          }
     } 
}

.segment Bank_End
* = $9FFF
     .byte 0