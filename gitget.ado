/***
_v. 1.0.3_ 

Title
====== 

gitget -- install/update a package from GitHub using the _packagename_ only 

Syntax
------ 

> __gitget__ _packagename_ 

Description
-----------

__github__ is a wrapper for [github install](help github) command. it uses the 
__gitget.dta__ data set, which is installed with __github__ package to obtain 
the _username/reponame_ of the package. if multiple packages with identical name 
are found, the command describes them in a table without installing any module.  

Example
----------

    installing markdoc package and its dependencies
        . gitget markdoc

Author
------

E. F. Haghish   
University of Göttingen    
haghish@med.uni-goettingen.de    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

*cap prog drop gitget
program gitget
	
	version 13
	
	syntax anything
	
	// find the gitget dataset
	// -----------------------------------------------------------------------
	capture findfile gitget.dta, path("`c(sysdir_plus)'g/")
	if _rc == 0 {
		preserve
		quietly use "`r(fn)'", clear
		quietly keep if name == "`anything'"
		if _N == 0 {
			display as err "`anything' package is unknown. try: {stata github search `anything', in(all)}"
		}
		else if _N == 1 {
			display as txt _n "{it:Installing `anything' ...}" 
			githuboutput
			di as txt _n
			local address = address[1]
			noisily github install `address'
		}
		else if _N > 1 {
			display as txt "multiple Stata packages were found! "  
			quietly gsort -score
			githuboutput
		}
		restore
	}
	else {
		display as err "the {bf:gitget.dta} data set was not found!"
	}

end 
