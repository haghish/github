
program githubcheck, rclass

	syntax anything
	tempfile confirm
	
	
	tempfile api 
	tempname hitch 
	
	
	capture quietly copy "https://api.github.com/search/code?q=stata+in:path+filename:stata.toc+repo:`anything'" `api', replace
	if _rc != 0 {
		di as err "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..."
		exit
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
		di as txt "{bf:stata.toc} file was found"
	}
	else {
		return local toc 0
		di as txt "{bf:stata.toc} file was NOT found"
	}
	file close `hitch'
	
	
	
	sleep 3000
	capture quietly copy "https://api.github.com/search/code?q=stata+extension:pkg+repo:`anything'" `api', replace
	if _rc != 0 {
		di as err "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..."
		exit
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
		di as txt "{bf:pkg} file was found"
	}
	else {
		return local pkg 0
		di as txt "{bf:pkg} file was NOT found"
	}
	file close `hitch'
	
	
	if `toc' > 0 & `pkg' > 0 {
		return local installable 1
		di as txt "{bf:`anything'} is installable"
	}
	else {
		return local installable 0
		di as err "{bf:`anything'} is NOT installable"
	}
	
	
end


