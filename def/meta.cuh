#pragma once

#include "etc.cuh"

#define GRAND_T (1 * 16)

#define ENCODEUR (  8  )
#define DECODEUR ( 1*24)

#define MEGA_T (ENCODEUR + DECODEUR)

//	La partie ENCODEUR analyse ce qu'il se passe. Puis la partie decodeur achète / vent
//  *   *   *   *  S5  S6  S7  S8
// f() f() f() f() f() f() f() f()
// t0  t1  t2  t3  t4  t5  t6  t7

//	Les Parantèses () sont importantes.

#define t_MODE(t, mega_t) ( (t)*MEGA_T + (mega_t) )