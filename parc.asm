; 1152269 Daniela Alejandra Barreto Ibarra
; 1152281 Brayan Sebastian Gonzalez Gonzalez

.model small
.386
.stack 64
.data

UFPS LABEL BYTE
MAX_UFPS DB 128
REAL_UFPS DB ?
UFPS_ESPACE DB 129 DUP('$')

CADENA LABEL BYTE
MAX_CADENA DB 9
REAL_CADENA DB ?
CADENA_ESPACE DB 10 DUP('$')

VECTOR LABEL BYTE
MAX_VECTOR DB 9
REAL_VECTOR DB ?
VECTOR_ESPACE DB 10 DUP('$')

salto_linea db 10, 13, '$'

MEN_UFPS db 10, 13, "Ingrese el texto a encriptar (EN MAYUSCULAS):$"
MEN_CADENA db 10, 13, "Ingrese la cadena a encriptar e insertar (EN MAYUSCULAS):$"
MEN_VECTOR db 10, 13, "Ingrese el vector de encriptacion (sin espacio):$"

.code
encriptar proc near
  mov ax, @data
  mov ds, ax         

  lea dx, MEN_UFPS
  call mostrar
  lea dx, UFPS
  call captura

  lea dx, MEN_CADENA
  call mostrar
  lea dx, CADENA
  call captura

  lea dx, MEN_VECTOR
  call mostrar
  lea dx, VECTOR
  call captura

  lea si, VECTOR_ESPACE
  mov cl, REAL_VECTOR
  xor ch, ch

; Convertir caracteres de VECTOR a numeros

asc_num:
  mov al, [si]
  sub al, 48
  mov [si], al
  inc si
  loop asc_num

; Encriptar ufps

  mov al, REAL_UFPS
  xor ah, ah
  mov cx, ax
  lea si, UFPS_ESPACE
  lea di, VECTOR_ESPACE
  mov bx, di
  add bx, 8
ciclo:
  mov al, [si]
  cmp al, 65
  jb recorrido
  cmp al, 91
  jae recorrido
  add al, [di]
  cmp al, 5AH 
  jbe no_ajustar
  sub al, 1AH
no_ajustar:
  mov [si], al
recorrido:
  inc di
  cmp di, bx
  jb continuar
  lea di, VECTOR_ESPACE
continuar:
  inc si
  loop ciclo

; Encriptar cadena

  xor cx, cx
  xor dx, dx
  lea si, CADENA_ESPACE
  lea di, VECTOR_ESPACE
  mov cl, REAL_CADENA
  xor ax, ax
  mov dx, di
  add dl, REAL_VECTOR
cicl:
  lea bx, UFPS_ESPACE
  push dx
  mov dl, [di]
  xor dh, dh
  add bx, dx
  mov al, [si]
  mov [bx], al
route:
  inc di
  pop dx
  cmp di, dx
  jb continue
  lea di, VECTOR_ESPACE
continue:
  inc si
  loop cicl

  lea dx, salto_linea
  call mostrar
  
  lea dx, UFPS_ESPACE
  call mostrar

  mov ax, 4c00h
  int 21h
encriptar endp

CAPTURA proc near 
  mov ah, 0ah            
  int 21h                
  ret                    
CAPTURA endp

MOSTRAR proc near 
  mov ah, 09h 
  int 21h 
  ret 
MOSTRAR endp 
end
