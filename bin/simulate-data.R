library(scDesign2)
library(copula)   

# usage: simulate-data.R <traincount> <testcount> <cell_type> <model> <output dir>
args = commandArgs(trailingOnly = T)
traincount = readRDS(args[1])
testcount = readRDS(args[2])
cell_type = args[3]
model = readRDS(args[4])
output_dir = args[5]

# simulate test data - as control ------------------------------------------------
message("simulate data for test")
ncell = length(which(colnames(testcount) == cell_type))
simulated = simulate_count_scDesign2(model, ncell, sim_method = 'copula')
simulated2 = t(simulated)
saveRDS(simulated, paste0(output_dir, "/simulated-test.rds"))

# simulate data with different sequencing depth ----------------------------------
ncell = length(which(colnames(traincount) == cell_type))
nread = sum(traincount[,colnames(traincount) == cell_type])
rs = c("-20"  = 1/20,
       "-10"  = 1/10,
       "-5"   = 1/5,
       "-2"   = 1/2,
       "+1"   = 1,
       "+2"   = 2,
       "+5"   = 5,
       "+10"  = 10,
       "+20"  = 20,
       "+50"  = 50,
       "+100" = 100
      )
for (i in 1:length(rs)){
    name = names(rs)[i]
    r = rs[i]
    message("simulate model with r=", r, "; nread old=", nread, "; nread new=", nread*r)

    # simulate data
    simulated = simulate_count_scDesign2(model, ncell, total_count_new=nread*r, sim_method = 'copula')

    # save 
    saveRDS(simulated, paste0(output_dir, "/simulated", name, ".rds"))
}