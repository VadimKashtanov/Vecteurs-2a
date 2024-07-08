#include "main.cuh"

void ecrire_structure_generale(char * file) {
	uint I = 3;
	FILE * fp = FOPEN(file, "wb");
	//
	FWRITE(&I, sizeof(uint), 1, fp);
	//
	uint elements[I] = {
		ENCODEUR, DECODEUR, MEGA_T
	};
	FWRITE(elements, sizeof(uint), I, fp);
	//
	fclose(fp);
};