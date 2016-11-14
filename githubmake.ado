//UNDER DEVELOPMENT

cap prog drop githubmake
program githubmake

	syntax anything [, replace]
	
	// check that pkg and toc files do not already exist
	/*
	capture confirm file `"`anything'.pkg"'
	if _rc == 0 {
		
	}
	*/
	
	tokenize `anything', parse("/")
	local username `1'
	local repo `3'
	local capital : di ustrupper("`repo'") 

	tempfile api
	tempname toc pkg
	tempname hitch knot
	qui file open `knot' using "`toc'", write replace
	
	// get the description
	// -------------------
	capture quietly copy "https://api.github.com/search/code?q=`repo'+in:name,description,readme+repo:`anything'" `api', replace
	if _rc != 0 {
		di as err "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..."
		exit
	}
	
	file open `hitch' using "`api'", read
	file read `hitch' line
	local line : subinstr local line "[" "", all
	local line : subinstr local line "]" "", all
	local line : subinstr local line "{" "", all
	local line : subinstr local line "}" "", all
	while r(eof) == 0 {
		
		tokenize `"`macval(line)'"' , parse(",")
		while !missing(`"`macval(1)'"') | !missing(`"`macval(2)'"') | !missing(`"`macval(3)'"')  {
			if `"`macval(1)'"' == `","' {
				macro shift
			}
			else if `"`macval(1)'"' == "description"  { 
				local l : di length(`"`macval(2)'"')
				if `"`macval(2)'"' != ":null" & `l' > 3 {							
					local 2 : di substr(`"`macval(2)'"', 2,.)
					local l : di length(`"`macval(2)'"')
					local 2 : di substr(`"`macval(2)'"', 2,`l'-2)				
				}	
				else {
					local 2 "the package had no description"
				}
				macro shift
			}
			else if `"`macval(1)'"' == "path"  { 
				local l : di substr(`"`macval(2)'"',3,1)
				if `"`l'"' == "/" & `"`l'"' != "/.gitignore" {
					di `"`macval(2)'"'
				}
				/*
				if `"`macval(2)'"' != ":null" & `l' > 3 {							
					local 2 : di substr(`"`macval(2)'"', 2,.)
					local l : di length(`"`macval(2)'"')
					local 2 : di substr(`"`macval(2)'"', 2,`l'-2)				
				}	
				else {
					local 2 "the package had no description"
				}
				*/
				macro shift
			}
				
			else {
				macro shift
			}
		}
		file read `hitch' line
	}
	file close `hitch'
	
	// get the version
	// ---------------
	/*
	sleep 3000
	capture quietly copy "https://api.github.com/repos/`anything'/releases" `api', replace
	if _rc != 0 {
		di as err "{p}the GitHub API is not responsive right now. Try again in 10 or 20 seconds." ///
		" this can happen if you search GitHub very frequent..."
		exit
	}
	*/
	di as err "Command:`repo'" _n "Capital:`capital'" _n 

end

githubmake haghish/markdoc
