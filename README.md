# C64-CartridgeExamples
Example code on how to create a cartridge file using Kick Assembler

## Cartridge Convertor
All these examples use cartconv.exe to convert the output .bin file from Kick Assember to a .crt file. The cartconv.exe can be located in your WinVICE\bin directory

## Cartridge Example 1
This CartridgetExample1.asm shows how you can create a 8kb cartridge. Once you have compiled the CartridgeExample1.asm using Kick Assembler `KickAss.jar` you will need to convert the output CartridgetExample1.bin file using cartconv.exe.

To run this file you will need to convert the .bin using the following command: `cartconv.exe -t normal -n 'CartridgeExample1' -i 'CartridgeExample1.bin' -o 'CartridgeExample1.crt'`

## Cartridge Example 2
CartridgetExample2.asm shows how you can created a crt without having to use `cartconv.exe`. This issue with this approach is that you need to use `.segementdef` to ensure   `Bank_00_0` is located in the correct address in the file, however you need use `.pseudopc $8000` to ensure Kick Assembler uses the right memory address when executing as address $0050 in the file will be mapped to address $8000 in memory. As you cannot nested `.pseudopc` directives you are stuck in the $8000 address range. Note that for the cartridge header, you need to call `.encoding "ascii"` otherwise the wrong bytes are written to the .bin file.

## Cartridge Example 3
CartridgetExample3.asm is very similar to CartridgetExample2.asm, except the `.segmentdef` directive is used to place the segment `Bank_00_0` to memory address $8000. Another ROM bank segemnt `Bank_End` is used to pad the remaining ROM banks as an `ocean` cartidge expected 64 ROM banks totalling 512KB. 

To run this file you will need to convert the .bin using the following command: `cartconv.exe -t ocean -n 'CartridgeExample3' -i 'CartridgeExample3.bin' -o 'CartridgeExample3.crt'`

## Cartridge Example 4
Now that a cartridge can be loaded and execute it at address $8000, the next step is to copy the ROM into RAM and execute it. This is required as when ROM banks are switched, it is best to not be within the executing address range $8000 - $9FFF when this occurs as the data in that address will change. The `copyRelocateCodeToRam` subroutine only copies the `RelocateCode` subroutine to address $8001 and jumps to it. The `RelocateCode` moves the remaining cartridge data to RAM, starting at address $1000. Finally the `bootLoader` is executed that jumps to the subroutine `textSetup` on the cartridge before staying the `loop` subroutine. 

To run this file you will need to convert the .bin using the following command: `cartconv.exe -t ocean -n 'CartridgeExample4' -i 'CartridgeExample4.bin' -o 'CartridgeExample4.crt'`

## Cartridge Example 5
This example builds on the previous example except it now have 2 ROM banks. After all of the previous steps in `Cartridge Example 4` has been executed and the `loop` subroutine is running, the keyboard is checked to see if the spacebar has been pressed. When the spacebar is detected, it writes the value 1 to memory address $DE00. In ocean cartridges, this will trigger switching the ROM bank to 1 (Bank_01_0). Then the subroutine `displayTextAddress` is called except now the one in ROM bank 1 is executed. Finally the `loop` subroutine is called in RAM.

To run this file you will need to convert the .bin using the following command: `cartconv.exe -t ocean -n 'CartridgeExample5' -i 'CartridgeExample5.bin' -o 'CartridgeExample5.crt'`

## Cartridge Example 6
This example is exactly the same code as the previous example except that now ROM bank 00_0 is split across 2 files and ROM bank 01_0 is in its own file. After the `bootLoader` code has been copied to RAM and executed, it calls the `displayTextAddress` which is still in ROM bank 00_0. Once the space bar is pressed, `SET_CARTRIDGE_ROM_BANK_V` is called which switches it to ROM bank 1 (Bank_01_0). 

To run this file you will need to convert the .bin using the following command: `cartconv.exe -t ocean -n 'CartridgeExample6' -i 'CartridgeExample6.bin' -o 'CartridgeExample6.crt'`
