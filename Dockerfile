FROM  cyversevice/rstudio-verse:3.6.0

RUN apt-get update && apt-get install -y \
	zlib1g-dev \
	libxml2-dev \
	bzip2 \
	gcc-multilib
	
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.0.5-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh


# give write permissions to conda folder
RUN chmod 777 -R /opt/conda/

ENV PATH=$PATH:/opt/conda/bin

ADD Renviron.site /usr/local/lib/R/etc/

RUN conda config --add channels bioconda

RUN conda upgrade conda

# add  conda packages
RUN conda install -c conda-forge -c bioconda conda bowtie bedtools viennarna fasta_ushuffle seqkit 

RUN cd /usr/local/bin && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-ia32-linux.tar.gz && \
	tar -xvzf blast-2.2.26-ia32-linux.tar.gz 

ENV PATH=$PATH:/usr/local/bin/blast-2.2.26/bin
	
RUN Rscript -e 'install.packages(c("BiocManager", "stringr", "seqinr", "scales", "PRROC", "miRNAss", "PCIT", "igraph", "HextractoR", "CD-Hit", "eMIRNA"))'
RUN Rscript -e 'BiocManager::install(c("Biobase", "NOISeq", "edgeR"));'


