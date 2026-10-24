BITS 16
ORG 0x7C00

; stage one, first sector
%include "src/boot/boot_sector.asm"

; stage two
%include "src/boot/real_mode.asm"
%include "src/boot/gdt.asm"
%include "src/boot/protected_mode.asm"