FROM ubuntu:20.04

# get past region warnings
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install \
	wget \
    openjdk-8-jre \
    perl \
    unzip \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    build-essential \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install fastqc
WORKDIR /opt
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
unzip fastqc_v0.12.1.zip && \
chmod +x FastQC/fastqc && \
ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc

# Install Fastp
RUN wget https://github.com/OpenGene/fastp/archive/v0.20.1.tar.gz && \
    tar xvzf v0.20.1.tar.gz && \
    cd fastp-0.20.1 && \
    make && \
    cp fastp /usr/local/bin/

# Install MultiQC
RUN pip3 install multiqc