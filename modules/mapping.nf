params.mapping = "$projectDir/mappings"

log.info """\
    ===================================
	MAPPING
    ===================================
    """
    .stripIndent()

process BWA {
	publishDir params.mapping, mode:'copy'

	input:
	//path "$projectDir/assembly/spades-150/scaffolds.fasta"
	tuple val(sample_id), path(reads)

	output:
	path '*'

	script:
	"""
	bwa index $projectDir/assembly/spades-150/scaffolds.fasta

	bwa mem $projectDir/assembly/spades-150/scaffolds.fasta \
	${reads[0]} ${reads[1]} > ${sample_id}.sam
	"""
}

process POST_ALIGN {
	publishDir params.mapping, mode:'copy'

	input:
	tuple val(sample_id), path(mapping)

	output:
	path '*'

	script:
	"""
	# fixmate and compress to bam
	samtools sort -n -O sam ${mapping} | samtools fixmate -m -O bam - ${sample_id}.fixmate.bam

	# sort
	samtools sort -O bam -o ${sample_id}.sorted.bam $projectDir/mappings/${sample_id}.fixmate.bam
	rm $projectDir/mappings/${sample_id}.fixmate.bam

	# mark duplicates
	samtools markdup -r -S $projectDir/mappings/${sample_id}.sorted.bam ${sample_id}.dedup.bam
	rm $projectDir/mappings/${sample_id}.sorted.bam

	# run qualimap on dedup bams
	/opt/qualimap_v2.3/qualimap bamqc $projectDir/mappings/${sample_id}.dedup.bam

	# extract q20 mappers
	samtools view -h -b -q 20 $projectDir/mappings/${sample_id}.sorted.dedup.bam > ${sample_id}.sorted.dedup.q20.bam

	# extract unmapped
	samtools view -b -f 4 $projectDir/mappings/${sample_id}.sorted.dedup.bam > ${sample_id}.sorted.unmapped.bam
	rm $projectDir/mappings/${sample_id}.sorted.dedup.bam 

	# covert to fastq
	samtools fastq -1 ${sample_id}.sorted.unmapped.R1.fastq.gz -2 ${sample_id}.sorted.unmapped.R2.fastq.gz $projectDir/mappings/${sample_id}.sorted.unmapped.bam

	# delete not needed files
	rm $projectDir/mappings/${sample_id}.sorted.unmapped.bam
	"""
}

workflow MAPPING {
	take:
		trimmed_ch_pairs
	main:
		BWA (trimmed_ch_pairs)
		post_align_ch = Channel.fromPath("$projectDir/mappings").map {
    		tuple( it.name.split('.')[0], it )
		}
		POST_ALIGN (post_align_ch)
}