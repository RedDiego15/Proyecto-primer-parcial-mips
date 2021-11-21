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
array_stock: .word 0,5,5
array_precios: .word 10,10,10

input: .asciiz "Ingrese\n"
billetes: .word 1,5,10,20
temp: .space 4

input_tipo_dinero: .asciiz "1. Ingreso Billetes\n2. Ingreso Monedas\n3. Salir\nIngrese opcion\n "
input_billete: .asciiz "Ingrese valor del billete\n"
input_continue_ingreso: .asciiz "Desea Ingresar mas Dinero?\n 1.Si\nInserte cualquier digito para continuar\n "

msg_stock: .asciiz "Este producto tiene un stock menor a 15%\n"
.text

#main
maquina:

	#mostrar productos disponibles y stock
	li $a0,0
	jal mostrarProductos
	
	
	li $v0, 4
	la $a0, input_tipo_dinero
	syscall	
	li $v0, 5	#pide que se ingrese un numero entero
	syscall
	move $t0,$v0	#$t0 almacena la opcion de si va ingresar billetes o monedas
	beq $t0,1,cuentaBilletes

	#beq $t0,2,cuentaMonedas
	#beq $t0,3,salir
	
cuentaBilletes:
	
	addi $sp,$sp,4
	sw $ra,0($sp)
	li $a0, 0	#acumulador
	jal loopPedirBilletes
	move $t0,$v0  #t0 almacena el total de dinero ingresado
	li $t1,1 #VUELVO CUENTABILLETES solo sirve para ver en del debugg si volvo a la funcion
	
	#codigo que hacer una vez tengo el total de dinero ingresado en $t0
	
	
	
	
	lw $ra,0($sp)
	addi $sp,$sp,-4
	li $v0,1 #retorno de cuenta billetes
	
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
	
	move $a0,$s0	#almaceno el valor del billete ingresado para mandarlo como argumento al loop de billetes
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

#etiqueta de validación del arreglo billetes  beq valor, 1,ValidarBilletes 
#s1 tiene el valor ingresado del billete o moneda
validarBilletes:
	la $t0, billetes #arreglo de billetes A=[1,5,10,20]
	li $t3,4 #constante length = 4
	slt $t4, $a1, $t3 # i<4 , 1 True, 0 False
	beq $t4,$zero,pedirDineroBilletes #if(1/0==0) 
	sll $t5, $a1,2
	add $t5,$t0, $t5 # La base del arreglo es billetes
	lw $t6, 0($t5) #Billetes[i]
	addi $a1,$a1,1 # i+1
	bne $t6,$a0,validarBilletes 	
	move $v0,$a0
	jr $ra
	
#funcion que muestra los productos
mostrarProductos:

	addi $sp,$sp,4
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
	addi $sp,$sp,-4
	j mostrarProductos
	
	
exit:
	lw $ra,0($sp)
	addi $sp,$sp,-4
	jr $ra
	
	
validaStock:

	bne $a0,$zero,imprimirMsgStock
	jr $ra

imprimirMsgStock:

	li $v0, 4
	la $a0,msg_stock
	syscall
	jr $ra
	
	

	

	
	
	
	
	

	






