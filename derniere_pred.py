import struct as st
import matplotlib.pyplot as plt

with open("structure_generale.bin", 'rb') as co:
	bins = co.read()
	(I,) = st.unpack('I', bins[:4])
	elements = st.unpack('I', bins[4:])
	#
	MEGA_T, = elements

####################################################################################

def normer(l):
	_min, _max = min(l), max(l)
	return [(e-_min)/(_max-_min) for e in l]

####################################################################################

d = "1H" #"15m"

T = 1 * MEGA_T

P = 1

N = 8
INTERVALLE_MAX = 256
DEPART = INTERVALLE_MAX * N

HEURES = DEPART + T + P

from bitget_donnee import DONNEES_BITGET, faire_un_csv

donnees = DONNEES_BITGET(HEURES, d=d)
csv = faire_un_csv(donnees, NOM="bitgetBTCUSDT")

with open('prixs/bitgetBTCUSDT.csv', 'w') as co:
	co.write(csv)

####################################################################################

from calcule import calcule

les_predictions, les_delats = calcule(donnees, "bitgetBTC", MEGA_T)

print(f"les_predictions = {les_predictions}")
print(f"les_delats      = {les_delats}")