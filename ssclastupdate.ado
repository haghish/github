
*cap prog drop ssclastupdate
prog ssclastupdate
	syntax [anything],  [save(str) row(numlist) download remove]
	ssc describe "`anything'", saving(`anything', replace)
	qui cap translate "`anything'.smcl" "`anything'.log", replace translator(smcl2log)
	qui cap erase "`anything'.smcl"
	
	tempfile tmp
	tempname hitch
	qui file open `hitch' using "`anything'.log", read
	file read `hitch' line
	
	while r(eof) == 0 {
		
		local line: subinstr local line "`" "", all

		capture if substr(`"`macval(line)'"',1,5) == "TITLE" {
			file read `hitch' line
			local line1 = trim(`"`macval(line)'"')
			file read `hitch' line
			while substr(`"`macval(line)'"',1,2) == "> " & r(eof) == 0 {
				local line : subinstr local line "> " ""
				local line1 = "`line1" + trim("`line'")
				file read `hitch' line
			}
			if !missing("`save'") qui replace description = "`line1'" in `row'
		}
		
		cap if substr(trim(`"`macval(line)'"'),1,18) == "Distribution-Date:" {

			
			capture tokenize `"`line'"', parse(":")
			macro shift
			macro shift
			if !missing("`save'") qui replace update = `1' in `row'
			local ssclastupdate `1'
			
			
			
			if !missing("`save'") {
				preserve
				cap qui use `save', clear
				cap qui keep if package == "`anything'"
				if update == `ssclastupdate' local unupdated 1
				
				restore
							
				if !missing("`unupdated'") {
					if !missing("`save'") qui replace drop = 1 in `row'
					local unupdated
				}
				
				else {
					
					local nv = versions in `row'
					local nv = `nv' + 1
					if !missing("`save'") qui replace versions = `nv' in `row'
					
					//If the directory doesn't exist, create it
					confirmdir "`anything'/`anything'_`1'"
					if r(confirmdir) == "170" {
						if !missing("`download'") mkdir "`anything'/`anything'_`1'", public
					}
					local DIR "`anything'/`anything'_`1'"
					local NAME "`anything'_`1'"
				}
			}
			else {
				if !missing("`download'") mkdir "`anything'_`1'", public
				//otherwise just download the zip file
				local DIR "`anything'_`1'"
				local NAME "`anything'_`1'"
			}
				
		}
		
		
		
		// Download the files
		if missing("`unupdated'") & !missing("`DIR'") &					///									///
		substr(`"`macval(line)'"',1,18) == "INSTALLATION FILES" {
		
			file read `hitch' line
			
			local adoNumber 0						 //reset
			while substr(`"`macval(line)'"',1,9) != "ANCILLARY" &		///
			r(eof) == 0 & `"`macval(line)'"' != "" &				///						///
			substr(`"`macval(line)'"',1,9) != "---------" {
			
				tokenize "`line'", parse("/")
				while !missing("`1'") {
					local weirdo "`1'"
					macro shift
				}
				
				if !missing("`save'") {
					if substr("`weirdo'",-4,.) == ".ado"  local adoNumber `++adoNumber'
					if substr("`weirdo'",-4,.) == ".dlg"  qui replace dlg = 1 in `row'
					if substr("`weirdo'",-5,.) == ".mlib" qui replace mata = 1 in `row'
					if substr("`weirdo'",-5,.) == ".mata" qui replace mata = 1 in `row'
					if substr("`weirdo'",-3,.) == ".mo"   qui replace mata = 1 in `row'
					if substr("`weirdo'",-2,.) == ".R"     qui replace plugin = 1 in `row'
					if substr("`weirdo'",-6,.) == ".class" qui replace plugin = 1 in `row'
					if substr("`weirdo'",-7,.) == ".plugin" qui replace plugin = 1 in `row'
					if substr("`weirdo'",-6,.) == ".style" qui replace scheme = 1 in `row'
				}
				
				
				if missing("`fileslist'") local fileslist "`weirdo'"
				else local fileslist "`fileslist';`weirdo'"
				
				if !missing("`download'") {
					
					di as txt "`weirdo'"
					cap qui ssc copy "`weirdo'", replace
					
					cap qui capture copy "`weirdo'" "`DIR'/`weirdo'", replace 
					cap qui capture erase "`weirdo'"
				}
				

				file read `hitch' line
			}
			
			if !missing("`save'")  qui replace ado = `adoNumber' in `row' 
			
			if !missing("`download'") {
				
				//Erase the directory
				qui zipfile "`DIR'", saving("`DIR'", replace) 
				
				//Erase DIR
				dirlist "`DIR'"
				foreach lname in `r(fnames)' {
					if !missing("`remove'") cap erase "`DIR'/`lname'"
				}
				if !missing("`remove'") cap rmdir "`DIR'"
			}
			
		}
		
		if !missing("`save'") qui replace files = "`fileslist'" in `row'
		
		
		file read `hitch' line
	}
	qui file close `hitch'
	qui cap erase "`anything'.log"
	
end


