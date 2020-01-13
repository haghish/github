use "https://github.com/haghish/github/blob/master/packagelist/archive.dta?raw=true", clear
gen year = year(dofc(created))
keep if year >= 2013 & year < 2020
keep if language == "Stata" | installable == 1
local reponame "Number of newly created repositories"
local packname "Stata packages on Github by date of creation"
local reponame "Stata Repositories"
graph bar (count) installable, over(year) b1title("Creation date") ///
ytitle("Public repositories") ytitle(, margin(bargraph)) scheme(sj)       ///
title("`reponame'") name(repo, replace)    
graph export "repositories.png", replace      

use "https://github.com/haghish/github/blob/master/packagelist/gitget.dta?raw=true", clear 
gen year = year(dofc(created))
keep if year >= 2013 & year < 2020
local packname "Stata packages"
graph bar (count) installable if installable == 1, over(year) ///
ytitle("Public packages (installable repositories)") ytitle(, margin(bargraph))           ///
b1title("Creation date") scheme(sj)    ///
title("`packname'") name(package, replace)
graph export "packages.png", replace  


graph combine repo package, ysize(4) xsize(6.75) scheme(sj) ///
title("Stata repositories and packages on GitHub") 
graph export "combined.png", replace 
