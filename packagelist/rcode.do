// clean rcall workspace
rcall clear
rcall : library(jsonlite)
rcall : data = NULL

use "archive.dta", clear
local N : di _N

forval i = 1/`N' {
	local address = address[`i']
	local URL "https://api.github.com/search/code?q=extension:pkg+repo:`address'"
	di as err "`i'.    `URL'"
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
		sleep 10000
		capture rcall : json = fromJSON("`URL'"); ///
	        json = as.data.frame(json[['items']][c("name","path")]); 
		if _rc != 0 {
			local loop = 1
			local loopnum = `loopnum' + 1
			if `loopnum' > 20 {
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
