# Midterm Exam

## Question 1: Arithmetic in Assembly

The equation is:

```text
result = (var1 + 2) / (var3 - var2)
```

The following values are used:

```text
var1 = 10
var2 = 2
var3 = 6
```

Substitute the values into the equation:

```text
result = (10 + 2) / (6 - 2)
result = 12 / 4
result = 3
```

The quotient is `3`, and the remainder is `0`.

### Assembly Code

```nasm
section .data
    ; var1 = 10, var2 = 2, var3 = 6, result = 3
    var1       dd 10
    var2       dd 2
    var3       dd 6
    result     dd 0

    resultText db "Result: "
    resultLen  equ $ - resultText

    newline    db 10

section .bss
    output resb 1

section .text
    global _start

_start:
    ; Calculate var1 + 2
    mov eax, [var1]
    add eax, 2

    ; Calculate var3 - var2
    mov ebx, [var3]
    sub ebx, [var2]

    ; Clear EDX before unsigned division
    mov edx, 0

    ; Divide EDX:EAX by EBX
    ; EAX receives the quotient
    ; EDX receives the remainder
    div ebx

division_complete:
    ; Save the quotient in result
    mov [result], eax

    ; Convert the single-digit result to ASCII
    add al, '0'
    mov [output], al

    ; Display "Result: "
    mov eax, 4
    mov ebx, 1
    mov ecx, resultText
    mov edx, resultLen
    int 0x80

    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 0x80

    ; Display a new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit the program
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Expected Console Output

```text
Result: 3
```

### Quotient and Remainder Table

When the `DIV` instruction is used in 32-bit x86 Assembly, the quotient is stored in `EAX`, and the remainder is stored in `EDX`.

| Register Name |         Value |
| ------------- | ------------: |
| EAX           |  3 — quotient |
| EDX           | 0 — remainder |

### GDB Verification

Compile the program with debugging information:

```bash
nasm -f elf32 -g -F dwarf question1.asm -o question1.o
ld -m elf_i386 question1.o -o question1
```

Start GDB:

```bash
gdb ./question1
```

Enter these commands inside GDB:

```gdb
break division_complete
run
info registers eax edx
```

The register information should show values similar to:

```text
eax    0x3    3
edx    0x0    0
```

Take a screenshot showing the `EAX` and `EDX` values and save it in the repository as:

```text
gdb-question1.png
```

Embed the screenshot here:

```markdown
![Question 1 GDB verification](gdb-question1.png)
```

---

## Question 2: K-Map Simplification

The original Boolean equation is:

```text
Y = a.b + a'.b + a.b'
```

### K-Map

| a \ b |  0 |  1 |
| ----- | -: | -: |
| 0     |  0 |  1 |
| 1     |  1 |  1 |

The right column contains two adjacent `1` values:

```text
a'.b + a.b = b
```

The bottom row also contains two adjacent `1` values:

```text
a.b' + a.b = a
```

Combining the two groups gives:

```text
Y = a + b
```

### Algebraic Verification

Start with:

```text
Y = a.b + a'.b + a.b'
```

Combine the first two terms:

```text
Y = b(a + a') + a.b'
```

Because:

```text
a + a' = 1
```

The equation becomes:

```text
Y = b + a.b'
```

Using the Boolean identity:

```text
x + y.z = (x + y)(x + z)
```

We get:

```text
Y = (b + a)(b + b')
```

Because:

```text
b + b' = 1
```

The simplified result is:

```text
Y = a + b
```

### Final Answer

```text
Y = a + b
```

---

## Question 3: Odd or Even Number

### Design and Thought Process

An even number is completely divisible by `2`, so its remainder is `0`.

An odd number is not completely divisible by `2`, so its remainder is `1`.

This program uses the `DIV` instruction instead of the `AND` or `OR` logical instructions.

The steps are:

1. Place the number in the `EAX` register.
2. Place `0` in `EDX` before division.
3. Divide the number by `2`.
4. Check the remainder stored in `EDX`.
5. When `EDX` equals `0`, display `even number`.
6. Otherwise, display `odd number`.
7. Exit the program.

### Pseudocode

```text
START

number = 7

Divide number by 2

IF remainder equals 0
    Display "even number"
ELSE
    Display "odd number"
END IF

STOP
```

### Flowchart

```text
        +------------------+
        |      Start       |
        +--------+---------+
                 |
                 v
        +------------------+
        | Load the number  |
        +--------+---------+
                 |
                 v
        +------------------+
        | Divide number    |
        | by 2             |
        +--------+---------+
                 |
                 v
        +------------------+
        | Is remainder 0?  |
        +----+---------+---+
             |         |
            Yes        No
             |         |
             v         v
    +-------------+  +-------------+
    | Display     |  | Display     |
    | even number |  | odd number  |
    +------+------+  +------+------+
           |                |
           +--------+-------+
                    |
                    v
             +-------------+
             |    Stop     |
             +-------------+
```

### Assembly Code

```nasm
section .data
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
```

The program does not use the `AND` or `OR` instructions.

### Expected Output

Because the selected number is `7`, the output is:

```text
odd number
```

When the number is changed to an even number such as `8`, the output is:

```text
even number
```

### Compiling and Running Question 3

```bash
nasm -f elf32 -g -F dwarf question3.asm -o question3.o
ld -m elf_i386 question3.o -o question3
./question3
```
