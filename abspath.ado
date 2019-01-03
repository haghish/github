/*** DO NOT EDIT THIS LINE -----------------------------------------------------

Version: 1.0.0

Intro Description
=================

abspath | abspath(str) -- Stata program and Mata function that returns the 
absolute path of any given {help filename}.  


Author(s) section
=================

E. F. Haghish
Center for Medical Biometry and Medical Informatics
University of Freiburg, Germany
_haghish@imbi.uni-freiburg.de_
_ {browse "http://www.haghish.com/stat"} _

Syntax
=================

{opt abspath} {it:{help filename:filename}}
----------------------------------------------------- DO NOT EDIT THIS LINE ***/

/***
Mata Syntax
===========

{p 8 16 2}
{opt abspath}{bf:(}{it:"{help filename:filename}"}{bf:)}
***/


program abspath, rclass
	
	
	
	// get the current path and save it
	// --------------------------------------------------------------------
	local wd : pwd
	
	// make sure no problem happenes if the file has double quotation sign
	capture local fname : display `0'
	if _rc == 0 {
		local 0 `fname'
	}
	
	confirm file "`0'"
	
	// get the path defined in the input and navigate to it
	// --------------------------------------------------------------------
	if "`c(os)'" == "Windows" {
		local 0 : subinstr local 0 "/" "\", all
		tokenize "`0'", parse("\")					 
	}
	else tokenize "`0'", parse("/")
	
	while !missing("`1'") {
		if !missing("`3'") local p = "`p'" + "`1'"	//avoid the last 2 
		//if missing("`3'") local n = "`n'" + "`1'"	//get the last 2 
		if missing("`2'") local filename = "`filename'" + "`1'"	
		macro shift
	} 

	if !missing("`p'") quietly cd "`p'"				//make sure it's not missing
	
	// get the current path
	// --------------------------------------------------------------------
	local path : pwd
	local pathstr `path'
	
	if "`c(os)'" == "Windows" {
		local filename : subinstr local filename "/" "\", all	
		local path : subinstr local path "/" "\", all	
		local pathstr = "`path'" + "\"
		local abspath = "`path'" + "\" + "`filename'"
	}
	else {
		local abspath = "`path'" + "/" + "`filename'"
		local pathstr = "`path'" + "/"
	}
	
	
	
	// go the the original path and return output
	// --------------------------------------------------------------------
	quietly cd "`wd'"
	
	display "`abspath'"
	return local pathstr `pathstr'
	return local path `path'
	return local abspath `abspath'
	return local fname `filename'
end



/***
Example
=================

    Return absolute path of a file with relative path in Stata
	
        . abspath ../../myfile.smcl
        . abspath "./my file.smcl"

    Return absolute path of a file with relative path in Mata
	
        . mata: abspath("../../myfile.smcl")
        . mata: abspath("./my file.smcl")
***/

