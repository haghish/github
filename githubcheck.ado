
program githubcheck, rclass

	syntax anything [, gettoc getpkg]
	
	if missing("`gettoc'") & missing("`getpkg'") {
		local gettoc gettoc
		local getpkg getpkg
	}
	
	tempfile confirm
	
	tempfile api 
	tempname hitch 
	
	if !missing("`gettoc'") {
		capture quietly copy "https://api.github.com/search/code?q=in:path+filename:stata.toc+repo:`anything'" `api', replace
		while _rc != 0 {
		di as txt "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..." _n
		sleep 5000
		
		capture quietly copy "https://api.github.com/search/code?q=in:path+filename:stata.toc+repo:`anything'" `api', replace
	}
		
		
		file open `hitch' using "`api'", read
		file read `hitch' line
		
		// check the number of results
		// --------------------------------
		tokenize `"`macval(line)'"' , parse(",")
		local 1 : display substr(`"`macval(1)'"',16,.)
		local toc `1' 
		
		if `1' > 0 {
			return local toc 1
			di as txt "{bf:toc} file was found"
		}
		else {
			return local toc 0
			di as error "{bf:toc} file was NOT found"
		}
		file close `hitch'
	}
	
	sleep 10000
	
	capture quietly copy "https://api.github.com/search/code?q=extension:pkg+repo:`anything'" `api', replace
	while _rc != 0 {
		di as txt "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..." _n
		sleep 5000
		
		capture quietly copy "https://api.github.com/search/code?q=extension:pkg+repo:`anything'" `api', replace
	}
	file open `hitch' using "`api'", read
	file read `hitch' line
	
	// check the number of results
	// --------------------------------
	tokenize `"`macval(line)'"' , parse(",")
	local 1 : display substr(`"`macval(1)'"',16,.)
	local pkg `1' 
	if `1' > 0 {
		return local pkg 1
		di as txt "`pkg' {bf:pkg} file was found"
	}
	else {
		return local pkg 0
		di as error "{bf:pkg} file was NOT found"
	}
	
	file close `hitch'
	
	// return the results
	if !missing("`gettoc'") & !missing("`getpkg'") {
		if `toc' > 0 & `pkg' > 0 {
			return local installable 1
			di as txt "(the repository is installable)"
		}
		else {
			return local installable 0
			di as err "(the repository is NOT installable)"
		}
	}
	
	
end

