.model small ; for EXE
.stack 200h ; stack segment

.data ;data segment   

string_enter db "Enter string:",0Dh,0Ah,'$'
word db "number", 0Dh 
error db "Invalid input!",0Dh,0Ah,'$' 
string db 200 dup('$')  
new_string db 0Dh, 0Ah, '$'

.code
output macro str
    lea dx, str
    mov ah, 9
    int 21h
endm

start:
mov ax, @data
mov ds, ax    
jmp notice_for_user_input

error_input:  
output error
jmp end_of_programm

notice_for_user_input:
output string_enter

mov ah, 0Ah; user input
mov dx, offset string
int 21h   
 
output new_string

start_main_programm:
mov di, 2
mov si, 2
push di

start_main:
pop bx
push bx
mov di, bx

finding_symbols:
cmp string[di], '$'
je end_of_programm 
cmp string[di], 0dh
je end_of_programm
cmp string[di], ' '
jne start_check
inc di
jmp finding_symbols

start_check:
push di; here will be index of the word which consist of numbers 
 
lower_or_equal:
mov dl, 39h; ascii hex '9'
mov dh, string[di]
cmp dh, dl
jle greater_or_equal:
inc di
jmp finding_symbols 
 
greater_or_equal:
mov dl, 30h; ascii hex '0'
mov dh, string[di]
cmp dh, dl
jge it_is_number
inc di
jmp finding_symbols 
   
it_is_number:
inc di
jmp it_is_a_number_word

it_is_a_number_word:
cmp string[di], '$'
je first_index_check 
cmp string[di], 0dh
je first_index_check
cmp string[di], ' '
je first_index_check  
jmp lower_or_equal
 
first_index_check: ;this check for situation, where
;symbol is before the number, like this: t67, yyy88
pop si; si - first index of number word
push si 
cmp si, 2
je start_inserting
dec si
cmp string[si], ' '
je start_inserting
jmp finding_symbols
 
start_inserting:
xor si, si
jmp word_length

counter:
inc si

word_length:
mov bx, word[si]
cmp bh, 0dh
jne counter 

end_counter:
mov di, 2
jmp string_length

last_position_search:
inc di

string_length:
cmp string[di], '$'
jne last_position_search

add si, di      
inc si; it's length of the inserted word + the remaining line
dec di

moving_number:
mov bl, string[di]
mov string[si], bl
dec di
dec si
pop bx
push bx
cmp di, bx
jne moving_number; until we get to the beginning of the inserted word
mov bl, string[di]
mov string[si], bl

start_insert_word:
mov di, 0
jmp insert_word

q:
inc di

insert_word:
mov ax, word[di]
pop bx
push bx
mov string[bx], al
inc di
pop bx
inc bx
push bx
cmp word[di], 0dh
je insert_space 
pop bx
push bx
cmp bx, si
je insert_space
jmp insert_word

insert_space:
dec si
mov string[si], ' '      
 
if_we_have_another_numword:
pop bx; bx equals first index of numword
inc bx
push bx
cmp string[bx], 0Dh
je end_of_programm
cmp string[bx], ' '
je start_main
jmp if_we_have_another_numword

end_of_programm:
mov dx, offset string 
add dx, 2h
mov ah, 9
int 21h
mov ah, 01h; just like system("pause")
int 21h  
end start








