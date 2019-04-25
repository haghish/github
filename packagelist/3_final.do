
/***
3 FINAL PREPARATION
================================================================================

Once you have created the **archive.dta** and the **gitget.dta**, you still 
need to do a few quality checks on them. This task is done in this section. 
In addition, the **gitget.dta** data set is also created in this section, after 
doing some quality checks.

3.1 Dependency
------------------------------------

We need to check whether the packages include dependencies
***/

use "update.dta", clear
txt "there are " _N " obserbations in the data set"

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


append using "gitget.dta"
duplicates drop address, force
saveold "gitget.dta", replace

use "archive.dta", clear
append using "gitget.dta"
duplicates drop address, force
saveold "archive.dta", replace

erase update.dta

qui log c



/***
2.3 Updated repositories' address
---------------------------------

check all of the Stata repositories to see a repository has been 
updated to be an installable package
***/ 

quietly use "gitget.dta", clear
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
}

saveold "gitget.dta", replace

/***
2.4 Updated dependency variable
-------------------------------
***/ 
quietly use "gitget.dta", clear
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
2.5 Creating packagelist.md file
--------------------------------
***/

use "gitget.dta", clear

quietly recode score (. = 0)
gsort -score -star
tempfile tmp1
tempname knot 
qui cap file open `knot' using "`tmp1'", write replace
local now : di %td_D-N-CY  date("$S_DATE", "DMY") " $S_TIME"
local now : di trim("`now'")
file write `knot' "_updated on " "``now'" "`" "_   " _n
file write `knot' "this is the complete list of *installable* Stata packages on GitHub, up to the date specified above. to install a Stata package included in this list, simply type:" _n(2)
file write `knot' "    gitget packagename" _n(2)
file write `knot' "- - -" _n(2)
file write `knot' "List of Stata Packages Recognized by `gitget` command" _n    ///
                  "=====================================================" _n(2)
file write `knot' "packages are listed based on their __Hits__ score" _n(2)
file write `knot'  "#|Package|Hits|Updated|Dependecy|Size|Description" _n       ///
		"--------:|:--------|:--------|:--------|:--------|:--------|:--------" _n

local last = _N 
forval i = 1/`last' {
	local name = name[`i']
	local address = address[`i']
	local hits = score[`i']
	local updated : di %td dofc(updated[`i']) 
	local dependency = dependency[`i']
	if "`dependency'" == "1" {
		local dependency "[dependency.do](https://github.com/`address'/blob/master/dependency.do)"
	}
	else {
		local dependency 
	}
	local kb = kb[`i']
	local description = description[`i']
	local description : subinstr local description "`" "'", all
	local description : di substr(`"`macval(description)'"', 1, 180)
	file write `knot' `"`i'|["' "__" `"`name'"' "__" `"](https://github.com/`address')|"'   ///
						 `"`hits'|`updated'|`dependency'|`kb'kb|`description'"' _n
}

file close `knot'
copy "`tmp1'" gitget.md , replace



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

// navigate to the working directory for the repository
cap cd "C:\Users\haghish.fardzadeh\Documents\GitHub\github"
cap cd "/Users/haghish/Documents/Packages/github"

clear
tempfile githubfiles
qui generate str20 address = ""
qui generate str20 name = ""
qui generate str20 file = ""
qui save "githubfiles.dta", replace

sysuse gitget, clear

local N : di _N

forval i = 1/`N' {
	di as txt "`i'"
	local address = address[`i']
	local URL "https://api.github.com/search/code?q=extension:pkg+repo:`address'"
	
	di as err "`URL'"
	
	capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
					
	if _rc != 0 {
		di as err "TRY AGAIN 3"
		sleep 30000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
	}
	
	if _rc != 0 {
		di as err "TRY AGAIN 5"
		sleep 50000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
	}
	
	if _rc != 0 {
		di as err "TRY AGAIN 10"
		sleep 100000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
	}
	
	if _rc != 0 {
		di as err "TRY AGAIN 60"
		sleep 60000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
	}
	
	if _rc != 0 {
		di as err "TRY AGAIN 90"
		sleep 90000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
					
	}
	
	if _rc != 0 {
		di as err "TRY AGAIN 120"
		sleep 120000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
					
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



