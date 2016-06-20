int main (){
	int a
	a = 1
	a = a + 1
	escreva(a)
}

  0:     LD  6,0(0) 
  1:     ST  0,0(0) 

  a=1
  2:    LDC  0,1(0) 
  3:     ST  0,0(5) 

  a = a + 1
  4:     LD  0,0(5) ac = a == 1
  5:     ST  0,0(6) mp[0] = ac == 1
  6:    LDC  0,1(0) ac = 1
  7:     LD  1,0(6) ac1 = mp[0]
  8:    ADD  0,1,0 ac = ac1 + ac == 1 + 1
  9:     ST  0,0(5) a = ac == a + 1 == 2
  
  escreva(a)
 10:     LD  0,0(5) 
 11:    OUT  0,0,0 
 
 12:   HALT  0,0,0 
