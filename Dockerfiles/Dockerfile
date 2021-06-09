# Docker inheritance
FROM bioconductor/bioconductor_docker:RELEASE_3_12  

# snapshot date 
ARG WHEN="2020-12-17"

# install R packages
ADD requirements.R /tmp/requirements.R 
RUN Rscript /tmp/requirements.R