section .data
    ; Change this number to test odd and even values
    number dd 7

    evenMessage db "even number", 10
    evenLength equ $ - evenMessage

    oddMessage db "odd number", 10
    oddLength equ $ - oddMessage

section .text
    global _start

_start:
    ; Load the number
    mov eax, [number]

    ; Clear EDX before division
    xor edx, edx

    ; Divide the number by 2
    mov ebx, 2
    div ebx

    ; A remainder of zero means even
    cmp edx, 0
    je even_number

odd_number:
    mov eax, 4
    mov ebx, 1
    mov ecx, oddMessage
    mov edx, oddLength
    int 0x80

    jmp exit_program

even_number:
    mov eax, 4
    mov ebx, 1
    mov ecx, evenMessage
    mov edx, evenLength
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
