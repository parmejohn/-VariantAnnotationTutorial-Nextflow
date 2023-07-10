params.assembly = "$projectDir/assembly"
params.spades150 = "$projectDir/assembly/spades-150"
params.spadesog = "$projectDir/assembly/spades-og"
params.quast = "$projectDir/assembly/quast"

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
	/usr/local/bin/quast.py -o . ${spades_target}/scaffolds.fasta ${spades_og}/scaffolds.fasta
	"""
}