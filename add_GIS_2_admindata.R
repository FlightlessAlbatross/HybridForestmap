library(sf)
library(openxlsx)
library(data.table)

NUTS_raw <- st_read("C:/Users/hofer/Documents/Granular/LL_shapes/NUTS_RG_01M_2021_3035.geojson")


admin_raw <- openxlsx::read.xlsx('C:/Users/hofer/Documents/geocomputation_class/forestmap/in_data/admin/Forest area_ES_PL.xlsx', sheet = 2)
setDT(admin_raw)


ad <- melt.data.table(admin_raw[NUTS.level == 'NUTS 2'], 1:10, variable.name = 'year')

ad_nuts <- ad[ , .(forest_area = sum(value))  , ,.(country.ID, NUTS.ID, year)]

ad_national <- ad[ , .(forest_area = sum(value))  , ,.(country.ID, year)]


ad_nuts <- dcast(ad_nuts, country.ID + NUTS.ID ~ year, value.var = 'forest_area')

NUTS2 <- NUTS_raw[NUTS_raw$NUTS_ID %in% ad_nuts$NUTS.ID,]

NUTS2$numeric_id <- as.integer(substr(NUTS2$NUTS_ID, 3, 4))

NUTS2 <- cbind(NUTS2, ad_nuts[match(ad_nuts$NUTS.ID, NUTS2$NUTS_ID), -c(1:2)])



st_write(NUTS2[NUTS2$CNTR_CODE == 'ES', ], 'C:/Users/hofer/Documents/geocomputation_class/forestmap/in_data/admin/Forest_area_ES.geojson')
st_write(NUTS2[NUTS2$CNTR_CODE == 'PL', ], 'C:/Users/hofer/Documents/geocomputation_class/forestmap/in_data/admin/Forest_area_PL.geojson')
