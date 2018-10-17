	
*cap prog drop make
prog make
	
	syntax [anything] [,      ///
	        ancillary(str)    ///
	        install(str)      ///
	        Version(str)      /// 
					Description(str)  ///
					AUThor(str)       ///
				 ]
	
	//title of the package
	local title `anything'
	local capital : di ustrupper("`title'") 
	
	//make the temporary files
	tempfile toctmp pkgtmp 
	tempname hitch knot toc pkg
	
	// Creating the TOC file
	// -------------------------------------------------------
	qui file open `toc' using "`toctmp'", write replace
	if !missing("`version'") {
		file write `toc' "v `version'" _n 
	}
	if !missing("`author'") {
		file write `toc' "d Materials by `author'" _n(2) 
	}
	file write `toc' "d '`capital''" _n(2) 
	
	if !missing("`description'") {
		file write `toc' "d '`capital'': `description'" _n(2) 
	}
	file write `toc' "p `title'" _n
	
	
	// Creating the PKG file
	// -------------------------------------------------------
	qui file open `pkg' using `"`pkgtmp'"', write replace
	if !missing("`version'") {
		file write `pkg' "v `version'" _n 
	}
	if !missing("`description'") {
		file write `pkg' "d '`capital'': `description'" _n(2) 
	}
	else file write `pkg' "d '`capital'': no description is available!" _n
	
	//date
	local today : di %td_CYND  date("$S_DATE", "DMY")
	file write `pkg' "d " _n 
	file write `pkg' "d Distribution-Date: `today'" _n 
	file write `pkg' "d " _n
	
	//if install and ancillary are empty, list all files 
	if missing("`install'") & missing("`ancillary'") {
		local install : dir . files "*" 
		tokenize `"`install'"'
		while `"`macval(1)'"' != "" {
			if `"`macval(1)'"' != ".DS_Store"  								    ///
			& substr(`"`macval(1)'"', -4,.) != ".pkg" 						///
			& substr(`"`macval(1)'"', -4,.) != ".toc" 						///
			& `"`macval(1)'"' != "README.md"                      ///
			& `"`macval(1)'"' != "readme.md"		                  ///
			& `"`macval(1)'"' != "index.md"		                    ///
			& `"`macval(1)'"' != "index.html"  									  ///
			& `"`macval(1)'"' != "license.md"		                  ///
			& `"`macval(1)'"' != "dependency.do"								  ///
			& `"`macval(1)'"' != "params.json"  								  ///
			& `"`macval(1)'"' != ".gitignore"									    ///
			{
				file write `pkg' `"F `1'"' _n
				di "`1'"
			}
			macro shift
		}
	}
	if !missing("`install'") {
		// get the file names install option
		tokenize `"`install'"', parse(";")	
		while !missing("`1'") {
				if "`1'" != ";" {
				file write `pkg' `"F `1'"' _n
				di "`1'"
			}
			macro shift
		}
	}
	if !missing("`ancillary'") {
		// get the file names ancillary option
		tokenize `"`ancillary'"', parse(";")	
		while !missing("`1'") {
				if "`1'" != ";" {
				file write `pkg' `"f `1'"' _n
				di "`1'"
			}
			macro shift
		}
	}
	
	//close and copy the files
	file close `toc'
	file close `pkg'
	quietly copy "`toctmp'" "stata.toc", replace
	quietly copy "`pkgtmp'" "`title'.pkg", replace

end



// make "test" 
//, install("githubdependency.ado;githublist.ado;githubmake.ado")
