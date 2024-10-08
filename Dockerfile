# Use rocker/rstudio with R 4.1.0 for ARM compatibility
FROM rocker/rstudio:4.1

# Install system dependencies required by ArchR and Bioconductor packages
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libhdf5-dev \
    libgmp-dev \
    libglpk-dev \
    libxml2-utils \
    libbz2-dev \
    libgsl-dev \
    liblzma-dev \
    libcairo2 \
    && rm -rf /var/lib/apt/lists/*


# Install Bioconductor version 3.15 and ArchR dependencies

RUN R -e "install.packages('BiocManager', repos='http://cran.r-project.org'); \
    BiocManager::install(version = '3.14'); \
    BiocManager::install(c('Rsamtools', 'ComplexHeatmap', 'SingleCellExperiment', 'SummarizedExperiment', \
                           'GenomeInfoDb', 'AnnotationHub', 'GenomicRanges'))"
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rlang/rlang_1.1.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/vctrs/vctrs_0.5.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/lifecycle/lifecycle_1.0.2.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.4.2.tar.gz', repos = NULL, type = 'source')"
RUN R -e "devtools::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())"
RUN R -e "install.packages('Cairo')"


# Install ggplot2 version 3.4.2
#RUN R -e "install.packages('remotes'); \
#    remotes::install_version('ggplot2', version = '3.4.2')"

# Expose RStudio server port
EXPOSE 8787