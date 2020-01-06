/***
version: 1.3

githubfindall
=============

a program to search for Stata packages on GitHub, Stata Journal, 
SSC, and the web. ths program is executed by __github search__ command, with 
the __net__ option and is not called on its own.

Syntax
------

> __githubfindall__ _keyword_

Description
-----------

__githubfindall__ is a general command for searching for Stata packages on variety of 
web hosts, including GitHub, Stata, SSC, etc. The command wraps the Stata's 
{help search} command and adds the results of __github search__ command from the 
[github package](https://github.com/haghish/github). 

In addition, the command shows the date of the last update of Stata modules on 
SSC as well as GitHub, allowing the users to get the most recent version of the 
package.  

Example
-------

search for markdoc package on SSC and GitHub and show the last update

    . githubfindall markdoc

Author
------

__E. F. Haghish__     
Center for Medical Biometry and Medical Informatics     
University of Freiburg, Germany     
_and_        
Department of Mathematics and Computer Science       
University of Southern Denmark     
haghish@imbi.uni-freiburg.de        

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/




*cap prog drop githubfindall
program githubfindall
	*syntax [anything] [,  *]
	syntax [anything] [, language(str) in(str) net local all]
	
	// the search function prints nothing in results window in version 14
	version 8
	
	// avoid errors
	capture log close findallpkg
	
	// SYNTAX PRICESSING
	// -----------------
	if missing("`language'") local language Stata
	if missing("`in'") local in name
	
	// Create a log and save the search results
	// -----------------------------------------------------------------------
	
	tempfile log 
	qui log using "`log'", name(findallpkg)
	if missing("`local'") & !missing("`net'") search `anything', all
	if !missing("`local'") & missing("`net'") search `anything', local
	if !missing("`local'") & !missing("`net'") search `anything'
	
	*search `anything', local
	
	github search `anything', in("`in'") language("`language'") `all'
	qui log close findallpkg
	
	//doedit "`log'"
	
	// Edit the log, add useful information
	// -----------------------------------------------------------------------
	tempfile tmp pkg
	tempname hitch knot hitch2
	qui file open `hitch' using "`log'", read
	qui file open `knot' using "`tmp'", write replace
	file read `hitch' line
	while r(eof) == 0 {	
		
		// Edit the log, add useful information
		// -------------------------------------------------------------------
		if missing("`local'") {
		  if `"`macval(line)'"' == "{title:Search of official help files, FAQs, Examples, SJs, and STBs}" {
		    file read `hitch' line
		  }
		}
		
		//get the versions from SSC
		tokenize `"`macval(line)'"'
		if `"`macval(1)'"' == "@net:describe" {
			local len : di strlen(`"`macval(2)'"')
			local name = substr(`"`macval(2)'"', 1, `len'-1) 
			if substr(`"`macval(3)'"', 1, 31) == "from(http://fmwww.bc.edu/RePEc/" {
				cap local 3 = substr(`"`macval(3)'"', 6, .)
				cap tokenize `"`macval(3)'"', parse(")")
				
				cap qui copy "`1'/`name'.pkg" "`pkg'", replace
				cap qui file open `hitch2' using "`pkg'", read
				cap file read `hitch2' preline
				while r(eof) == 0 {
					if substr(`"`macval(preline)'"', 1, 20) == "d Distribution-Date:" {
						cap local date = substr(`"`macval(preline)'"', 21, .)
						cap local year = substr("`date'", 1,4)
						cap local month = substr("`date'", 5,2)
						cap local day = substr("`date'", 7,2)
						cap local updated "`year'-`month'-`day'"
						*if !missing("`updated'") {
							*file write `knot' "{smcl}" _n 						///
							*`"{it:(updated on `updated'})"' _n 				///
							*"{s6hlp}" _n
						*}
					}
					file read `hitch2' preline
				}
				
				file close `hitch2'
			}
			macro drop name
		}
		if `"`macval(line)'"' == "(end of search)" {
			local line "Web resources from GitHub"
			file write `knot' `"{smcl}"' _n
			file write `knot' `"{title:`macval(line)'}"' _n
			*file write `knot' "(contacting https://github.com)"
			file read `hitch' line
		}
		else {
			if missing("`updated'") {
				file write `knot' `"`macval(line)'"' _n
			}	
			else {
				*capture tokenize `"`macval(line)'"' , parse(")!")
				*di as err "`1'"
				local length = strlen("`name'")
				local col = 112+`length'
				file write `knot' `"`macval(line)'"' _col(`col') `"(updated on `updated')"' _n
				local updated 
			}
			file read `hitch' line
		}	
	}
	file close `knot'
	
	// View the results
	// -----------------------------------------------------------------------
	copy "`tmp'" `"`anything'"', replace
	view "`anything'", smcl 
	capture erase "`anything'" 
	
end


*markdoc githubfindall.ado , export(sthlp) replace build
