# https://rosettacode.org/wiki/Pi#Python

q, r, t, k, n, l = 1, 0, 1, 1, 3, 3
def calcPi():
  global q,r,t,k,n,l
  while True:
    print(q,r,t,k,n,l)
    if (4*q+r-t) < (n*t):
      ret = n
      nr = 10*(r-n*t)
      n = ((10*(3*q+r))//t)-10*n
      q *= 10
      r = nr
      return ret
    else:
      n = (q*(7*k)+2+(r*l))//(t*l)
      r = (2*q+r)*l
      q *= k
      t *= l
      l += 2
      k += 1
 
import sys
for i in range(15):
  print(calcPi())