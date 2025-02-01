library(data.table)

# Define the directory containing the files
input_directory <- "/home/panano/Downloads/DNA_methylation_data/MouseEpigeneticClock/deduplicated/cov/zipped/"
output_directory <- "/home/panano/Downloads/DNA_methylation_data/MouseEpigeneticClock/deduplicated/cov/zipped_modified"  # Directory to save modified files

# Create the output directory if it doesn't exist
if (!dir.exists(output_directory)) {
  dir.create(output_directory)
}

# List all .bismark.cov.gz files in the input directory
files <- list.files(
  path = input_directory,
  pattern = "\\.bismark\\.cov\\.gz$",
  full.names = TRUE
)

# Process each file
for (file in files) {
  # Read the file as-is:
  #  - header = FALSE (assuming no header line in a .bismark.cov.gz file)
  #  - sep = "\t" to preserve tab-delimited structure
  #  - quote = "" to avoid any quotes being interpreted
  dt <- fread(file, header = TRUE)
  
  # ONLY remove "chr" from the first column. Use a regular expression or fixed=TRUE
  dt[, V1 := sub("^chr", "", V1)]  # remove leading 'chr' if present
  
  # Construct output file name (example: "modified_filename.bismark.cov.gz")
  out_file <- file.path(
    output_directory,
    paste0("modified_", basename(file))
  )
  
  # Write the data back out in the same tab-delimited, gzipped format, no quotes:
  #  - col.names = FALSE (since original .bismark.cov files usually have no header)
  fwrite(
    dt,
    file = out_file,
    sep = "\t",
    quote = FALSE,
    compress = "gzip",
    col.names = FALSE
  )
}

cat("Finished removing 'chr' from the first column in all files.\n",
    "Modified files are in:", output_directory, "\n")
