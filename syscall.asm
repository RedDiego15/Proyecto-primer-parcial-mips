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

input_tipo_dinero: .asciiz "1. Ingreso Billetes\n2. Ingreso Monedas\n3. Salir\nIngrese opcion\n "
input_billete: .asciiz "Ingrese valor del billete\n"
input_continue_ingreso: .asciiz "Desea Ingresar mas Dinero?\n 1.Si\nInserte cualquier digito para continuar\n "

.text

#main
#maquina:
#	li $v0, 4
#	la $a0, input_tipo_dinero
#	syscall	
#	li $v0, 5	#pide que se ingrese un numero entero
#	syscall
#	move $t0,$v0	#$t0 almacena la opcion de si va ingresar billetes o monedas
#	 
#	beq $t0,1,cuentaBilletes
	#beq $t0,2,cuentaMonedas
	#beq $t0,3,salir
	
cuentaBilletes:
	li $a0, 0	#acumulador
	jal loopPedirBilletes
	move $t0,$v0  #t0 almacena el total de dinero ingresado
	li $t1,1 #vuelvo al main
	
	
loopPedirBilletes:
	
	addi $sp,$sp,12
	sw $a0,0($sp)
	sw $ra,4($sp)
	sw $s0,8($sp)
	
	move $s0,$a0
	li $a0,0
	jal pedirDineroBilletes
	move $a0,$v0	#almaceno en a0 el valor del billete ingresado
	li $a1,0 #i=0
	jal validarBilletes
	#Hasta este punto estoy seguro que $v0 de la llamada validar billetes contiene un numero correcto de billete
	
	add $s0,$s0,$v0 #le sumo al acumulador el valor del billete ingresado
	
	li $v0, 4
	la $a0, input_continue_ingreso
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	
	lw $a0,0($sp)
	lw $ra,4($sp)
	
	move $a0,$s0
	lw $s0,8($sp)
	addi $sp,$sp,-12
	
	beq $t0,1, loopPedirBilletes
	
	move $v0,$a0
	jr $ra 
	
	
	
pedirDineroBilletes:
	li $v0, 4
	la $a0, input_billete
	syscall
	
	li $v0, 5
	syscall
	
	jr $ra	#retorno el valor del billete ingresado

#main:

	
			

#etiqueta de validación del arreglo billetes  beq valor, 1,ValidarBilletes 
#s1 tiene el valor ingresado del billete o moneda
validarBilletes:
	la $t0, billetes #arreglo de billetes A=[1,5,10,20]
	li $t2,1 #temp = 0
	li $t3,4 #constante length = 4
	slt $t4, $a1, $t3 # i<4 , 1 True, 0 False
	beq $t4,$zero,pedirDineroBilletes #if(1/0==0) 
	sll $t5, $a1,2
	add $t5,$t0, $t5 # La base del arreglo es billetes
	lw $t6, 0($t5) #Billetes[i]
	addi $t1,$a1,1 # i+1
	bne $t6,$a0,validarBilletes 
	beq $t6,$a0,DineroValido #t6 es el valor el arreglo en i posicion, $a0 es el valor igresado por consola 
	move $v0,$t2
	jr $ra
	
	
DineroValido:
	li $t2,1 #temp = 1
	move $v0,$t2
	jr $ra
	 
	






