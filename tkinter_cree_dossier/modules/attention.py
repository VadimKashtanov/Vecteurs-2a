from tkinter_cree_dossier.modules._etc import *

class ATTENTION_2D(Module_Mdl):
	bg, fg = 'light blue', 'black'
	nom = "[ATTENTION 2D]"
	X, Y = [0], [0]
	X_noms, Y_noms = ["X"], ["Y"]
	params = {
		'Ax' : 1,
		'Ay' : 1,
		'Clef' : 1,
		'Vx' : 1,
		'Têtes' : 1,
	}
	def cree_ix(self):
		#	Params
		X = self.X[0]
		Y = self.Y[0]

		Ax = self.params['Ax']
		Ay = self.params['Ay']

		Clef = self.params['Clef']

		Vx = self.params['Vx']

		C1 = self.params['Têtes']

		#	------------------

		do = self.do

		self.elements = {
			'x' : MODULE_i_Canalisation  (X=[Ax*Ay],    Y=[Ax*Ay*C1], params={'C0':C1}, do=0,dc=0).cree_ix(),
			#
			'q' : MODULE_i_MatMul_Poid_AP(X=[Ax*Ay*C1], Y=[Clef*Ay*C1], params={'Ax':Ax, 'Ay':Ay, 'Bx':Clef, 'C0':C1}, do=0,dc=0).cree_ix(),
			'k' : MODULE_i_MatMul_Poid_AP(X=[Ax*Ay*C1], Y=[Clef*Ay*C1], params={'Ax':Ax, 'Ay':Ay, 'Bx':Clef, 'C0':C1}, do=0,dc=0).cree_ix(),
			'v' : MODULE_i_MatMul_Poid_AP(X=[Ax*Ay*C1], Y=[Vx  *Ay*C1], params={'Ax':Ax, 'Ay':Ay, 'Bx':Vx,   'C0':C1}, do=0,dc=0).cree_ix(),
			#
			'k.T' : MODULE_i_Transpose2d (X=[Clef*Ay*C1], Y=[Ay*Clef*C1], params={'Ax':Clef, 'Ay':Ay, 'C0':C1}, do=0,dc=0).cree_ix(),
			#
			'q@k.T' :            MODULE_i_MatMul(X=[Clef*Ay*C1, Ay*Clef*C1], Y=[Ay*Ay*C1], params={'Ax':Clef, 'Ay':Ay, 'Bx':Ay, 'C0':C1}, do=0, dc=0).cree_ix(),
			'softmax(q@k.T)' :   SOFTMAX        (X=[       Ay*Ay*C1       ], Y=[Ay*Ay*C1], params={'C0':Ay*C1},                           do=0, dc=0).cree_ix(),
			'softmax(q@k.T)@v' : MODULE_i_MatMul(X=[  Ay*Ay*C1, Vx*Ay*C1  ], Y=[Vx*Ay*C1], params={'Ax':Ay,   'Ay':Ay, 'Bx':Vx, 'C0':C1}, do=do,dc=0).cree_ix()
		}

		self.connections = {
			'x' : {0:None},
			#
			'q' : {0:('x',0)},
			'k' : {0:('x',0)},
			'v' : {0:('x',0)},
			#
			'k.T' : {0:('k',0)},
			#
			'q@k.T'            : {0:('q',0), 1:('k.T',0)},
			'softmax(q@k.T)'   : {0:('q@k.T', 0)},
			'softmax(q@k.T)@v' : {0:('softmax(q@k.T)', 0), 1 : ('v', 0)}
		
		}

		self.cree_elements_connections()
		return self.ix