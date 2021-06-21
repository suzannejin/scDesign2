library(zCompositions)
library(propr, lib.loc=paste0(.libPaths()[1], "/propr_sjin"))

# usage: clr-data.R <count> <output dir> <zero handling method> ---------------
args = commandArgs(trailingOnly = T)
countfile = args[1]
output_dir = args[2]
zerohandling = args[3]
if (!zerohandling %in% c("one", "min", "zcompositions")){
    stop("Error: please give a proper zero handling method {one, min, zcompositions}")
}

# filename affix
name = gsub(".rds", "", basename(countfile))

# process and transform data --------------------------------------------------
count = t(readRDS(countfile))
dim(count)
class(count)

# replace zeros 
message("replace zeros")
if (zerohandling == "zcompositions"){
    if(any(count<0, na.rm=T)) stop("counts matrix contain negative values")
    count = cmultRepl(count, method="CZM", label=0, output="counts")  
}else if (zerohandling == "one"){
    count[count == 0] = 1
}else{
    zeros = count == 0
    count[zeros] = min(count[!zeros])
}

# clr-transform data
message("CLR-transform data")
clr = propr:::proprCLR(count)
clr = t(clr)

# save output
saveRDS(clr, paste0(output_dir, "/", name, "_clr_", zerohandling, ".rds"))