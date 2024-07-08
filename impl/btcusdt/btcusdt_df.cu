#include "btcusdt.cuh"

#include "../impl_template/tmpl_etc.cu"

static __global__ void k__df_btcusdt(
	float * y, float * p1p0, float * dy,
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
			//dy[ty*Y + 0] = (_y - sng(_p1p0))  * (powf(1+fabs(_p1p0)*100, 3.0)-1)  / ((float)(GRAND_T * DECODEUR));
			//
			float _ds = dS(_y, _p1p0);
			float diviseur = ((float)(GRAND_T * DECODEUR));
			dy[ty*Y + 0] = _ds / diviseur;
			//
			//
			//usd = usd + usd * _y * _p1p0  * Levier;
			//max = max + max * fabs(_p1p0) * Levier;
		}
		//
		/*float s  = powf(usd/max - max/max, 2)/2;
		float ds = (usd/max - max/max) * 1/max;
		//
		float dusdt = ds;
		//
		RETRO_FOR(0, i, DECODEUR) {
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
			//
			//usd = usd*(1 + _y * _p1p0  * L);
			float usdt_avant = usd / (1 + _y * _p1p0 * Levier);
			dy[ty*Y + 0] = dusdt * usd * _p1p0 * Levier;
			//
			dusdt = dusdt * (1 + _y*_p1p0*Levier);
			usd = usdt_avant; 
			//max = max + max * fabs(_p1p0) * L;
		}*/
	}
};

void df_btcusdt(BTCUSDT_t * btcusdt, float * y__d, float * dy__d, uint * ts__d) {
	uint Y = btcusdt->Y;
	//
	//
	k__df_btcusdt<<<dim3(KERD(GRAND_T, 16)), dim3(16)>>>(
		y__d, btcusdt->sorties__d, dy__d,
		ts__d,
		Y,
		btcusdt->T
	);
	ATTENDRE_CUDA();
};