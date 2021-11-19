.data
coca_cola: .asciiz "1 coca cola"
fanta: .asciiz "2 Fanta"
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
array:      .word coca_cola, fanta, sprite,inca, agua, gatorade_naranja, gatorade_lima, esporade_mandarina, esporade_manzana, lipton_tea, brisk_lemon_tea
input: .asciiz "Ingrese\n"
billetes: .word 1,5,10,20
temp: .space 4
.text


#etiqueta de validación del arreglo billetes  beq valor, 1,ValidarBilletes 
#s1 tiene el valor ingresado del billete o moneda
ValidarDinero: 
	la $t0, billetes #arreglo de billetes A=[1,5,10,20]
	li $t1,0 #i=0
	li $t2,0 #temp = 0
	li $t3,4 #constante length = 4
	slt $t4, $t1, $t3 # i<4 , 1 True, 0 False
	beq $t4,$zero,Maquina #if(1/0==0) Maquina
	sll $t5, $t1,2
	add $t5,$t0, $t5 # La base del arreglo es billetes
	lw $t6, 0($t5) #Billetes[i]
	bne $t6,$t7,DineroValido #t6 es el valor el arreglo en i posicion, $t7 es el valor igresado por consola 
	addi $t1,$t1,1 # i+1
	j ValidarDinero 
	
DineroValido:
	li $t2,1 #temp = 1
	 
	
	
#imprimir titulo
li $v0, 4
la $a0, array
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
