[DEFAULT ABS]

; stage one, first sector
%include "bootloader/src/boot_sector.asm"

; stage two, general booting
%include "bootloader/src/real_mode.asm"
%include "bootloader/src/gdt.asm"
%include "bootloader/src/protected_mode.asm"

; stage three, prepare for kernel
%include "bootloader/src/long_mode.asm"