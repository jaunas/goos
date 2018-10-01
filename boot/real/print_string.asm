; Print string function using BIOS interrupts

print_string:
    pusha

start:
    mov al, [bx]  ; get char from pointer
    cmp al, 0     ; check whether end of string
    je done

    mov ah, 0x0e  ; BIOS tele-type
    int 0x10

    add bx, 1 ; increment pointer
    jmp start

done:
    popa
    ret
