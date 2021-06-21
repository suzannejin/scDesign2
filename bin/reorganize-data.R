library(scDesign2)

# read and organize data ----------------------------------------------------------------
data_mat <- readRDS(system.file("extdata", "mouse_sie_10x.rds", package = "scDesign2"))

# remove spike-in 
nonspikes <- which(!grepl("ercc", rownames(data_mat), ignore.case = TRUE))
print(paste("number of spike-ins:", nrow(data_mat)-length(nonspikes)))
data_mat <- data_mat[nonspikes, ,drop = FALSE]

# split data into train and test set 
unique_cell_type <- names(table(colnames(data_mat)))
set.seed(1)
train_idx <- unlist(sapply(unique_cell_type, function(x){
  cell_type_idx <- which(colnames(data_mat) == x)
  n_cell_total <- length(cell_type_idx)
  sample(cell_type_idx, floor(n_cell_total/2))
}))
traincount <- data_mat[, train_idx]
testcount <- data_mat[, -train_idx]


# save data ------------------------------------------------------------------------------
outdir = "/users/cn/sjin/projects/proportionality/scDesign2/data"
saveRDS(traincount, paste0(outdir, "/traincount.rds"))
saveRDS(testcount, paste0(outdir, "/testcount.rds"))