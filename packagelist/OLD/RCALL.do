// using RCALL in Stata to parse json files
rcall clear
rcall : library(jsonlite)
rcall : data = NULL

cd "C:\Users\haghish.fardzadeh\Documents\GitHub\github"
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



