#include "mdl.cuh"

#include "../../impl_template/tmpl_etc.cu"

static void lancer_une_d_inst(
	Mdl_t * mdl, BTCUSDT_t * btcusdt, uint * ts__d,
	uint mega_t, uint b, uint j, uint i)
{
	//
	Inst_t * inst = mdl->inst[i];
	//
	float *  x__d[MAX_XS];
	float * dx__d[MAX_XS];
	if (inst->ID == 0) {
		x__d[0] = btcusdt->entrees__d;
		dx__d[0] = 0;
	} else {
		FOR(0, j, inst_Xs[inst->ID]) {
			x__d[j] = mdl->inst[inst->x_pos[j]]-> y__d;
			dx__d[j] = mdl->inst[inst->x_pos[j]]->dy__d;
		};
	}
	//
	_df_inst[inst->ID](inst, x__d, dx__d, ts__d, mega_t);
}

void mdl_df(Mdl_t * mdl, BTCUSDT_t * btcusdt, uint * ts__d) {
	mdl_verif(mdl, btcusdt);

	RETRO_FOR(0, decodeur, DECODEUR) {
		uint mega_t = ENCODEUR + decodeur;
		RETRO_FOR(0, b, mdl->BLOQUES_DECODEUR) {
			//	d drop out
			FOR(0, j, mdl->elements_DECODEUR[b]) {
				uint i = mdl->instructions_DECODEUR[b][j];
				inst_drop_out_df(mdl->inst[i], mega_t);
			}
			ATTENDRE_CUDA();


			FOR(0, j, mdl->elements_DECODEUR[b]) {
				uint i = mdl->instructions_DECODEUR[b][j];
				lancer_une_d_inst(mdl, btcusdt, ts__d, mega_t, b, j, i);
			}
			ATTENDRE_CUDA();
		};
	}

	RETRO_FOR(0, encodeur, ENCODEUR) {
		uint mega_t = 0 + encodeur;
		RETRO_FOR(0, b, mdl->BLOQUES_ENCODEUR) {
			//	d drop out
			FOR(0, j, mdl->elements_ENCODEUR[b]) {
				uint i = mdl->instructions_ENCODEUR[b][j];
				inst_drop_out_df(mdl->inst[i], mega_t);
			}
			ATTENDRE_CUDA();
			
			FOR(0, j, mdl->elements_ENCODEUR[b]) {
				uint i = mdl->instructions_ENCODEUR[b][j];
				lancer_une_d_inst(mdl, btcusdt, ts__d, mega_t, b, j, i);
			}
			ATTENDRE_CUDA();
		};
	}
};