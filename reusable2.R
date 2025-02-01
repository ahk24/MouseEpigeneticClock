# Load necessary library
#if (!require("BiocManager", quietly = TRUE))
 # install.packages("BiocManager")

#install.packages("XML")
#if (!requireNamespace("BiocManager", quietly = TRUE))
  #install.packages("BiocManager")

#BiocManager::install("rtracklayer")

#BiocManager::install("methylKit")
library(methylKit)

# Path to the data files
# Adjust these paths to the directories where your data files are stored
setwd("/home/panano/Downloads/DNA_methylation_data/methylkit_ready/cg")
file_paths_wt <- list("/ID3213_1-WT3182DNA.CG.methylkit",
                      "/ID3213_2-WT3192DNA.CG.methylkit",
                      "/ID3213_3-WT1DNA.CG.methylkit",
                      "/ID3213_4-WT2DNA.CG.methylkit")

file_paths_ko <- list("/ID3213_5-KO4461DNA.CG.methylkit",
                      "/ID3213_6-KO4462DNA.CG.methylkit",
                      "/ID3213_7-KO4463DNA.CG.methylkit",
                      "/ID3213_8-KO4468DNA.CG.methylkit")

# Sample IDs for WT and KO mice
sample_ids_wt <- list("ID3213_1-WT3182DNA", "ID3213_2-WT3192DNA", "ID3213_3-WT1DNA", "ID3213_4-WT2DNA")
sample_ids_ko <- list("ID3213_5-KO4461DNA", "ID3213_6-KO4462DNA", "ID3213_7-KO4463DNA", "ID3213_8-KO4468DNA")

# Load methylation data for WT and KO
meth_data_wt <- methRead(file_paths_wt,
                         sample.id=sample_ids_wt,
                         assembly="mm10",
                         treatment=c(1,1,1,1), # All WT mice are controls in this case
                         context="CpG")

meth_data_ko <- methRead(file_paths_ko,
                         sample.id=sample_ids_ko,
                         assembly="mm10",
                         treatment=c(0,0,0,0), # All KO mice are experimental in this case
                         context="CpG")

# Normalize coverage
norm_data_wt <- normalizeCoverage(meth_data_wt)
norm_data_ko <- normalizeCoverage(meth_data_ko)

# Filter low coverage
filtered_data_wt <- filterByCoverage(norm_data_wt, lo.count=10, hi.perc=99)
filtered_data_ko <- filterByCoverage(norm_data_ko, lo.count=10, hi.perc=99)

# Combine the filtered data from WT for model training
# Assuming the age of WT mice is approximately 2 months
age_data_wt <- data.frame(sample_id=sample_ids_wt, age=rep(2, length(sample_ids_wt)))
combined_data_wt <- merge(age_data_wt, filtered_data_wt, by="sample_id")

# Regression model to predict age based on methylation in WT
model <- lm(age ~ methylation, data=combined_data_wt)

# Print the summary of the model to see results
summary(model)

# Predicting age for KO mice using the trained model
predictions_ko <- predict(model, newdata=filtered_data_ko)

# Output predictions for KO mice
print(predictions_ko)

