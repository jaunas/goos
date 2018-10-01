[bits 16]
; Switch to protected mode
switch_to_pm:
  cli                   ; We must switch off interrupts until we have set-up the
                        ; protected mode interrupt vector otherwise interrupts
                        ; will run riot.

  lgdt [gdt_descriptor] ; Load our global descriptor table, which defines the
                        ; protected mode segments (e.g. for code and data)

  mov eax, cr0          ; To make the switch to protected mode, we set the first
  or eax, 0x1           ; bit of CR0, a control register
  mov cr0, eax

  jmp CODE_SEG:init_pm


[bits 32]
; Initialize registers and the stack once in PM.
init_pm:
  mov ax, DATA_SEG  ; Now in PM, our old segments are meaningless, so we point
  mov ds, ax        ; our segment registers to the data selector we defined in
  mov ss, ax        ; our GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000
  mov esp, ebp

  call BEGIN_PM
