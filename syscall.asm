.data
coca_cola: .asciiz "coca cola"
fanta: .asciiz "Fanta"
sprite: .asciiz "sprite"
inca: .asciiz "Inca coola"
agua: .asciiz "Agua"
gatorade_naranja: .asciiz "Gatorade naranja"
gatorade_lima: .asciiz "Gatorade lima"
esporade_mandarina: .asciiz "Esporade mandarina"
esporade_manzana: .asciiz "Esporade manzana"
lipton_tea: .asciiz "liption tea"
brisk_lemon_tea: .asciiz "brisk lemon tea"

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


