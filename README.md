# Variant annotation Nextflow pipeline
A Nextflow pipeline based off a variant annotation tutorial by [Sebastian Schmeier](https://genomics.sschmeier.com/index.html)

## Dependencies
- Nextflow
- Docker

## Usage
Clone the git repository into the directory of your choice, and run the following command from the cloned directory
```
nextflow run main.nf
```
Ensure that Docker may run [without root privileges](https://docs.docker.com/engine/security/rootless/)

Docker images were uploaded and can be found on my [Docker Hub](https://hub.docker.com/repositories/parmejohn)

### Output files
- ./trimmed/ = reads that have been trimmed with fastp
  - fastqc/ = files generated from the fastqc command
  - multiqc/ = contains a html report that summarizes the fastqc files and trimmed reads
