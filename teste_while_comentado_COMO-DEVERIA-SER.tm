  0:     LD  6,0(0) 
  1:     ST  0,0(0) 
  
  2:    LDC  0,4(0) * ac = 4
  3:     ST  0,0(5) * gp[0] = 4
  4:    LDC  0,1(0) * ac = 1
  5:     ST  0,1(5) * gp[1] = 1
  6:     ST  0,0(6) * mp[1023] = 1(ac) pra que?
  7:     LD  1,0(5) * ac1 = 4
  8:    SUB  0,1,0  * ac = ac1 - ac = 4 - 1 = 3
  9:    JLT  0,2(7) * (ac) 0 < 0? Pule para 12 (10 + 2) : Senão vá para pc atual, próxima instrução (10)
 16:    OUT  0,0,0  * imprime ac
 10:    LDC  0,0(0) * ac = 0
 11:    LDA  7,1(7) * pc = pc + 1 ************** Deveria ser ac = ac + 1? ou algo parecido? Para ser o b = b + 1
 12:    LDC  0,1(0) * ac = 1
 13:    JEQ  0,1(7) * ac == 0? pc = pc + 1 (15) : Senão pc atual, prox instrucao (14)
 14:    LDA  7,-1(7) * pc = pc - 1 (15 - 1) -----------------> loop infinito
 15:     LD  0,1(5) * ac = 4 -------------------------> isso devia ter acontecido lá em cima, no lugar da instrução 6:
 17:    JEQ  0,-12(7) * ac == 0? pc = 18-12 = 6 ------> Nao faz sentido esse pulo
 
 18:   HALT  0,0,0
