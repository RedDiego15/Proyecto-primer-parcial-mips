.data
coca_cola: .asciiz "1. coca cola 10$\n"
fanta: .asciiz "2. Fanta 10$\n"
sprite: .asciiz "3. sprite 10$\n"
inca: .asciiz "4. Inca coola 10$\n"
agua: .asciiz "5. Agua 10$\n"
gatorade_naranja: .asciiz "6. Gatorade naranja 10$\n"
gatorade_lima: .asciiz "7. Gatorade lima 10$\n"
esporade_mandarina: .asciiz "8. Esporade mandarina 10$\n"
esporade_manzana: .asciiz "9. Esporade manzana 10$\n"
lipton_tea: .asciiz "10. liption tea 10$\n"
brisk_lemon_tea: .asciiz "11. brisk lemon tea 10$\n"

array: .word coca_cola, fanta, sprite
array_stock: .word 2,5,5
array_precios: .word 5,10,10
input: .asciiz "Ingrese\n"
billetes: .word 1,5,10,20
temp: .space 4

input_tipo_dinero: .asciiz "1. Ingreso Billetes\n2. Ingreso Monedas\n3. Salir\nIngrese opcion\n "
input_billete: .asciiz "Ingrese valor del billete\n"
input_continue_ingreso: .asciiz "Desea Ingresar mas Dinero?\n 1.Si\n2. Para continuar sin ingresar mas dinero\n "
input_producto: .asciiz "Ingrese el numero del producto que desea\n"
msg_stock: .asciiz "Este producto tiene un stock menor a 15%\n"
resta: .asciiz "Resta\n"
.text

#main
maquina:
	#mostrar productos disponibles y stock
	#li $a0,0
	#jal mostrarProductos
	
	#escoger el producto
	li $v0, 4
	la $a0, input_producto
	syscall	
	li $v0, 5	#pide que se ingrese un numero entero
	syscall
	move $a0,$v0	#a0 sera el indice del array del producto, hay que restarle uno para que sea el indice correcto
	addi $a0,$a0,-1
	move $s5,$a0
	jal escogerProducto
	move $a1,$v0	#a1 = el precio del producto, para que la reciba la funcion cuentaBilletes, o monedas
	
	li $v0, 4
	la $a0, input_tipo_dinero
	syscall	
	li $v0, 5	#pide que se ingrese un numero entero
	syscall
	move $a0,$v0	#$s6 almacena la opcion de si va ingresar billetes o monedas
	#a ejecutaCompra le paso por parametro $a0= opcion de dinero que escogio.
	#					 $a1 = precio del producto que escogio.
	#					 $a2= idx del producto
	move $a2,$s5
	jal ejecutaCompra
	
	li $t1,1 #VUELVO A MAQUINA

	#beq $t0,2,cuentaMonedas
	#beq $t0,3,salir
	

ejecutaCompra:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	beq $a0,1,cuentaBilletes	
	#beq $t0,2,cuentaMonedas
	beq $t0,3,salir
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
salir:
	jr $ra

cuentaBilletes:	
	addi $sp,$sp,-4
	sw $ra,0($sp)
	move $s3,$a1  #s3 contiene el precio del producto
	li $a0, 0	#acumulador
	jal loopPedirBilletes
	move $s4,$v0  #t0 almacena el total de dinero ingresado
	li $t1,1 #VUELVO CUENTABILLETES solo sirve para ver en del debugg si volvo a la funcion
	
	lw $ra,0($sp)
	
	addi $sp,$sp,4
	jr $ra
	
restaDinero: 
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#codigo que hacer una vez tengo el total de dinero ingresado en $t0
	sub $t2,$s2,$s3 #cambio a dar
	
	#codigo para imprimir la resta que esta en $t2
	li $v0, 1
	move $a0, $t2
	syscall
		
	#funcion que reste el stock de ese producto
	li $t7,1 #VERIFICA A2
	
	lw $ra,0($sp)	
	addi $sp,$sp,4
	jr $ra
	
loopPedirBilletes:
	
	addi $sp,$sp,-12
	sw $a0,0($sp)
	sw $ra,4($sp)
	sw $s0,8($sp)
	
	move $s2,$a0	#guardo el parametro del total en Sa0 acumulador
	jal pedirDinero
	move $s0,$v0	#a0 es el valor del dinero Ingresado	
	#Hasta este punto estoy seguro que $v0 de la llamada validar billetes contiene un numero correcto de billete
	add $s2,$s2,$s0 #le sumo al acumulador el valor del billete ingresado
	
	li $v0, 4
	la $a0, input_continue_ingreso
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	
	move $a0,$s0	#almaceno el valor del billete ingresado para mandarlo como argumento al loop de billetes
	beq $t0,1, loopPedirBilletes
	jal restaDinero
	
	move $v0,$a0
	
	lw $a0,0($sp)
	lw $ra,4($sp)	
	lw $s0,8($sp)
	addi $sp,$sp,12
	jr $ra 
	
	

pedirDinero:
	addi $sp,$sp,-4
	sw $ra,0($sp)

	li $v0, 4
	la $a0, input_billete
	syscall
	
	li $v0, 5
	syscall
	
	move $a0,$v0	#almaceno en a0 el valor del billete ingresado
	li $a1,0 	#i=0
	
	jal validarBilletes
	move $t0,$v0	#t0=0 si es el billete es incorrecto
	beq $t0,$zero,volverApedir
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra
	
volverApedir:
	lw $ra,0($sp)
	addi $sp,$sp,4
	j pedirDinero

#funcion que retorna 1 si el billetes es correcto
# o 0 si esl billete es incorrecto
validarBilletes:
	la $t0, billetes #arreglo de billetes A=[1,5,10,20]
	li $t3,4 #constante length = 4
	slt $t4, $a1, $t3 # i<4 , 1 True, 0 False
	bne $t4,1, noEncontrado 
	sll $t5, $a1,2
	add $t5,$t0, $t5 # La base del arreglo es billetes
	lw $t6, 0($t5) #Billetes[i]
	addi $a1,$a1,1 # i+1
	bne $t6,$a0,validarBilletes 	
	move $v0,$a0
	jr $ra
	
noEncontrado:
	li $v0,0
	jr $ra



	
#funcion que muestra los productos
mostrarProductos:

	addi $sp,$sp,-4
	sw $ra,0($sp)


	move $s1,$a0 	#en s1 almaceno el valor i 
	la $t0, array #arreglo de productos
	la $t6, array_stock
	li $t1,3	#longitud del array de productos
	slt $t2,$a0,$t1	  #t2=1 si i<length del array
	beq $t2,$zero,exit
	
	sll $t3,$a0,2	#i*4 para producti
	sll $t7,$a0,2 	#i*4 para stock
	add $t3,$t3,$t0
	add $t7,$t7,$t6
	addi $s1,$s1,1	#i+=1
	
	lw $t4,0($t3) #producto
	lw $t5,0($t7) #stock del producto
	
	#imprimo el producto
	li $v0, 4
	move $a0,$t4	#para que imprima el producto
	syscall	
	
	#calculo de porcentaje
	li $t8,100
	mult $t5,$t8
	mflo $t5 
	#ahora divido para el total de stock que hay 
	li $s2,5	#5 es el total de stockmaximo de los productos 
	div $t5,$s2
	mflo $t5	#almaceno el valor del cociente
	
	li $t8,15	#porcentaje minimo
	slt $t9,$t5,$t8 # t9 = 1 si el porcentaje de stock del producto es menor que 15
	move $a0,$t9
	jal validaStock
	
	move $a0,$s1
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	j mostrarProductos
	
	
exit:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
	
validaStock:

	bne $a0,$zero,imprimirMsgStock
	jr $ra

imprimirMsgStock:

	li $v0, 4
	la $a0,msg_stock
	syscall
	jr $ra
	
#funcion que retorna el precio del producto
escogerProducto:
	la $t0, array_precios #arreglo de precios No me hace falta recorrer el arreglo, ya tengo el idx en a0
	sll $t1,$a0,2	#i*4 
	add $t2,$t1,$t0
	lw $t3,0($t2)	#t3= el precio de ese producto
	move $v0,$t3
	jr $ra
	
