library(stringr)
library(propr, lib.loc=paste0(.libPaths()[1], "/propr_sjin"))

# usage: coexpr.R <count> <method> <output dir> -----------------------------------------
args = commandArgs(trailingOnly = T)
countfile = args[1]
coef = args[2]
output_dir = args[3]

# filename affix
name = gsub(".rds", "", basename(countfile))

# read count data
count = t(readRDS(countfile))

# compute coexpr ------------------------------------------------------------------------
coexpr = propr(count, metric=coef, ivar=NA, p=0)@matrix  # TODO add permutation after modifying the propr code to allow FDR on the negative tail
# coexpr = propr(dat, metric=coef, ivar=NA, p=20)
# coexpr = updateCutoffs(coexpr, seq(min(coexpr@matrix), max(coexpr@matrix), length=102)[2:101])
saveRDS(coexpr, paste0(output_dir, "/", name, "_", coef, ".rds"))