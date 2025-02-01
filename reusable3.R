library(data.table)
library(stringr)

# Define the directory for DNA methylation data and read the table with sample paths
data_directory <- "/home/panano/Downloads/DNA_methylation_data"
table_path <- file.path(data_directory, "table_for_life_span.csv")

# Read the table with sample names and file paths correctly handling semicolon as a separator
names <- fread(table_path, sep = ";", header = TRUE, stringsAsFactors = FALSE)

# Create the output directory if it doesn't exist
output_directory <- file.path(data_directory, "metcov")
if (!dir.exists(output_directory)) {
  dir.create(output_directory)
}

for (i in seq_along(names)) {
  cat("Processing file:", i, "\n")
  cat("Current time:", Sys.time(), "\n")
  
  # Prepare file path and read data
  file_path <- file.path(data_directory, names[[i]])
  
  if (grepl("\\.gz$", file_path)) {
    data_cmd <- paste0("zcat ", file_path)
  } else {
    data_cmd <- file_path
  }
  
  # Safely read the file with error handling
  tryCatch({
    data0 <- fread(data_cmd, header = FALSE, stringsAsFactors = FALSE)
  }, error = function(e) {
    cat("Error reading data for sample", names[[i]], ": ", e$message, "\n")
    next
  })
  
  # Process data
  index <- paste0(data0[[1]], "_", data0[[2]])
  coverage <- data0[[5]] + data0[[6]]
  data1 <- data.frame("chr" = data0[[1]], "index" = index, "coverage" = coverage, "metlev" = data0[[4]], stringsAsFactors = FALSE)
  outfilename <- file.path(output_directory, paste0(gsub(".gz$", "", basename(names[[i]])), ".metcov"))
  
  # Write output and compress
  fwrite(data1, file = outfilename, col.names = TRUE)
  system(paste0("pigz -p 8 ", outfilename))
  
  # Clear memory
  rm(data0, data1, index, coverage)
  gc()
}

cat("All files processed\n")
