
#import "libCartridgeDefines.asm"

.macro SET_CARTRIDGE_HEADER_V(wBank)
{
	.encoding "ascii"
	.text "CHIP"
	.byte $00, $00, $20, $10    //chip length
	.byte $00, $00              //chip type
	.byte >wBank, <wBank        //bank
	.byte $80, $00              //adress
	.byte $20, $00              //length   
}

.macro SET_CARTRIDGE_ROM_BANK_V(bRomBank)
{
	lda #bRomBank				// Store the rom bank
	ora #%10000000				// Ensure that bit 8 is set
	sta RomBankSelector			// Store the value in the ROM Bank selector memory address
}