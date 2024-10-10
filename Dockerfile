# Use rocker/rstudio with R 4.1.0 for ARM compatibility
FROM rocker/rstudio:4.1

# Environment Settings for parallel compiling
COPY ./files/ /home/rstudio/
RUN echo 'export MAKEFLAGS="-j$(($(nproc) - 1))"' >> /etc/profile.d/makeflags.sh \
    && cat <<EOT >> /usr/local/lib/R/etc/Rprofile.site
# Set the R mirror to UMich
local({r <- getOption("repos")
r["CRAN"] <- "https://repo.miserver.it.umich.edu/cran"
options(repos=r)})

options(Ncpus = as.integer(system("/usr/bin/nproc", intern = TRUE)) - 1)
EOT

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
    libxt-dev \
    libgtk2.0-dev \
    xvfb \
    xauth \
    xfonts-base \
    libglpk-dev 

# Install R packages and dependencies
RUN R -q -e 'install.packages(c("devtools", "BiocManager", "Seurat", "Cairo", "hexbin"))' \
    && R -q -e 'devtools::install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories())' \
    && R -q -e 'BiocManager::install("BiocVersion")'

# Cleanup
RUN rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*
