; A boot sector that enters 32 - bit protected mode.
[org 0x7c00]
KERNEL_OFFSET equ 0x1000  ; This is the memory offset to which we'll load kernel

  mov [BOOT_DRIVE], dl  ; BIOS stores boot drive in DL, so it's best to remember
                        ; this for later.

  mov bp, 0x9000        ; Set the stack.
  mov sp, bp

  mov bx, MSG_REAL_MODE ; Announce that we're starting booting from 16-bit real
  call print_string     ; mode

  call load_kernel      ; Load kernel

  call switch_to_pm     ; Switch to protected mode, from which we won't return
  jmp $

%include "boot/real/print_string.asm"
%include "boot/real/print_hex.asm"
%include "boot/real/disk_load.asm"
%include "boot/PM/gdt.asm"
%include "boot/PM/print_string.asm"
%include "boot/PM/switch_to_pm.asm"

[bits 16]
; load_kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL ; Announce that we're loading kernel
  call print_string

  mov bx, KERNEL_OFFSET   ; Set-up parameters for disk_load, so that we load the
  mov dh, 15              ; 15 sectors (excluding the boot sector) from the boot
  mov dl, [BOOT_DRIVE]    ; disk (i.e. kernel code) to address KERNEL_OFFSET
  call disk_load

  ret

[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm    ; Use our 32 - bit print routine.

  call KERNEL_OFFSET  ; Jump to kernel code

  jmp $ ; Hang.

; Global variables
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16 - bit Real Mode", 0x0a, 0x0d, 0
MSG_PROT_MODE   db "Successfully landed in 32 - bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0x0a, 0x0d, 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
