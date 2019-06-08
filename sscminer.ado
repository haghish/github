/***
_v. 1.0.0_

sscminer
========

mines and archives SSC packages based on their updates

Syntax
------

> __sscminer__ , _save(str)_ [ _download_ ]

### options

| _option_    |  _Description_                                                           |
|:------------|:-------------------------------------------------------------------------|
| save(_str_) | specifies the name of the data set to include packages information       |
| download    | downloads and archives SSC packages in zip files                         |

Description
-----------

__sscminer__ mines packages on SSC server and summarizes them in a data set. 
it also list the files that are installable within each packages and categorizes 
them based on the Stata programming language they are using (ado, mata, dlg, etc.)

originally, the archive was developed for education purpose. 

Examples
--------

mine Stata packages on SSC without downloading any package

        . sscminer, save("archive.dta")

mine stata packages and download the files

        . sscminer, save("archive.dta") download

Author
------

E. F. Haghish   
Department of Mathematics and Computer Science (IMADA)    
University of Southern Denmark    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


/*
PLEASE NOTE
--------------------------------------

- some of the options of the program are not documented because they are 
  intended to be used internally
*/

*cap prog drop sscminer
prog sscminer

	syntax [anything], save(str) [download remove]
	
	qui log using ssclist, replace text
	ssc hot, n(5000)	//set n to a higher number than number of packages
	qui log c
	
	// -------------------------------------------------------
	// PART 1- Analyze the SSC Package List log
	// =======================================================
	tempfile tmp
	tempname hitch
	qui file open `hitch' using "ssclist.log", read
	file read `hitch' line
	
	local lineNumber 1
	while `lineNumber' < 8 & r(eof) == 0 {
		file read `hitch' line
		local lineNumber `++lineNumber'
	}
	file read `hitch' line
	
	local lineNumber 1								//reset the line number
	clear
	qui set obs 10000
	qui generate int rank = .
	qui generate hits = .
	qui generate str package = ""
	qui generate str author = ""
	qui generate str description = ""
	qui format %-75s description
	qui generate double update = .
	qui format %9.0f update
	qui generate int drop = .
	qui generate int versions = 0						//if there is a new update
	qui generate int mata = .
	qui generate int dlg = .
	qui generate int plugin = .
	qui generate int scheme = .
	qui generate int ado = .
	qui generate str files = ""
	qui format %-75s files
	
	capture qui save `save', replace

	local var1 rank
	local var2 hits
	local var3 package
	local var4 author

	while r(eof) == 0 & substr(`"`macval(line)'"',1,6) != "  ----" { 
		local varNumber  1
		local test									//check if it's numeric
		tokenize `"`macval(line)'"'
		while `"`1'"' ~= "" {
			capture local test : display int(`1')
			
			//check if the first word is not a number, notify multiple lines
			if "`varNumber'" == "1" & missing("`test'") {
				if missing("`multipleLine'") {
					local multipleLine = `lineNumber' -1
				}
				while `"`1'"' ~= "" {
					local preAuthor = author in `multipleLine'
					qui replace author = " `preAuthor' " + "`1'" in `multipleLine'
					local preAuthor	
					macro shift
				}				
			}
					
			/*
			if !missing("`multipleLine'") {
				local preAuthor = author in `multipleLine'
				replace author = " `preAuthor' " + "`1'" in `multipleLine'
				local preAuthor	
			}
			*/			
					
			if !missing("`test'") & missing("`multipleLine'") {
				if `varNumber' < 3 qui replace `var`varNumber'' = `1' in `lineNumber'

				// ----------------------------------
				// Work with the package name
				// ==================================
				if `varNumber' == 3 {
					qui replace package = "`1'" in `lineNumber'
					
					//If the directory doesn't exist, create it
					confirmdir "`1'"
					if r(confirmdir) == "170" {
						if !missing("`download'") mkdir "`1'", public
					}
					
					// -----------------------------------------------
					// PART 2- download and archive the packages
					// ===============================================
					macro drop ssclastupdate
					ssclastupdate `1', save(`save') row(`lineNumber') `download' `remove'	//add the update variable	
				}
				
				if `varNumber' > 3 {
					local preAuthor = author in `lineNumber'
					qui replace author = " `preAuthor' "+"`1'" in `lineNumber'
					local preAuthor					//reset
				}	
			}
			
			macro shift
			local varNumber `++varNumber'
			local multipleLine					//reset
		}
		
		file read `hitch' line 
		if missing("`multipleLine'") {
			local lineNumber `++lineNumber'
			*set obs `lineNumber'				//add a missing entry in the data
		}
	
		//PUT IT IN THE END		
		qui save `save', replace
	}
	
	file close `hitch'
	cap qui drop if rank == .
	
	gen adototal = (length(files) - length(subinstr(files, ".ado", "", .)))/4
    gen matatotal = (length(files) - length(subinstr(files, ".mata", "", .)))/5
	qui save `save', replace
	
	*capture qui rm "ssclist.log"

end


