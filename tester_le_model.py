import struct as st
import matplotlib.pyplot as plt

ETAPE = lambda I, intitulé: print(f"\033[92m[OK]\033[0m Etape {I}: {intitulé}")

def normer(l):
	_min, _max = min(l), max(l)
	return [(e-_min)/(_max-_min) for e in l]

def normer_11(l):
	_min, _max = min(l), max(l)
	return [2*(e-_min)/(_max-_min)-1 for e in l]

__sng = lambda x: (1 if x > 0 else -1)

####################################################################################

d = "1H"# "15m"

T = (4)*7*24 # * 4

from CONTEXTE import N, P, INTERVALLE_MAX, DEPART

HEURES = DEPART + T + P

from bitget_donnee import DONNEES_BITGET, faire_un_csv

donnees = DONNEES_BITGET(HEURES, d)
csv = faire_un_csv(donnees, NOM="bitgetBTCUSDT")

print(f"Len donnees = {len(donnees)}")

with open('prixs/bitgetBTCUSDT.csv', 'w') as co:
	co.write(csv)

ETAPE(1, "Ecriture CSV")

####################################################################################

with open("structure_generale.bin", 'rb') as co:
	bins = co.read()
	(I,) = st.unpack('I', bins[:4])
	elements = st.unpack('I'*int(len(bins[4:])/4), bins[4:])
	#
	ENCODEUR, DECODEUR, MEGA_T, = elements

from calcule import calcule

les_predictions, les_delats = calcule(donnees, "bitgetBTC", MEGA_T)

les_predictions = les_predictions                   #[-1;+1]
les_delats      = les_delats                        #[-inf;+inf]

####################################################################################

prixs = [float(c) for _,o,h,l,c,vB,vU in donnees]

print("les_predictions", les_predictions[-7:])
print("les_delats     ", les_delats     [-7:])

deltas = [(prixs[i+1]/prixs[i] - 1) for i in range(len(prixs)-1)]

print("les delats", les_delats[-5:])
print("deltas    ", deltas    [-5:])

print(f"moyenne des differences des deltas : {sum([abs(a-b) for a,b in zip(deltas, les_delats)])/len(deltas)}")

####################################################################################

a =          (les_predictions)
b = normer_11(prixs[-len(les_predictions)-1:-1])

deltas_normés = [0] + [abs(b[i+1]-b[i]) for i in range(len(b)-1)]

for i in range(int(len(les_predictions)/MEGA_T)):
	#	Ligne |
	plt.plot([len(les_predictions) - i*MEGA_T]*2, [-1, 1])


	#	Les courbes
	les_p1p0  = deltas_normés[i*MEGA_T:(i+1)*MEGA_T]
	les_preds =             a[i*MEGA_T:(i+1)*MEGA_T]

	s=0
	courbe = [b[i*MEGA_T] + (s:=( s+__sng(elm)*les_p1p0[j] )) for j,elm in enumerate(a[i*MEGA_T:(i+1)*MEGA_T][ENCODEUR:])]

	#	X
	x = list(range(i*MEGA_T, (i+1)*MEGA_T))

	if i == 0:
		plt.plot(x, les_preds, 'm-o', label='o = Predictions')
		plt.plot(x[1+ENCODEUR:], courbe[:-1], 'g', label='Petite tendance')
	else:
		plt.plot(x, les_preds, 'm-o')
		plt.plot(x[ENCODEUR:], courbe, 'g')

	#
	for j in range(MEGA_T):
		if a[i*MEGA_T+j] >= 0.0:
			plt.plot([i*MEGA_T+j, i*MEGA_T+j], [b[i*MEGA_T+j], b[i*MEGA_T+j] + 0.03], 'g')
		else:
			plt.plot([i*MEGA_T+j, i*MEGA_T+j], [b[i*MEGA_T+j], b[i*MEGA_T+j] - 0.03], 'r')

plt.plot(b, 'c-^', label='prix')
plt.legend()
plt.show()

####################################################################################

print("len(les_predictions)", len(les_predictions))
print("len(prixs)          ", len(prixs))

fig, ax = plt.subplots(2,2)

signe = [+1,-1]

LEVIERS = [10, 20, 30, 50]

for sng in [0,1]:
	for L in LEVIERS:
		u = 100
		_u0 = []
		for i in range(len(les_predictions)):
			if i%MEGA_T >= ENCODEUR:
				p0 = (len(prixs)-1-len(les_predictions)) + i    
				p1 = (len(prixs)-1-len(les_predictions)) + i + 1
				u += u * L * __sng(les_predictions[i]) * (prixs[p1]/prixs[p0]-1) * signe[sng]
				_u0 += [u]
				if u < 0: u = 0
			else:
				_u0 += [0]
		#
		ax[0][sng].plot(
			[de*DECODEUR + i for de in range(int(len(les_predictions) / MEGA_T)) for i in range(DECODEUR)],
			[_u0[de*MEGA_T+ENCODEUR + i] for de in range(int(len(les_predictions) / MEGA_T)) for i in range(DECODEUR)]
		)
#
for sng in [0,1]:
	for L in LEVIERS:
		u = 100
		_u0 = []
		for i in range(len(les_predictions)):
			if i%MEGA_T >= ENCODEUR:
				p0 = (len(prixs)-1-len(les_predictions)) + i    
				p1 = (len(prixs)-1-len(les_predictions)) + i + 1
				u += u * L * les_predictions[i] * (prixs[p1]/prixs[p0]-1) * signe[sng]
				_u0 += [u]
				if u < 0: u = 0
			else:
				_u0 += [0]
		#
		ax[1][sng].plot(
			[de*DECODEUR + i for de in range(int(len(les_predictions) / MEGA_T)) for i in range(DECODEUR)],
			[_u0[de*MEGA_T+ENCODEUR + i] for de in range(int(len(les_predictions) / MEGA_T)) for i in range(DECODEUR)]
		)
	#
#
plt.show()