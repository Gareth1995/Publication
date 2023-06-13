library('CWAC')
library('tidyr')
library('dplyr')

# Data Loading and EDA

# get Barberspan counts from CWAC data
# List all sites at the North West province
nw_sites <- listCwacSites(.region_type = "province", .region = "North West")
nw_sites

# Find the code for Barberspan
site_id <- nw_sites[nw_sites$LocationName == "Barberspan", "LocationCode", drop = TRUE]
site_id

# We can find more info about this site with getCwacSiteInfo()
getCwacSiteInfo(site_id)

# get barberspan counts
bp_counts2 <- getCwacSiteCounts(site_id)
bp_counts2

# convert to wide format (cols, bird names, season, year)
wider_df = bp_counts2 %>% pivot_wider(names_from = SppRef, values_from = Count)
info_df = wider_df %>% select(c('Year', 'Season'))

bird_counts = wider_df %>% select('262':'1016')

# bind info onto bird_counts
bird_counts = cbind(info_df, bird_counts)

# count number of nas in each column
na_counts = colSums(is.na(bird_counts))

# get bird ids that contain more than 19 counts
valid_cols = names(na_counts[(nrow(bird_counts) - na_counts) > 19])
barberspan_counts = bird_counts[valid_cols]
save(barberspan_counts, file = "data/Barberspan_counts.RData")



