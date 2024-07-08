#include "btcusdt.cuh"

#include "../impl_template/tmpl_etc.cu"

static __global__ void k__f_btcusdt(
	float * somme_score,
	float * y, float * p1p0,
	uint * ts__d,
	uint Y,
	uint T)
{
	uint t = threadIdx.x + blockIdx.x * blockDim.x;
	//
	if (t < GRAND_T) {
		//float usd = Usdt;	//	100$
		//float max = Usdt;
		//
		float s=0;
		//
		FOR(0, i, DECODEUR) {
			uint mega_t = ENCODEUR + i;
			//
			uint ty        = t_MODE(t, mega_t);
			uint t_btcusdt = ts__d[t] + mega_t;
			assert(t_btcusdt < T);
			//
			//
			float _y = y[ty*Y + 0];
			assert(_y >= -1 && _y <= +1);
			//
			float _p1p0 = p1p0[t_btcusdt*1 + mega_t];
			//
			//s += powf(_y - sng(_p1p0), 2)/2 * (powf(1+fabs(_p1p0)*100, 3.0)-1);
			s += S(_y, _p1p0);
			//
			//
			//usd = usd + usd * _y * _p1p0  * Levier;
			//max = max + max * fabs(_p1p0) * Levier;
			//
			//float _S = S(A, _y, _p1p0);
			//assert(_S >= 0);
		}
		//
		atomicAdd(&somme_score[0], s);//powf(usd/max - max/max, 2)/2);
	}
};

float f_btcusdt(BTCUSDT_t * btcusdt, float * y__d, uint * ts__d) {
	uint Y = btcusdt->Y;
	//
	//
	float * somme__d = cudalloc<float>(1);
	k__f_btcusdt<<<dim3(KERD(GRAND_T, 16)), dim3(16)>>>(
		somme__d,
		y__d, btcusdt->sorties__d,
		ts__d,
		Y,
		btcusdt->T
	);
	ATTENDRE_CUDA();
	//
	//
	float * somme = gpu_vers_cpu<float>(somme__d, 1);
	//
	float score = somme[0] / ((float)(GRAND_T * DECODEUR));
	//
	//
	cudafree<float>(somme__d   );
	    free       (somme      );
	//
	return score;
};