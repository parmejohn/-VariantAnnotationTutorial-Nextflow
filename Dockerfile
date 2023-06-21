FROM ubuntu:20.04

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

WORKDIR /opt
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
unzip fastqc_v0.12.1.zip && \
chmod +x FastQC/fastqc && \
ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc