# Set the R mirror to UMich
local({r <- getOption("repos")
       r["CRAN"] <- "https://repo.miserver.it.umich.edu/cran"
       options(repos=r)})

options(Ncpus = as.integer(system("/usr/bin/nproc", intern = TRUE)) - 1)