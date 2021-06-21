library(scDesign2)
library(copula)   

# usage: get-model.R <traincount> <cell type> <output directory> -----------------------
args = commandArgs(trailingOnly = T)
traincount = readRDS(args[1])
cell_type = args[2]
output_dir = args[3]

# fit model and save data --------------------------------------------------------------
RNGkind("L'Ecuyer-CMRG")
set.seed(1)
model <- fit_model_scDesign2(traincount, cell_type, sim_method = 'copula')
saveRDS(model, file = paste0(output_dir, "/model.rds"))