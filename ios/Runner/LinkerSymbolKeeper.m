#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>
#include <flint/fmpz.h>
// #include <symengine/cwrapper.h>

// By making this a static global variable, we satisfy the compiler warning.
// The 'used' attribute ensures the linker keeps this array and its references.
__attribute__((used))
static volatile void *dummy_references[] = {
    // --- GMP Symbols ---
    (void *)__gmpz_init_set_str,
    (void *)__gmpz_get_str,
    (void *)__gmpz_clear,
    (void *)__gmpz_pow_ui,
    
    // --- MPFR Symbols ---
    (void *)mpfr_init2,
    (void *)mpfr_const_pi,
    (void *)mpfr_get_str,
    (void *)mpfr_clear,

    // --- MPC Symbols ---
    (void *)mpc_init2,
    (void *)mpc_get_str,
    (void *)mpc_clear,
    (void *)mpc_mul,

    // --- FLINT Symbols ---
    (void *)fmpz_init,
    (void *)fmpz_fac_ui,
    (void *)fmpz_get_str,
    (void *)fmpz_clear,

    // --- SymEngine Symbols ---
    /*
    (void *)basic_new_heap,
    (void *)basic_const_pi,
    (void *)basic_str,
    (void *)basic_free_stack
    */
};

/**
 * @brief This function's only purpose is to ensure the C file is compiled
 * into the project, forcing the linker to process the dummy_references array.
 */
__attribute__((used))
void force_symbolic_math_linking(void) {
    // The function body can be empty. Its existence is what matters.
}