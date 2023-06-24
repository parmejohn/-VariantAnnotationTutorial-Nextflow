# Variant annotation Nextflow pipeline
A Nextflow pipeline based off a variant annotation tutorial by [Sebastian Schmeier](https://genomics.sschmeier.com/index.html)

## Dependencies
- Nextflow
- Docker

## Usage
```
nextflow run main.nf
```
Ensure that Docker may run [without root privileges](https://docs.docker.com/engine/security/rootless/)

### Output files
- ./trimmed/ = reads that have been trimmed with fastp
