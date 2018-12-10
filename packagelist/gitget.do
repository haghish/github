/***
Generating `gitget.dta` data set
============================================================

The `gitget` data set is used as a short-cut for installing Stata packages 
from the complete list of Stata repositories, stored in `packagelist.dta` data set.
In this document, I will create a subset of the installable repositories to be 
used by the `gitget` command
***/

use "packagelist.dta", clear
keep if installable == 1

saveold "gitget.dta", replace




// .........................................................


/***
Creating packagelist.md file
============================
***/

use "gitget.dta", clear
quietly recode score (0 = .)
gsort -score -star
tempfile tmp1
tempname knot 

qui cap file open `knot' using "`tmp1'", write replace
file write `knot'  "#|Package|Hits|Updated|Dependecy|Size|Description" _n       ///
		"--------:|:--------|:--------|:--------|:--------|:--------|:--------" _n

local last = _N 
forval i = 1/`last' {
	local name = name[`i']
	local address = address[`i']
	local hits = score[`i']
	local updated : di %td dofc(updated[`i']) 
	local dependency = dependency[`i']
	if "`dependency'" == "1" {
		local dependency "[dependency.do](https://github.com/`address'/blob/master/dependency.do)"
	}
	else {
		local dependency 
	}
	local kb = kb[`i']
	local description = description[`i']
	local description : subinstr local description "`" "'", all
	local description : di substr(`"`macval(description)'"', 1, 180)
	file write `knot' `"`i'|[`name'](https://github.com/`address')|"'   ///
						`"`hits'|`updated'|`dependency'|`kb'kb|`description'"' _n
}

file close `knot'
copy "`tmp1'" gitget.md , replace
