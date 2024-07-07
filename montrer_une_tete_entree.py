import struct as st

lire_uints  = lambda I, bins: (st.unpack('I'*I, bins[:4*I]), bins[4*I:])
lire_floats = lambda I, bins: (st.unpack('f'*I, bins[:4*I]), bins[4*I:])

with open("prixs/dar.bin", "rb") as co:
	bins = co.read()

	(T,), bins = lire_uints(1, bins)

	(LIGNES,N,P), bins = lire_uints(3, bins)

	x, bins = lire_floats(LIGNES*N, bins)
	y, bins = lire_floats(P,        bins)

	print("Entrés :")
	for i in range(LIGNES):
		print( "{l:3} | ".format(l=i) + ',    '.join(  map(lambda flt:'{f:+3.4f}'.format(f=flt), x[i*N:(i+1)*N])  ) )

	print("Sorties : ")
	print(', '.join(  map(str, y)  ))