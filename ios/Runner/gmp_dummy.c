#include "gmp.h"

/**
 * @brief This function's only purpose is to create references to GMP symbols.
 * The '__attribute__((used))' directive is a command to the compiler to
 * NEVER discard this function, even if it appears unused. This ensures that
 * the linker sees the symbol references.
 */
__attribute__((used))
void force_gmp_symbols(void) {
    // This array of function pointers creates the necessary references.
    // Marking it as 'volatile' and 'used' provides maximum protection
    // against aggressive compiler optimization.
    volatile __attribute__((used)) void *dummy_references[] = {
        (void *)__gmpz_init_set_str,
        (void *)__gmpz_get_str,
        (void *)__gmpz_clear,
        (void *)__gmpz_pow_ui
    };
    (void)dummy_references;
}
