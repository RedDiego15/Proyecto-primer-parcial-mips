.data
titulo: .asciiz "Tall"
input: .asciiz "Ingrese un numero del 1 -10\n"
tall: .asciiz "tall"
random: .asciiz "Random:"
salto_linea: .asciiz "\n"

.text

#imprimir titulo
li $v0, 4
la $a0, titulo
syscall



#imprimir mensaje de input
li $v0, 4
la $a0, input
syscall

#Leer entero
li $v0, 5
syscall

move $t0, $v0

#Generar un random hasta el 10
li $v0, 42
li $a1, 10
syscall

move $t1, $a0

#Imprimir el random (entero)
li $v0, 1
move $a0, $t1
syscall

End:

li $v0, 10


