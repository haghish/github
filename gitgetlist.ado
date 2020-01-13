
*capture prog drop gitgetlist
program gitgetlist
	syntax [anything] [, export(str)]
	
	if missing("`export'") local export "gitget.md"
	
	quietly recode score (. = 0)
	gsort -score -star
	tempfile tmp1
	tempname knot 
	qui cap file open `knot' using "`tmp1'", write replace
	local now : di %td_D-N-CY  date("$S_DATE", "DMY") " $S_TIME"
	local now : di trim("`now'")
	file write `knot' "_updated on " "``now'" "`" "_   " _n
	file write `knot' "this is the complete list of *installable* Stata packages on GitHub, up to the date specified above. to install a Stata package included in this list, simply type:" _n(2)
	file write `knot' "    gitget packagename" _n(2)
	file write `knot' "- - -" _n(2)
	file write `knot' "List of Stata Packages Recognized by `gitget` command" _n    ///
										"=====================================================" _n(2)
	file write `knot' "packages are listed based on their __Hits__ score" _n(2)
	file write `knot'  "#|Package|Hits|Updated|Dependecy|Size|Description" _n       ///
			"--------:|:--------|:--------|:--------|:--------|:--------|:--------" _n

	local last = _N 
	forval i = 1/`last' {
		local name = path[`i']
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
		file write `knot' `"`i'|["' "__" `"`name'"' "__" `"](https://github.com/`address')|"'   ///
							 `"`hits'|`updated'|`dependency'|`kb'kb|`description'"' _n
	}

	file close `knot'
	qui copy "`tmp1'" "`export'" , replace
end
