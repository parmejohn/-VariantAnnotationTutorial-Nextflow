params.assembly = "$projectDir/trimmed/assembly"
params.spades150 = "$projectDir/trimmed/assembly/spades-150"
params.spadesog = "$projectDir/trimmed/assembly/spades-og"
params.quast = "$projectDir/trimmed/assembly/quast"

log.info """\
    ===================================
	Assembly
    ===================================
    """
    .stripIndent()

process SPADES {
	publishDir params.assembly, mode:'copy'
	
	input:
	tuple val(sample_id), path(reads)
	val type 

	output:
	path "${type}"

	script:
	"""
	mkdir ${type}
	spades.py -o ${type}/ --careful -1 ${reads[0]} \
	-2 ${reads[1]}
	"""
}

process QUAST {
	publishDir params.quast, mode:'copy'
	
	input:
	path spades_target
	path spades_og

	output:
	path '*'

	script:
	"""
	quast -o . ${spades_target}/scaffolds.fasta ${spades_og}/scaffolds.fasta
	"""
}