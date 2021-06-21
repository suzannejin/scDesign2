process CLR_DATA {

    tag "${cell_type}-${zerohandling}-${count}"
    publishDir "${params.outdir}/${cell_type}/data", mode: params.publish_dir_mode

    input:
    tuple val(cell_type), file(count), val(zerohandling)

    output:
    tuple val(cell_type), file("*_clr_${zerohandling}.rds")

    when:
    params.clr

    script:
    """
    Rscript ${baseDir}/bin/clr-data.R \
        ${count} \
        . \
        ${zerohandling}
    """
}

process COEXPR {

    tag "${cell_type}-${method}-${count}"
    publishDir "${params.outdir}/${cell_type}/coexpr", mode: params.publish_dir_mode

    input:
    tuple val(cell_type), file(count), val(method)

    output:
    tuple val(cell_type), file("*_${method}.rds")

    script:
    """
    Rscript ${baseDir}/bin/coexpr.R \
        ${count} \
        ${method} \
        .
    """
}