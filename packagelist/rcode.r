# let's measure the run time
tictoc::tic()

# change the working directory to the packagelist directory
setwd("C:/Users/haghish.fardzadeh/Documents/GitHub/github/packagelist")

library(haven)

# source the program
source("githubunique.r")

# use the haven R package to load Stata data
gitget = read_dta("archive.dta")

# parse the json data obtained from the API
data = githubunique(gitget)
data$name = tools::file_path_sans_ext(basename(data$name))

# write the results in a Stata file
write_dta(data, "UNIQUE.dta")

tictoc::toc()