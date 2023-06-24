params.fastqc = "$projectDir/trimmed/fastqc"
params.multiqc = "$projectDir/trimmed/multiqc"

process FASTQC {
	publishDir params.fastqc, mode:'copy'

	input:
	path trims

	output:
	path '*'

	script:
	"""
	fastqc -o . -f fastq -q ${trims}
	"""
}

process MULTIQC {
	publishDir params.multiqc, mode:'copy'

	input:
	path fastqc
	path trims

	output:
	path 'multiqc_report.html'

	script:
    """
    multiqc ${fastqc} ${trims}
    """
}

workflow QC {
	take:
		trimmed_ch
	main:
		fastqc_ch = FASTQC(trimmed_ch)
		multi_ch = MULTIQC(fastqc_ch, trimmed_ch)
}