library(remotes)
bioc = remotes:::bioc_version()

# CRAN repos snapshot
when = '2020-12-17'
repos = list(snapshot = paste0('http://mran.revolutionanalytics.com/snapshot/', when),
             cran = 'https://cloud.r-project.org/',
             bioc = paste0('https://bioconductor.org/packages/', bioc, '/bioc'),
             bioc_annot = paste0('https://bioconductor.org/packages/', bioc, '/data/annotation')
             )
options(repos = list(CRAN = repos$snapshot))

# install CRAN packages
pkgs = c('copula', 
         'Rtsne', 
         'plyr', 
         'reshape2', 
         'gridExtra',
         'ggplot2',
         'ggpubr',
         'cowplot'
         )
install.packages(pkgs)

# install scDesign2
devtools::install_github("JSB-UCLA/scDesign2@b2772cf25d7ab404deda15d045a75f5a41f16cbb")
