#include "mdl.cuh"

#include "../../impl_template/tmpl_etc.cu"

static void supprimer_l_inst(Mdl_t * mdl, uint inst) {
	uint pos_ligne = 0;
	uint pos_pos   = 0;
	FOR(0, i, mdl->BLOQUES_ENCODEUR) {
		FOR(0, j, mdl->elements_ENCODEUR[i]) {
			if (mdl->instructions_ENCODEUR[i][j] == inst) {
				pos_ligne = i;
				pos_pos   = j;
			}
		}
	}

	//	Supprimer
	FOR(pos_pos, i, mdl->elements_ENCODEUR[pos_ligne]) {
		mdl->instructions_ENCODEUR[pos_ligne][i] = mdl->instructions_ENCODEUR[pos_ligne][i+1];
	}
	mdl->elements_ENCODEUR[pos_ligne] -= 1;
};

void mdl_optimisation_ENCODEUR(Mdl_t * mdl) {
	mdl->BLOQUES_ENCODEUR = mdl->BLOQUES_DECODEUR;
	// 
	mdl->elements_ENCODEUR = (uint*)malloc(sizeof(uint) * mdl->BLOQUES_ENCODEUR);
	FOR(0, i, mdl->BLOQUES_ENCODEUR) {
		mdl->elements_ENCODEUR[i] = mdl->elements_DECODEUR[i];
	}
	//
	mdl->instructions_ENCODEUR = (uint**)malloc(sizeof(uint*) * mdl->BLOQUES_ENCODEUR);
	FOR(0, i, mdl->BLOQUES_ENCODEUR) {
		mdl->instructions_ENCODEUR[i] = (uint*)malloc(sizeof(uint) * mdl->elements_DECODEUR[i]);
		FOR(0, j, mdl->elements_ENCODEUR[i]) {
			mdl->instructions_ENCODEUR[i][j] = mdl->instructions_DECODEUR[i][j];
		}
	}

	//	On supprimer toutes les instructions qui n'ont pas d'impacte temporel
	uint ont_un_impacte_sur_moi[mdl->insts][mdl->insts];
	FOR(0, i, mdl->insts) FOR(0, j, mdl->insts) ont_un_impacte_sur_moi[i][j] = false;

	//	Initialisation
	FOR(0, i, mdl->insts) {
		Inst_t * inst = mdl->inst[i];
		if (inst->ID != 0) {
			FOR(0, j, inst_Xs[inst->ID])
				ont_un_impacte_sur_moi[i][inst->x_pos[j]] = 1;
		}
	}

	//	Boucle
	FOR(0, repeter, mdl->insts) {
		FOR(0, i, mdl->insts) {
			FOR(0, j, mdl->insts) {
				if (ont_un_impacte_sur_moi[i][j] == 1) {
					Inst_t * inst = mdl->inst[j];
					if (inst->ID != 0)
						FOR(0, k, inst_Xs[inst->ID])
							ont_un_impacte_sur_moi[i][inst->x_pos[k]] = 1;
				}
			}
		};
	};

	uint est_un_xt[mdl->insts];
	FOR(0, i, mdl->insts) est_un_xt[i] = 0;
	//
	FOR(0, i, mdl->insts) {
		Inst_t * inst = mdl->inst[i];
		if (inst->ID != 0) {
			FOR(0, j, inst_Xs[inst->ID]) {
				if (inst->x_t[j] == 1)
					est_un_xt[inst->x_pos[j]] = 1;
			}
		}
	}

	uint impacte_un_xt[mdl->insts];
	FOR(0, i, mdl->insts) impacte_un_xt[i] = 0;
	//
	FOR(0, i, mdl->insts) {
		if (est_un_xt[i] == 1) {
			FOR(0, j, mdl->insts) {
				if (ont_un_impacte_sur_moi[i][j] == 1)
					impacte_un_xt[j] = 1;
			}
		};
	};

	//	-- Retirer les instructions qui n'impactent pas les x[t-1]
	FOR(0, i, mdl->insts) {
		if (impacte_un_xt[i] == 0) {
			supprimer_l_inst(mdl, i);
		};
	}
};