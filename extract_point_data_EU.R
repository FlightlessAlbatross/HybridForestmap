setwd("C:/Users/hofer/Documents/geocomputation_class/forestmap")

library(raster)
library(XML)


# Input files
features_file="out_data/EU_all_tif.vrt"
# name_file ="out_data/available_features.txt"
coordinates_file="out_data/LUCAS/LUCAS_EU_XY.csv"


vrt_xml <- xmlParse(features_file)
file_nodes <- getNodeSet(vrt_xml, "//SourceFilename")
file_names <- sapply(file_nodes, xmlValue)

layer_names = gsub("/","_",file_names)

# Output file
output_file="out_data/forest_data_EU_lucas.csv"

coordinates <- read.csv(coordinates_file, header = F, sep = ' ')
features <- brick(features_file)
names(features) <- layer_names

start_time <- Sys.time()
a <- extract(features, coordinates)
end_time <- Sys.time()
end_time - start_time


apply(a, 2, function(y) sum(y==48 | is.na(y), na.rm = T) )

coordinates[which(is.na(a[,1])),]



write.table(a, output_file, sep = " ", row.names = F, col.names = F)

end_time - start_time
