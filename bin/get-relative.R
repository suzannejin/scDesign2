# usage: get-relative.R <count> <model> <output dir>
args = commandArgs(trailingOnly = T)
countfile = args[1]
model = readRDS(args[2])
outdir = args[3]

# filename affix
name = gsub(".rds", "", basename(countfile))

# read and process count data
count = t(readRDS(countfile))
relative = count / rowSums(count) * mean(rowSums(count))

# filter low-expression genes
genes = model[[1]]$gene_sel1
count = count[,genes]
relative = relative[,genes]

# save data
saveRDS(t(count), paste0(outdir, "/", name, "_absolute.rds"))
saveRDS(t(relative), paste0(outdir, "/", name, "_relative.rds"))