// include module scripts
include { VARIANT_ANNO } from './modules/variant_anno'

// set parameter values

// Run the main function
workflow NF_ VARIANT_ANNO {
    VARIANT_ANNO ()
}