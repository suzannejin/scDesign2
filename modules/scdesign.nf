process GET_MODEL {

    tag "$cell_type"
    publishDir "${params.outdir}/${cell_type}/model", mode: params.publish_dir_mode

    input:
    tuple val(cell_type), file(traincount)

    output:
    tuple val(cell_type), file("model.rds")

    when:
    !file("${params.outdir}/${cell_type}/model/model.rds").exists()

    script:
    """
    Rscript ${baseDir}/bin/get-model.R \
        ${traincount} \
        ${cell_type} \
        .
    """

}

process SIMULATE_DATA {

    tag "$cell_type"
    publishDir "${params.outdir}/${cell_type}/data", mode: params.publish_dir_mode

    input:
    tuple val(cell_type), file(model), file(traincount), file(testcount)

    output:
    tuple val(cell_type), file("simulated*.rds")

    script:
    """
    Rscript ${baseDir}/bin/simulate-data.R \
        ${traincount} \
        ${testcount} \
        ${cell_type} \
        ${model} \
        .
    """
}