from tkinter_cree_dossier.modules._etc import *

from tkinter_cree_dossier.modules.dot1d   import *
from tkinter_cree_dossier.modules.dot1d_2 import *
from tkinter_cree_dossier.modules.dot1d_3 import *

from tkinter_cree_dossier.modules.dot2d import *

from tkinter_cree_dossier.modules.lstm import *
from tkinter_cree_dossier.modules.lstm_peephole import *

from tkinter_cree_dossier.modules.signale_logistique import *

from tkinter_cree_dossier.modules.attention import *

class NONE(Module_Mdl):
	nom = ""
	X,      Y      = [], []
	X_noms, Y_noms = [], []
	params = {}
	def cree_ix(self):
		return []

#	=========================================================================	#

modules = [
	DOT1D,
	DOT1D__CHAINE,
	DOT1D_2X,
	DOT1D_3X,
	DOT2D_AP,
	DOT2D_PA,
	NONE,
	NONE,
	NONE,
#	-----------------	#
	LSTM1D,
	LSTM1D_PROFOND,
	LSTM1D_PEEPHOLE,
	NONE,
	SIGNALE_LOGISTIQUE,
	NONE,
	NONE,
	NONE,
	NONE,
#	----------------	#
	NONE,
	ATTENTION_2D,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
#	----------------	#
	SOMME3,
	SOFTMAX,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
]

"""
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
	NONE,
"""