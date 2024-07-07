#include "mdl.cuh"

#include "../../impl_template/tmpl_etc.cu"

void mdl_optimisation(Mdl_t * mdl) {
	mdl_optimisation_DECODEUR(mdl);
	mdl_optimisation_ENCODEUR(mdl);
};