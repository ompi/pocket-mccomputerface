%.bin: %.asm
	lhasm -o /tmp/wut.bin -T $<
	dd if=/dev/zero bs=1024 count=32 | tr "\000" "\377" > $@
	cat /tmp/wut.bin >> $@
	dd if=/dev/zero bs=$$((128 * 1024 - `stat $@ --print="%s"`)) count=1 | tr "\000" "\377" >> $@

program: at.bin
	flashrom -p rpi -w $<

clean:
	rm *.bin
