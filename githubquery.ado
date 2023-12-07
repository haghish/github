*cap prog drop githubquery
program githubquery, rclass
version 14

syntax anything

qui {
	
	preserve
	drop _all
	
	cap scalar page = fileread("https://api.github.com/repos/`anything'/releases")
	if _rc {
		// Identify the errors with useful information
		if _rc == 679 display as err "GitHub API rate limit exceeded... try again after some time"
		error _rc
	} 
	
	
	// load data and transform to dataframe
	mata {
		lines = st_strscalar("page")
		lines = ustrsplit(lines, ",")'
		lines = strtrim(lines)
		lines = stritrim(lines)
		
		lines =  subinstr(lines, `"":""', "->")
		lines =  subinstr(lines, `"""', "")
	}
	getmata lines, replace
	
	split lines, parse ("->")
	rename lines? (code url)
	
	// get date
	tempname ghpb 
	frame copy `c(frame)'  `ghpb'
	
	frame `ghpb' {
		keep if regexm(code, "published_at")
		gen n = _n
		rename url date
	}
	
	// merge date and tags frames
	keep if regexm(url, "releases/tag")
	gen n = _n
	gen tag  = regexs(2) if regexm(url, "(releases/tag/)(.*)")
	
	frlink 1:1 n, frame(`ghpb')
	frget date, from(`ghpb')
	
	
	// display
	
	noi di in text _n " {hline 40}" _n     ///
	"  {bf:Version}" _col(16) "{bf:Release Date}" _col(34) "{bf:Install} " _n ///
	" {hline 40}"
	
	local N = _N
	local bskip = 8 // basic skip
	local vlnth = 5 // version length
	
	forvalues i = 1/`N' {
		local link    = url[`i']
		local version = tag[`i']
		local date    = date[`i']
		if regexm("`date'", "([0-9]+\-[0-9]+\-[0-9]+)(.*)") {
			local date = regexs(1)
		}
		
		if (length("`version'") <= `vlnth') {
			local skip = 8
		}
		else {
			local skip = `vlnth'+`bskip' - length("`version'")
		}
		
		noi di `"  {browse "`link'":`version'}"' _skip(`skip')  "`date'" _skip(7) 	///
		"{stata github install `anything', version(`version') : Install}"
	}
	
	
	noi di in text " {hline 40}" _n
	
	local latestversion = tag[1]
	
} // end of qui

return local latestversion `latestversion' 

end

exit 

