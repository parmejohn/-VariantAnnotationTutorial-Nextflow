include { TRIM } from './trim'
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
}

workflow.onComplete {
    log.info ( workflow.success ? "\nFinished Var anno\n" : "Oops .. something went wrong" )
}