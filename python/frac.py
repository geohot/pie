# https://possiblywrong.wordpress.com/2017/09/30/digits-of-pi-and-python-generators/

def continued_fraction(a, b, base=10):
  """Generate digits of continued fraction a(0)+b(1)/(a(1)+b(2)/(...)."""
  (p0, q0), (p1, q1) = (a(0), 1), (a(1) * a(0) + b(1), a(1))
  k = 1
  while True:
    #print(p0, q0, p1, q1)

    # bignum sub and bignum compare
    (d0, r0) = 0, p0
    while r0 > q0:
      d0 += 1
      r0 -= q0

    (d1, r1) = 0, p1
    while r1 > q1:
      d1 += 1
      r1 -= q1

    #(d0, r0), (d1, r1) = divmod(p0, q0), divmod(p1, q1)
    #print(d0,d1,r0,r1)
    if d0 == d1:
      # store p0, q0, p1, q1, k
      # bignum *= 10
      p0, p1 = base * r0, base * r1
      yield d1
    else:
      k = k + 1
      x, y = a(k), b(k)
      print("  ",x,y)
      # bignum * small thing
      # bignum addition
      (p0, q0), (p1, q1) = (p1, q1), \
        (x * p1 + y * p0, x * q1 + y * q0)

i = 0
for digit in continued_fraction(lambda k: 0 if k == 0 else 2 * k - 1,
                                lambda k: 4 if k == 1 else (k - 1)**2, 10):
  print(digit)
  if i == 40:
    break
  i += 1