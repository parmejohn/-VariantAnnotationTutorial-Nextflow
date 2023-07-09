params.trimmed = "$projectDir/trimmed"

log.info """\
    ===================================
	Trimming
    ===================================
    """
    .stripIndent()

process TRIM {
	publishDir params.trimmed, mode:'copy'

	input:
	tuple val(sample_id), path(reads)

	output:
	//path "${reads[0]}"
	//path "${reads[1]}"
	path "${sample_id}_trimmed_R1.fastq.gz"
	path "${sample_id}_trimmed_R2.fastq.gz"
	path "${sample_id}.fastp.html"
	path "${sample_id}.fastp.json"

	script:
	"""
	fastp --detect_adapter_for_pe --overrepresentation_analysis \
	--correction --cut_right --thread 2 \
	--html ${sample_id}.fastp.html \
	--json ${sample_id}.fastp.json  \
	-i ${reads[0]} -I ${reads[1]} \
	-o ${sample_id}_trimmed_R1.fastq.gz \
	-O ${sample_id}_trimmed_R2.fastq.gz
	"""
}