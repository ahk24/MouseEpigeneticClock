library(data.table)
library(stringr)
locations_of_samples_of_interest <-"/home/panano/Downloads/DNA_methylation_data/table_for_life_span_columns.csv"
names <- read.table(locations_of_samples_of_interest, sep = ";", stringsAsFactors = FALSE, header = FALSE)
for(i in 1:nrow(names))
{
  print(i)
  print(names[i,1])
  print(Sys.time())
  if(str_sub(names[i,2], start= -3) != '.gz')
  {
    print(system.time({  data0 <- fread(names[i,2],header = FALSE, stringsAsFactors = FALSE) }))
  }
  else
  {print(system.time({  data0 <- fread(paste0("zcat ", names[i,2])) }))}
  print(system.time({  
    index <- paste0(data0[[1]],"_",data0[[2]])
    coverage <- data0[[5]] + data0[[6]]
    data1 <- data.frame("chr" = data0[[1]], "index" = index, "coverage" = coverage, "metlev" = data0[[4]], stringsAsFactors = FALSE)
    outfilename <- paste0("/home/panano/Downloads/DNA_methylation_data/metcov/",names[i,1],".metcov")
    fwrite(data1,file = outfilename,col.names = TRUE)
    system(paste0("pigz -p 8 ",outfilename))
  }))
}