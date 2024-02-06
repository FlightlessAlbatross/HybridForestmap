setwd("C:/Users/hofer/Documents/geocomputation_class/forestmap")

library(raster)

# Input files
features_file="out_data/spain_all_tif.vrt"
name_file ="out_data/available_features.txt"
coordinates_file="out_data/LUCAS/LUCAS_ES_XY.csv"

layer_names = read.table(name_file)$V1
layer_names = gsub("/","_",substr(layer_names, 10,nchar(layer_names) - 4))


# Output file
output_file="out_data/forest_data_Spain_lucas.csv"

coordinates <- read.csv(coordinates_file, header = F, sep = ' ')
features <- brick(features_file)
names(features) <- layer_names

start_time <- Sys.time()
a <- extract(features, coordinates)
end_time <- Sys.time()
end_time - start_time

apply(a, 2, function(y) sum(y==48 | is.na(y), na.rm = T) )
apply(a, 2, function(y) sum(y>=0.5, na.rm = T) )

write.table(a, output_file, sep = " ", row.names = F, col.names = F)
