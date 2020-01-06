/***
_v. 1.2_ 

gitget
====== 

__gitget__ installs or updates a package from GitHub using the _packagename_ only. 
this is an exploratory alternative to __github__ command. 

Syntax
------ 

> __gitget__ _packagename_ [, stable version(_str_) ]

_options_

| _option_          |  _Description_                                                           |
|:------------------|:-------------------------------------------------------------------------|
| stable            | installs the latest stable release. otherwise the main branch is installed |
| **v**erson(_str_) | specifies a particular stable version (release tags) for the installation |


Description
-----------

__github__ is a wrapper for [github install](help github) command. it uses the 
__gitget.dta__ data set, which is installed with __github__ package to obtain 
the _username/reponame_ of the package. if multiple packages with identical name 
are found, the command describes them in a table without installing any module.  

by default, the command installs the development version of a repository. if you 
wish to install a stable release rather than the developmnt version, add the 
__stable__ option or specify the version within the __version__ option. 

Example
----------

installing markdoc package and its dependencies

    . gitget markdoc

installing the latest stable version of markdoc package and its dependencies

    . gitget markdoc, stable

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
	
	syntax anything [, stable version(str)]
	
	// find the gitget dataset
	// -----------------------------------------------------------------------
	capture findfile gitget.dta, path("`c(sysdir_plus)'g/")
	if _rc == 0 {
		preserve
		quietly use "`r(fn)'", clear
		quietly keep if packagename == "`anything'"
		if _N == 0 {
			display as err "`anything' package is unknown. try: {stata github search `anything'}"
		}
		else if _N == 1 {
			display as txt _n "{it:Installing `anything' ...}" 
			githuboutput
			di as txt _n
			local address = address[1]
			local pathaddress = path[1]
			local packagename = packagename[1]
			tokenize "`pathaddress'", parse("/")
			while "`2'" != "" {
				local path "`path'`1'"
				macro shift
			}
			noisily github install `address', `stable' version(`version') path(`path') package(`package')
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

