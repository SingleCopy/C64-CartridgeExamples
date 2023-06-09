#import "libDefines.asm"

.segmentdef Bank_00_0_Text [start=$8100, min=$8100, max=$9fff, fill]

.encoding "screencode_upper"
.segment Bank_00_0_Text
*=displayTextAddress
{
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
               .text "ROM BANK 1"
               .byte $FF
     }
}