include { TRIM } from './trim'
include { QC } from './qc'
params.reads = "$projectDir/data/*_{R1,R2}.fastq.gz"


log.info """\
	Trimming
    ===================================
    reads        : ${params.reads}
    """
    .stripIndent()

// include { QC } from './qc'

workflow VARIANT_ANNO {
	Channel
		.fromFilePairs(params.reads, checkIfExists: true)
		//.view()
		.set { read_pairs_ch }
	
	TRIM (read_pairs_ch)
	trimmed_ch = Channel.fromPath("$projectDir/trimmed/*.fastq.gz")
	trimmed_ch.view()
	qc_ch = QC (trimmed_ch.collect())

}

workflow.onComplete {
    log.info ( workflow.success ? "\nFinished Var anno\n" : "Oops .. something went wrong" )
}