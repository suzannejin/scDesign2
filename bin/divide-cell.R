# usage: divide-cell.R <count> <cell type> <outdir> 
args = commandArgs(trailingOnly = T)
countfile = args[1]      # traincount or testcount
cell_type = args[2]
outdir = args[3]

# filename
name = gsub(".rds", "", basename(countfile))
output = paste0(outdir, "/", name, "_", cell_type, ".rds")

# select cells
count = readRDS(countfile)
if (cell_type %in% unique(colnames(count))){
    count = count[,colnames(count) == cell_type]
}else{
    stop("Erroneous cell type")
}

# save
saveRDS(count, output)