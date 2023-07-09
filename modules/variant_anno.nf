include { TRIM } from './trim'
include { QC } from './qc'
include { QUAST; SPADES } from './assembly'
include { SPADES as SPADES_OG } from './assembly'

//params
params.reads = "$projectDir/data/*_{R1,R2}.fastq.gz"

workflow VARIANT_ANNO {
	//Initializing raw fastq.gz files
	Channel
		.fromFilePairs(params.reads, checkIfExists: true)
		//.view()
		.set { read_pairs_ch }
	
	//QC
	TRIM (read_pairs_ch)
	trimmed_ch = Channel.fromPath("$projectDir/trimmed/*.fastq.gz")
	qc_ch = QC (trimmed_ch.collect())

	//Genome assembly
	Channel
		.fromFilePairs("$projectDir/trimmed/*_{R1,R2}.fastq.gz", checkIfExists: true)
		//.view()
		.set { trimmed_samples_ch }
	spades150_ch = SPADES (trimmed_samples_ch, "spades-150")
	spadesog_ch = SPADES_OG (read_pairs_ch, "spades-og")

	QUAST (spades150_ch, spadesog_ch)

	//Mapping

	//Kraken

	//Variant calling and annotation

	//Phylogeny

	//VOI

}

workflow.onComplete {
    log.info ( workflow.success ? "\nFinished Variant annotation\n" : "Oops .. something went wrong" )
}