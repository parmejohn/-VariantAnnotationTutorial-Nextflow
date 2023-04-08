FROM ubuntu:20.04

#COPY environment.txt .
COPY environments/* .

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda create -n qc -y --file spec-file-qc.txt
RUN conda create -n assembly -y --file spec-file-assembly.txt
RUN conda create -n mapping -y --file spec-file-mapping.txt
RUN conda create -n kraken -y --file spec-file-kraken.txt
RUN conda create -n var -y --file spec-file-var.txt
RUN conda create -n anno -y --file spec-file-anno.txt
RUN conda create -n phylo -y --file spec-file-phylo.txt
RUN conda create -n voi -y --file spec-file-voi.txt
