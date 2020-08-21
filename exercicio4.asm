#####################################################################Disciplina: Arquitetura e Organiza��o de Processadores
#Atividade: Avalia��o 04 � Programa��o de Procedimentos
#Exerc�cio 04
#Aluna: Ana Clara Pr�sse e Sabrina dos Passos Tortelli
#C�digo em Assembly
####################################################################
# SEGMENTO DE DADOS                                                            
####################################################################

   .data                            # Informa o in�cio do segmento de 
                                    # dados, onde declaramos todas as 
                                    # vari�veis envolvidas.

Vetor_A: .word 0,0,0,0,0,0,0,0      #declara��o do vetor

msg_tam:.asciiz "\nEntre com o tamanho do vetor (max 8):" # mensagem
                                                # do tamanho do vetor
                                             
msg_vetorA:.asciiz "\nVetor_A ["    # mensagem para entrada dos
                                    # elementos do vetor A 

msg_fechVetor:.asciiz "]: "         # mensagem para entrada dos
                                    # elementos dos vetores 

msg_invalido:.asciiz "\nValor Invalido" # mensagem de valor invalido

msg_order:.asciiz "\nResultado da ordenacao dos vetores:" # mensagem
                                                       # do resultado                       

            ####################################################################
# SEGMENTO DE C�DIGO                                                           
####################################################################

    .text                     # Informa o in�cio do segmento de c�digo, 
                            # onde fica o programa.

     j   Main	           # pula para main

BubbleSort:                  #procedimento bubbleSort

     subi $sp, $sp, 28      # decrementa $sp em 28
     sw $s6, 24($sp)        # salva o conte�do de $s6(length � 1)
     sw $s5, 20($sp)        # salva o conte�do de $s5((length � 1) �
                            # contador 1) 
     sw $s2, 16($sp)        # salva o conte�do de $s2(contador 2)
     sw $s1, 8($sp)         # salva o conte�do de $s1(contador 1)
     sw $a1, 4($sp)         # salva o conte�do de $a1(endere�o base
                            # do vetor       
     sw $a0, 0($sp)         # salva o conte�do de $a0(length)

     addi $s1, $zero, 0     # $s1(contador 1) = 0
     addi $s2, $zero, 0     # $s2(contador 2) = 0
     subi $s6, $a0, 1       # $s6 = $a0(length) - 1

Loop:
       
     add $t1, $s2, $s2      # $t1 = 2*1
     add $t1, $t1, $t1      # $t1 = 4*1
     add $t1, $t1, $s0      # $t1 = end. Base + 4*i = end. absoluto
       
     lw $a1, 0($t1)         # $a1 = Vetor_A[i]
     lw $t4, 4($t1)         # $t4 = Vetor_A[i+1]
       
     slt $t2, $a1, $t4      # se $a1<$t4 ent�o $t2=1 sen�o $t2=0
     bne $t2, $zero, Increment # se $t2=0 ent�o goto Increment

     sw $t4, 0($t1)         # swap - Vetor_A[i] = $t4 
     sw $a1, 4($t1)         # swap - Vetor_A[i] = $a1 
       
Increment:

     addi $s2, $s2, 1       # incrementa $s2
     sub $s5, $s6, $s1      # $s5 = $s6(length -1) - $s1(contador 1)
     bne $s2, $s5, Loop     # vai para Loop se $s2 != $s5
	
     addi $s1, $s1, 1       # incrementa $s1
     addi $s2, $zero, 0     # zera $s2
	
     bne $s1, $s6, Loop     # vai para Loop se $s1 != $s6

     lw $a0, 0($sp)         # restaura $a0 da pilha
     lw $a1, 4($sp)         # restaura $a1 da pilha
     lw $s1, 8($sp)         # restaura $s1 da pilha
     lw $s2, 16($sp)        # restaura $s2 da pilha   
     lw $s5, 20($sp)        # restaura $s5 da pilha 
     lw $s6, 24($sp)        # restaura $s6 da pilha 
     addi $sp, $sp, 28      # ajusta a pilha em 28

     jr  $ra                # retorna do procedimento
       

Main:                       # In�cio do programa

     la $s0, Vetor_A        # carrega o vetor para $s0
     addi $a0, $zero, 0     # inicia length com 0
     addi $s1, $zero, 3     # inicia $s1 com 3 (valor aleat�rio)
     addi $s2, $zero, 4     # inicia $s2 com 4 (valor aleat�rio)
     addi $s5, $zero, 5     # inicia $s5 com 5 (valor aleat�rio)
     addi $s6, $zero, 6     # inicia $s6 com 6 (valor aleat�rio)

VectorSize:                 # pede para usu�rio o tamanho do vetor

     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_tam        # carrega ptr para string msg_tam         
     syscall                # chama o servi�o

     li $v0, 5              # carrega o servi�o 5 (l� inteiro)
     syscall                # chama o servi�o
     
     ble $v0, 0, Invalid    # Se $v0 < 1, ent�o chama MsgInvalido
     bgt $v0, 8, Invalid    # Se $v0 > 8, ent�o chama MsgInvalido

     j SaveVectorSize        # Se passar pelos testes ent�o vai para
                             # a label SaveVectorSize

Invalid:  
      
     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_invalido   # carrega ptr para string msg_invalido         
     syscall                # chama o servi�o

     j VectorSize           # volta para a label VectorSize

SaveVectorSize:

     add $a0, $v0, $zero    # carrega o inteiro lido para $a0 
                            #(tamanho m�ximo do vetor) 
       
     addi $s3, $zero, 0     # declara��o do i=0
     add $t3, $zero, $a0    # transfere valor de $a0 para $t3
  
LoopA:                      # pede ao usu�rio valores para o vetor
   
     slt $t0, $s3, $t3      # se i($s3)<$t3 ent�o $t0=1 sen�o $t0=0
     beq $t0, $zero, ExitA  # se $t0=0 ent�o goto ExitA

     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_vetorA     # carrega ptr para string msg_vetorA         
     syscall                # chama o servi�o

     addi $v0, $0, 1        # carrega o servi�o 1 (print inteiro)
     add $a0, $0, $s3       # carrega int($s3) em $a0         
     syscall                # chama o servi�o
       
     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_fechVetor  # carrega ptr para string msg_fechVetor         
     syscall                # chama o servi�o
       
     add $t1, $s3, $s3      # $t1 = 2*1
     add $t1, $t1, $t1      # $t1 = 4*1
     add $t1, $t1, $s0      # $t1 = end. Base + 4*i = end. absoluto
     lw $s4, 0($t1)         # $s4 = Vetor_A[0]
       
     li $v0, 5              # carrega o servi�o 5 (l� inteiro)
     syscall                # chama o servi�o

     sw $v0, 0($t1)         # Vetor_A[i] = $v0 (inteiro lido)

     addi $s3, $s3, 1       # i++ (do la�o for)
     j    LoopA             # goto Loop

ExitA:  nop

  la $s0, Vetor_A	     # Atribui Vetor_A para $s0
     add $a0, $zero, $t3    # Devolve o valor $t3 para $a0(length)

     jal BubbleSort         # chama o procedimento BubbleSort

     addi $t0, $zero, 0     # declara��o da vari�vel $t0=0
     addi $s3, $zero, 0     # i = 0
       
     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_order      # carrega ptr para string msg_order         
     syscall                # chama o servi�o

LoopFinal:                  # Loop para mostrar os valores do vetor
     
     slt $t0, $s3, $t3      # se i($s3)<$t3 ent�o $t0=1 sen�o $t0=0
     beq  $t0, $zero, ExitFinal # se $t0=0 ent�o goto ExitFinal

     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_vetorA     # carrega ptr para string msg_vetorA         
     syscall                # chama o servi�o
       
     addi $v0, $0, 1        # carrega o servi�o 1 (print inteiro)
     add $a0, $0, $s3       # carrega int em $a0         
     syscall                # chama o servi�o
       
     li $v0, 4              # carrega o servi�o 4 (print string)
     la $a0, msg_fechVetor  # carrega ptr para string msg_fechVetor         
     syscall                # chama o servi�o
     
     add $t1, $s3, $s3      # $t1 = 2*1
     add $t1, $t1, $t1      # $t1 = 4*1
     add $t1, $t1, $s0      # $t1 = end. Base + 4*i = end. absoluto
  lw $s4, 0($t1)         # $s4 = Vetor_A[0]
      
     addi $v0, $0, 1        # carrega o servi�o 1 (print int)
     add $a0, $0, $s4       # carrega int para $a0         
     syscall                # chama o servi�o

     addi $s3, $s3, 1       # i++ (do la�o for)
     j    LoopFinal         # goto LoopFinal

ExitFinal: nop

####################################################################

