
/***
3 FINAL PREPARATION
================================================================================

Once you have created the **archive.dta** and the **gitget.dta**, you still 
need to do a few quality checks on them. This task is done in this section. 
In addition, the **githubfiles.dta** data set is also created in this section,  
after doing some quality checks.
***/

/***
3.1 Updated repositories' address
---------------------------------

check all of the Stata repositories to see if a repository has been 
updated to be an installable package
***/ 

// THIS CODE IS VERY SLOW TO EXECUTE
/*
quietly use "archive.dta", clear
local j 0
local last = _N
forval N = 1/`last' {
	display as txt "`N'/`last'" 
	local address : di address[`N']
	github check `address'
	if "`r(installable)'" == "1" {
		if installable[`N'] != 1 {
			replace installable = 1 in `N'
		}
	}
	else {
		if installable[`N'] != 1 {
			di as err address[`N']
			replace installable = 0 in `N'
		}
	}
	sleep 10000
}

saveold "archive.dta", replace
keep if installable == 1
duplicates drop address, force
saveold "gitget.dta", replace
*/

/***
3.2 Dependency
------------------------------------

We need to check whether the packages include dependencies. To do so, we search 
for _dependency.do_ file within each installable 
***/

use "gitget.dta", clear
capture drop dependency
generate dependency = .

local j 0
local last = _N
forval N = 1/`last' {
	if installable[`N'] == 1 {
		display as txt "`N'/`last'" 
		local j = `j'+1
		local address : di address[`N']
		capture githubdependency `address'
		if `r(dependency)' == 1 {
			replace dependency = 1 in `N'
		}
	}
}

saveold "gitget.dta", replace


/***
3.3 Creating packagelist.md file
--------------------------------
***/

use "gitget.dta", clear
gitgetlist, export("gitget.md")


// monitoring 
gsort - installable language
replace language="0" if language==""
tab installable language if installable == 1


/***
2.7 using RCALL in Stata to parse json files, generating UNIQUE.dta
-------------------------------------------------------------------
***/

rcall clear
rcall : library(jsonlite)
rcall : data = NULL

clear
tempfile githubfiles
qui generate str20 address = ""
qui generate str20 name = ""
qui generate str20 file = ""
qui save "githubfiles.dta", replace

use "gitget.dta", clear

local N : di _N

forval i = 1/`N' {
	di as txt "`i'"
	local address = address[`i']
	local URL "https://api.github.com/search/code?q=extension:pkg+repo:`address'"
	
	di as err "`URL'"
	
	capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
	
	if _rc != 0 {
		local loop = 1
		local loopNum = 1
	}
	else {
		local loop = 0
	}
	
	while `loop' != 0 {
		di as err "API error. wait a few seconds"
		sleep 30000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
		if _rc != 0 {
			local loop = 1
			local loopnum = `loopnum' + 1
			if `loopnum' > 5 {
				di "`address' seems to have a vital problem"
				local loop 0
			}
		}
		else {
			local loop = 0
		}
	}
	
	rcall : if (ncol(json) > 0) {json\$address = "`address'"} else {json = data.frame(name=NA, path=NA, address="`address'")};
	rcall : print(json); data = rbind(data, json);
	
	sleep 1000
}

rcall : data\$name = tools::file_path_sans_ext(basename(data\$name)); 

rcall : st.load(data)

// install sdecode package
sdecode address, gen(address2)
drop address
rename address2 address
rename name packagename
saveold "UNIQUE.dta", replace


// UPDATING GITGET.DTA
// =========================================================

use gitget.dta, clear
merge 1:m address using "UNIQUE.dta"
saveold "gitget.dta", replace



