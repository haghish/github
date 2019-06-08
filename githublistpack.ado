/***
_v. 1.0.0_

githublistpack
==============

mines the GitHub API for Stata repositories

Syntax
------

> __githublistpack__ [ _keyword_ ] [, _options_ ]

### Options

| _option_      |  _Description_                                                           |
|:--------------|:-------------------------------------------------------------------------|
| language(_str_)   | specifies the programming language of the repository. the default is __Stata__ |
| in(_str_) | specifies the domain of the search which can be __name__, __description__, __readme__, or __all__ |
| all | shows repositories that lack the __pkg__ and __stata.toc__ files in the search results |
| duration(_num_) | search time frame in number of days. the default is __1__ |
| delay | number of miliseconds to let the API rest after each search. the default is 10000 ms |
| save | saves the search results in a data set |
| replace | replaces existing data set |
| append | appends results to an existing data set |
| created(_str_) | initial date for beginning of the search |
| pushed(_str_) | initial pushing date of the repository, which is useful for updating the archive |
| reference(_str_) | initial date. if missing, it is set to __"2012.01.01"__ |
| perpage(_num_) | maximum number of returned results (check GitHub API limits)  |
| quite | avoids output log |
| debug | detailed output log |

Description
-----------

__githublistpack__ searches for repositories on GitHub within 
a limited time frame (i.e. _duration_). It can save and update
the results in a data set. It also provides options for 
narrowing down or expanding the search. 



Examples
--------

### examples of mining Stata packages on packages 

list all GitHub repositories in Stata language 

        . githublistpack , language(Stata) append replace   ///
          save("repolist") duration(1) all in(all)          ///
					perpage(100)

search for repositories created from 2019 on  

        . githublistpack , language(Stata) append replace   ///
          save("update") duration(1) all in(all)            ///
          reference("2019-01-01") perpage(100)

Author
------

E. F. Haghish   
Department of Mathematics and Computer Science (IMADA)    
University of Southern Denmark    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

*capture prog drop githublistpack
prog githublistpack
	
	syntax [anything] [, language(str) in(str) all save(str) created(str) 		///
	pushed(str) reference(str) stopdate(str) duration(numlist max=1)          ///
	perpage(numlist max=1) delay(numlist max=1) replace append quiet debug] 
	
	if missing("`stopdate'") {
		local stopdate: display date(c(current_date), "DMY")
	}
	
	// Packages before 2012
	// ======================================================================
	if missing("`reference'") {
		local reference "2012-01-01"
		if missing("`quiet'") display "<2012-01-01"
		githubsearch `anything', created("<2012-01-01") language(`language') 	      ///
		in(`in') `all' save("`save'") append quiet scoreless `quiet' `debug'        ///
		perpage(`perpage')
	}
	
	
	// Packages after the reference (default is 2012-01-01)
	// ======================================================================
	githubsearchsteps `anything', reference("`reference'") duration(`duration')   ///
	language(`language') in(`in') `all' save("`save'") append `quiet' `debug'     ///
	delay(`delay')
	
	preserve
	
	// Generate score
	// ======================================================================
	if !missing(`"`save'"') {
		use "`save'", clear 
		qui label data "updated on `c(current_date)'"
		qui save `"`save'"', replace
	}	
		
	// -----------------------------------------------------------------------
	// Drawing the output table
	// =======================================================================
	if missing("`quiet'") {
		githuboutput `anything', in("`in'") `all' quiet
	}
	
	restore

end 

