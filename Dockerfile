# Use rocker/rstudio with R 4.1.0 for ARM compatibility
FROM rocker/rstudio:4.1

# Install system dependencies required by ArchR and Bioconductor packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    zlib1g \
    zlib1g-dev \
    libxml2-utils \
    libbz2-dev \
    libgsl-dev \
    liblzma-dev \
    libcairo2-dev \
    libXt-dev \
    libgtk2.0-dev \
    xvfb \
    xauth \
    xfonts-base

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Install R packages and dependencies
RUN R -q -e 'install.packages(c("curl", "zlib", "devtools", "BiocManager", "Cairo"))'
RUN R -q -e 'devtools::install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories())'
