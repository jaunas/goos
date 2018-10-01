[bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string poiunted to by EDX
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY ; set EDX to the start of VIDEO_MEMORY

print_string_pm_loop:
  mov al, [ebx]           ; store the char at EBX in AL
  mov ah, WHITE_ON_BLACK  ; store the attributes in AH

  cmp al, 0 ; check wheter end of string
  je done

  mov [edx], ax ; store char and attributes at current character cell
  add ebx, 1    ; increment EBX to the next char in string
  add edx, 2    ; move to next character cell in VIDEO_MEMORY

  jmp print_string_pm_loop ; next character

print_string_pm_done:
  popa
  ret
