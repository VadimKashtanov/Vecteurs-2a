import struct as st

lire_uints  = lambda I, bins: (st.unpack('I'*I, bins[:4*I]), bins[4*I:])
lire_floats = lambda I, bins: (st.unpack('f'*I, bins[:4*I]), bins[4*I:])

with open("prixs/dar.bin", "rb") as co:
	bins = co.read()

	(T,), bins = lire_uints(1, bins)

	(LIGNES,D,N,P), bins = lire_uints(4, bins)

	x, bins = lire_floats(LIGNES*N*D, bins)
	y, bins = lire_floats(P,          bins)

	print("Entrés :")
	for i in range(LIGNES):
		print(f"l={i}  [")
		for n in range(N):
			_N = " {n:2}| ".format(n=n)
			_D = ', '.join(  map(lambda flt:'{f:+3.4f}'.format(f=flt), x[i*N*D+n*D  :  i*N*D+(n+1)*D])  )
			print(_N + _D)
		print("]")

	print("Sorties : ")
	print(', '.join(  map(str, y)  ))