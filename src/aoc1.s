global main
extern scanf, printf

; this code should go something like
; int main() {
;   uint32_t numbers[200];
;   uint32_t i = 0;
;   while(i < 200) {
;     scanf("%5hu", &numbers[i])
;     i++;
;   }
;   uint32_t x = 0;
;   uint32_t y = 1;
;   while(x < 199) {
;     y = x + 1;
;     while(y < 200) {
;       if(numbers[x] + numbers[y] == 2020) {
;         goto found;
;       }
;       y++;
;     }
;     x++;
;   }
;   label found:
;     printf("%d", (uint64_t)(numbers[x]*numbers[y]));
; }

; this will be an O(n^2) algorithm; O(n) linear scan * n elements
; this can be reduced with a hash map, but i'd have to
; figure out how to write that in assembly
; ~20k elements should be pretty quick anyway

; rdi, rsi, rdx, rcx, r8, r9 for ints & ptr func args
; rax is number of extra arguments for varargs, to pull off stack
; ints & ptrs are returned in rax

section .data
scanf_format:
    db "%llu", 0                    ; should set a cap on characters read per iteration
printf_lhs_format:
    db "lhs: %llu", 10, 0
printf_rhs_format:
    db "rhs: %llu", 10, 0
printf_answer_format:
    db "answer: %llu", 10, 0

section .bss
numbers: resq 200                   ; we know there are exactly 200 elements to pull

section .text
main:
    mov rsi, 0
loop_read_number:
    cmp rsi, 200*8                  ; only fill 1600 bytes
    je find_sum_to_2020
    push rsi                        ; simultaneously save accumulator and get us stack-aligned
    add rsi, numbers                ; do some pointer arithmetic to write number to right place
    mov rdi, scanf_format
    mov rax, 0
    call scanf                      ; we should be checking for eof or error but we don't
    pop rsi

    add rsi, 8                      ; reading 8 bytes every loop
    jmp loop_read_number
find_sum_to_2020:
    mov rbx, 0  ; x
    mov rcx, 8  ; y
outer:
    cmp rbx, 199*8                  ; have we run out of elements yet?
    je found
    mov rcx, rbx                    ; y = x + 1
    add rcx, 8
inner:
    cmp rcx, 200*8
    je outer2
    mov rdx, 0                      ; numbers[x] + numbers[y] == 2020 ?
    add rdx, [numbers + rbx]
    add rdx, [numbers + rcx]
    cmp rdx, 2020
    je found
    add rcx, 8
    jmp inner
outer2:
    add rbx, 8
    jmp outer
found:
    push rcx
    push rbx
    mov rsi, [numbers + rbx]
    mov rdi, printf_lhs_format      ; debug printout for left number
    mov rax, 0
    call printf
    pop rbx
    pop rcx

    push rbx
    push rcx
    mov rsi, [numbers + rcx]
    mov rdi, printf_rhs_format      ; debug printout for right number
    mov rax, 0
    call printf
    pop rcx
    pop rbx

    mov rax, 0
    mov rax, [numbers + rbx]
    mov rbx, [numbers + rcx]
    mul ebx
    push rax                       ; to stack-align us for printf call and give printf a pointer
    mov rsi, [rsp]
    mov rdi, printf_answer_format
    mov rax, 0
    call printf
    pop rax
    mov rax, 0                      ; rc=0, normal exit
    ret