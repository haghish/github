*cap prog drop githubquery
program githubquery, rclass
	
	syntax anything
	
	tempfile api tmp
	tempname hitch knot
	
	capture qui copy "https://api.github.com/repos/`anything'/releases" `api', replace
	if _rc {
		// Identify the errors with useful information
		if _rc == 679 display as err "GitHub API rate limit exceeded... try again after some time"

		error _rc
	} 
	
	
	file open `hitch' using "`api'", read
	qui file open `knot' using "`tmp'", write replace
	file read `hitch' line
	
	//remove the beginning brackets
	local line : subinstr local line "[{" ""
	local line : subinstr local line "`" "", all  
	
	di in text _n " {hline 40}" _n												                        ///
	"  {bf:Version}" _col(16) "{bf:Release Date}" _col(34) "{bf:Install} " _n 	  ///
	" {hline 40}"
	
	while r(eof) == 0 {
		tokenize `"`macval(line)'"' , parse(",")
		
		while !missing(`"`macval(1)'"') {
			
			if `"`macval(1)'"' == "," {
				macro shift
			}
			else if `"`macval(1)'"' == "html_url" {
				if strlen(`"`macval(2)'"') < strlen(`"https://github.com/`anything'/"') {
					macro shift
					macro shift
				}
				else {
					file write `knot' `"`macval(1)'"' _n
					macro shift
					local 1 : di substr(`"`macval(1)'"', 2,.)
					file write `knot' `"`macval(1)'"' _n
					macro shift
				}
			}
			else if `"`macval(1)'"' == "tag_name" {
				file write `knot' `"`macval(1)'"' _n
				macro shift
				local a strlen(`"`macval(1)'"')
				
				local 1 : di substr(`"`macval(1)'"', 3,`a'-3)
				file write `knot' `"`macval(1)'"' _n
				macro shift
			}
			
			else if `"`macval(1)'"' == "published_at" {
				file write `knot' `"`macval(1)'"' _n
				macro shift
				local 1 : di substr(`"`macval(1)'"', 3,10)
				file write `knot' `"`macval(1)'"' _n
				macro shift
			}
			else {
				macro shift
			}	
		}
		file read `hitch' line
	}
	
	file close `hitch'		
	file close `knot'
	
	file open `hitch' using "`tmp'", read
	file read `hitch' line
	local latestversion
	
	while r(eof) == 0 {
		if `"`macval(line)'"' == "html_url" {
			file read `hitch' line
			local link `"`macval(line)'"'
			file read `hitch' line
			
			if `"`macval(line)'"' == "tag_name" {
				file read `hitch' line
				local version `"`macval(line)'"'
				file read `hitch' line
			}
			if `"`macval(line)'"' == "published_at" {
				file read `hitch' line
				local date `"`macval(line)'"'
			}
			
			// get the latest version
			// -----------------------------------------------------------------------
			if missing("`latestversion'") local latestversion "`version'"
			
			if !missing(`"`link'"') & !missing("`version'") & !missing("`date'") {
				
				di `"  {browse `link':`version'}"' _skip(8)  "`date'" _skip(7) 	///
				"{stata github install `anything', version(`version') : Install}" 
				
				local link
				local version
				local date
			}
		}
		
		file read `hitch' line
	}
	
	di in text " {hline 40}" _n
	return local latestversion `latestversion' 
	
end

