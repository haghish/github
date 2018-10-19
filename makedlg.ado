

cap prog drop makedlg
prog makedlg
	
	syntax [anything] [,      ///
	        toc               ///
					pkg               ///
					readme            ///
					replace           ///
					title(str)        ///
					Version(str)      /// 
					Description(str)  ///
					license(str)      ///
					AUThor(str)       ///
					affiliation(str)  ///
					url(str)          ///
					email(str)        ///
	        ancillary(str)    ///
	        install(str)      ///
				 ]

	
	// get the install file names of anything
	tokenize `"`install'"', parse(" ")	
	while !missing("`1'") {
	  quietly abspath "`1'"
		if missing("`inst'") local inst = "`r(fname)'"
		else local inst = "`inst';`r(fname)'"	
		macro shift
	} 
	
	// get the ancillary file names of anything
	tokenize `"`ancillary'"', parse(" ")	
	while !missing("`1'") {
	  quietly abspath "`1'"
		if missing("`anc'") local anc = "`r(fname)'"
		else local anc = "`anc';`r(fname)'"	
		macro shift
	} 
	


	
	// call the make function 
	make "`anything'",                  ///
	     `toc'                          ///
			 `pkg'                          ///
			 `readme'                       ///
			 `replace'                      ///
			 title(`title')                 ///
	     version(`version')             ///
	     description(`description')     ///
			 author(`author')               ///
	     install("`inst'")              ///
			 ancillary("`anc'")
	
end



makedlg "packagename", version("1.0.0") author("haghish") ///
description("this is the package description") ancillary(`""C:\Users\haghish.fardzadeh\Documents\GitHub\github\githubdependency.ado" "C:\Users\haghish.fardzadeh\Documents\GitHub\github\githublist.ado" "C:\Users\haghish.fardzadeh\Documents\GitHub\github\githubmake.ado""') readme replace ///
title("do something cool")
