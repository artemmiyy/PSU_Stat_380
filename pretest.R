library(dplyr)
library(data.table)

trips <- fread("./Trips.csv")
stations <- fread("./DC_Stations.csv")

from_to <- trips[,c(3,5)] #sstation and estation

from_to <- trips[, c(3, 4, 5, 7)]
from_to <- subset(from_to, client == "Registered")

wisc <-
  trips$sstation %>%
  select(matches("Wisconsin"))