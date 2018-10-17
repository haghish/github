

*cap prog drop githubmake
program githubmake

	syntax anything [, replace]
	
	// check that pkg and toc files do not already exist
	/*
	capture confirm file `"`anything'.pkg"'
	if _rc == 0 {
		
	}
	*/
	
	*tokenize `anything', parse("/")
	*local username `1'
	*local title `3'
	
	local title `anything'
	local capital : di ustrupper("`title'") 

	
	tempfile toctmp pkgtmp 
	tempname hitch knot toc pkg
	
	// Creating the TOC file
	// -------------------------------------------------------
	qui file open `toc' using "`toctmp'", write replace
	file write `toc' "d '`capital''" _n 
	file write `toc' "p `title'" _n
	
	// Creating the PKG file
	// -------------------------------------------------------
	qui file open `pkg' using `"`pkgtmp'"', write replace
	file write `pkg' "d '`capital''" _n "d " _n 
	local list : dir . files "*" 
	tokenize `"`list'"'
	while `"`macval(1)'"' != "" {
		if `"`macval(1)'"' != ".DS_Store" & 								///
		substr(`"`macval(1)'"', -4,.) != ".pkg" &							///
		substr(`"`macval(1)'"', -4,.) != ".toc" &							///
		`"`macval(1)'"' != "README.md" & `"`macval(1)'"' != "readme.md"		///
		& `"`macval(1)'"' != "dependency.do"								///
		& `"`macval(1)'"' != "params.json"  								///
		& `"`macval(1)'"' != "index.html"  									///
		& `"`macval(1)'"' != ".gitignore"									///
		{
			file write `pkg' `"F `1'"' _n
		}
		macro shift
	}
	
	file close `toc'
	file close `pkg'
	quietly copy "`toctmp'" "stata.toc", replace
	quietly copy "`pkgtmp'" "`title'.pkg", replace


end

