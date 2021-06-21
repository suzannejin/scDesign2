#!/usr/bin/env nextflow

nextflow.enable.dsl = 2


////////////////////////////////////////////////////
/* --          VALIDATE INPUTS                 -- */
////////////////////////////////////////////////////

ch_cell_type = Channel.from(params.cell_types)
ch_traincount = Channel.fromPath(params.traincount)
ch_testcount = Channel.fromPath(params.testcount)
ch_zerohandling = Channel.fromList(params.zerohandling)
ch_methods = Channel.fromList(params.methods)

ch_cell_type
    .combine(ch_traincount)
    .set{ ch_traincount_cell }
ch_cell_type
    .combine(ch_testcount)
    .set{ ch_testcount_cell }
ch_traincount_cell
    .mix(ch_testcount_cell)
    .set{ ch_to_divide }

ch_to_getmodel = ch_traincount_cell


////////////////////////////////////////////////////
/* --          IMPORT LOCAL MODULES            -- */
////////////////////////////////////////////////////

include { GET_MODEL } from "${baseDir}/modules/scdesign.nf"
include { SIMULATE_DATA } from "${baseDir}/modules/scdesign.nf"

include { DIVIDE_CELL } from "${baseDir}/modules/data.nf"
include { GET_RELATIVE } from "${baseDir}/modules/data.nf"

include { CLR_DATA } from "${baseDir}/modules/propr.nf"
include { COEXPR } from "${baseDir}/modules/propr.nf"


////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow {

    // divide traincount/testcount data by cell type
    ch_divide_out = DIVIDE_CELL(ch_to_divide)

    /*
     * Step 1: Fit model
     */
    ch_getmodel_out = GET_MODEL(ch_to_getmodel)
    Channel
        .fromPath("${params.outdir}/*/model/model.rds")
        .map{ it -> [it.getParent().getParent().baseName, it]}  // cell_type, model
        .join(ch_cell_type, by:0)
        .mix(ch_getmodel_out)
        .set{ ch_model }
    ch_model
        .combine(ch_traincount)
        .combine(ch_testcount)
        .set{ ch_to_simulate }

    /*
     * Step 2: Simulate data with different sequencing depth
     */
    ch_simulate_out = SIMULATE_DATA(ch_to_simulate)
    ch_simulate_out
        .transpose()
        .mix(ch_divide_out)
        .combine(ch_model, by:0)
        .set{ ch_to_relative }

    /*
     * Step 3: Convert to relative data
     */
    ch_relative_out = GET_RELATIVE(ch_to_relative)
                        .map{ it -> [ it[0], [it[1], it[2]] ] }
                        .transpose()

    // organize channels
    if (params.clr){
        ch_relative_out
            .combine(ch_zerohandling)
            .set{ ch_to_clr }
    } else {
        ch_relative_out
            .combine(ch_methods)
            .set{ ch_to_coexpr }
    }

    /*
     * Step 4: CLR transform data (only if required)
     */
    if (params.clr){
        ch_clr_out = CLR_DATA(ch_to_clr)
        ch_clr_out
            .combine(ch_methods)
            .set{ ch_to_coexpr }
    }

    /*
     * Step 5: Compute association coefficients
     */
    ch_coexpr_out = COEXPR(ch_to_coexpr)
}