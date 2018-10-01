; load DH sectors to ES:BX from drive DL
disk_load:
  pusha
  push dx       ; Store DX on stack so later we can recall how many sectors were
                ; request to be read, even if it is altered in the meantime
  mov ah, 0x02  ; BIOS read sector function
  mov al, dh    ; Read DH sectors
  mov ch, 0x00  ; Select cylinder 0
  mov dh, 0x00  ; Select head 0
  mov cl, 0x02  ; Start reading from second sector (i.e. after the boot sector)
  int 0x13      ; BIOS interrupt

  jc disk_error

  pop dx              ; Restore DX from the stack
  cmp al, dh          ; if sectors read != sectors expected
  jne sectors_error   ;   display error message
  popa
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  mov dh, ah      ; ah = error code, dl = disk drive that dropped the error
  call print_hex  ; check out the code at http://stanislavs.org/helppc/int_13-1.html
  jmp disk_loop

sectors_error:
  mov bx, SECTORS_ERROR
  call print_string

disk_loop:
  jmp $

; Variables
DISK_ERROR_MSG  db "Disk read error!", 0x0a, 0x0d, 0
SECTORS_ERROR   db "Incorrect number of sectors read", 0x0a, 0x0d, 0
