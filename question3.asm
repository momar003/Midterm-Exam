section
 .data
    ; Change this value to test another number
    number dd 7
    divisor dd 2

    oddMessage db "odd number", 10
    oddLength  equ $ - oddMessage

    evenMessage db "even number", 10
    evenLength  equ $ - evenMessage

section .text
    global _start

_start:
    ; Place the number in EAX
    mov eax, [number]

    ; Clear EDX before division
    mov edx, 0

    ; Divide the number by 2
    ; EDX will contain the remainder
    div dword [divisor]

    ; Compare the remainder with zero
    cmp edx, 0

    ; Jump when the remainder is zero
    je even_number

odd_number:
    ; Display "odd number"
    mov eax, 4
    mov ebx, 1
    mov ecx, oddMessage
    mov edx, oddLength
    int 0x80

    jmp exit_program

even_number:
    ; Display "even number"
    mov eax, 4
    mov ebx, 1
    mov ecx, evenMessage
    mov edx, evenLength
    int 0x80

exit_program:
    ; Exit the program
    mov eax, 1
    mov ebx, 0
    int 0x80

