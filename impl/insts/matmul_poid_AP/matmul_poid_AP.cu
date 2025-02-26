#include "matmul_poid_AP.cuh"

uint matmul_poid_AP__calculer_P(uint X[MAX_XS], uint x[MAX_XS], uint t[MAX_XS], uint Y, uint params[MAX_PARAMS]) {
	uint \
		Ax =params[0],	\
		Ay =params[1],	\
		Bx =params[2],	\
		C0 =params[3];
	//
	return C0 * Bx*Ax;
};

uint matmul_poid_AP__calculer_L(uint X[MAX_XS], uint x[MAX_XS], uint t[MAX_XS], uint Y, uint params[MAX_PARAMS]) {
	return 0;
};

void matmul_poid_AP__init_poids(Inst_t * inst) {
	uint * params = inst->params;
	uint \
		Ax =params[0],	\
		Ay =params[1],	\
		Bx =params[2],	\
		C0 =params[3];
	//
	//printf("%i %i %i %i\n", Ax, Ay, Bx, C0);
	ASSERT(inst->Y      == C0 * Bx*Ay);
	ASSERT(inst->x_Y[0] == C0 * Ax*Ay);

	float p[inst->P];
	FOR(0, i, inst->P) p[i] = poid_1_1() * sqrtf(6.0/(float)Ax);

	CONTROLE_CUDA(cudaMemcpy(inst->p__d, p, sizeof(float)*inst->P, cudaMemcpyHostToDevice));
};

void matmul_poid_AP__pre_f(Inst_t * inst) {
	
};