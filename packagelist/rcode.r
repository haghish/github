# let's measure the run time
tictoc::tic()

# change the working directory to the packagelist directory
setwd("C:/Users/haghish.fardzadeh/Documents/GitHub/github/packagelist")

library(haven)

# source the program
source("githubunique.r")

# use the haven R package to load Stata data
archive = read_dta("archive.dta")
archive = unique(archive[,c("address")] )

# parse the json data obtained from the API
data = githubunique(archive, search="pkg")
data$name = tools::file_path_sans_ext(basename(data$name))

# write the results in a Stata file
write_dta(data, "unique.dta")

# subset the data to search for stata.toc files in repositories
# -------------------------------------------------------------
data = read_dta("unique.dta")
data = data[data$path != "", ]
data = data[!duplicated(data$address),]
toc = githubunique(data, search="toc")

toc$toc = 0
toc$toc[toc$name == "stata.toc"] = 1
toc$name = NULL
colnames(toc) = c("tocpath","address","toc")
write_dta(toc, "toc.dta")

tictoc::toc()