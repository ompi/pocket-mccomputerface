%.bin: %.asm
	lhasm -T $<
	dd if=/dev/zero of=$@ bs=1 count=1 seek=131071

program: send.bin
	flashrom -p rpi -w $<
