#pragma once

#include "meta.cuh"

#define Usdt   100
#define Levier 10

#define  score_p2(y,w,C) ( powf(y-w, C  )/(float)C )
#define dscore_p2(y,w,C) ( powf(y-w, C-1)          )

//	-------------------------------------

/*
L = 20
u0 = 100          ;
u1 = u0 + u0*y0*c0*L; du0 = du1 * (1 + 1*y0*c0*L); dy0 = du1 * u0 * c0 * L
u2 = u1 + u1*y1*c1*L; du1 = du2 * (1 + 1*y1*c1*L); dy1 = du2 * u1 * c1 * L
u3 = u2 + u2*y2*c2*L; du2 = du3 * (1 + 1*y2*c2*L); dy2 = du3 * u2 * c2 * L

du3 = (u3 - u0) / max([u3, u0])

*/

//	------------------------------------

typedef struct {
	//
	uint X;	//	L*N
	uint Y;	//	P
	//
	uint T;

	//	Espaces
	float * entrees__d;	//	X * T
	float * sorties__d;	//	Y * T
} BTCUSDT_t;

BTCUSDT_t * cree_btcusdt(char * fichier);
void     liberer_btcusdt(BTCUSDT_t * btcusdt);
//
float *  pourcent_btcusdt(BTCUSDT_t * btcusdt, float * y__d, uint * ts__d, float coef_puissance);
//
float  f_btcusdt(BTCUSDT_t * btcusdt, float * y__d,                uint * ts__d);
void  df_btcusdt(BTCUSDT_t * btcusdt, float * y__d, float * dy__d, uint * ts__d);