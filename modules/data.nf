process DIVIDE_CELL {
    tag "${cell_type}-${count}"
    publishDir "${params.outdir}/${cell_type}/data", mode: params.publish_dir_mode

    input:
    tuple val(cell_type), file(count)

    output:
    tuple val(cell_type), file("*_${cell_type}.rds")

    script:
    """ 
    Rscript ${baseDir}/bin/divide-cell.R \
        ${count} \
        ${cell_type} \
        .
    """
}

process GET_RELATIVE {
    tag "${cell_type}-${count}"

    input:
    tuple val(cell_type), file(count), file(model)

    output:
    tuple val(cell_type), file("*_absolute*"), file("*_relative*")

    script:
    """
    Rscript ${baseDir}/bin/get-relative.R \
        ${count} \
        ${model} \
        .
    """
}