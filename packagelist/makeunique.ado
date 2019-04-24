preserve
quietly clear
tempfile data
qui generate str10 downloaded = ""
qui generate str address = ""
qui generate str username = ""
qui generate str reponame = ""
qui generate str name = ""
qui generate str version = ""
qui generate str force = ""
qui save "`c(sysdir_plus)'g/github.dta", replace
restore
