

*cap prog drop makedlg
prog makedlg
	
	syntax [anything] [,      ///
	        toc               ///
			pkg               ///
			readme            ///
			make              ///
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
	
	di _n(2) "{title:Executing the make command}" _n
	di as txt "make `anything', `replace' `toc' `pkg' `readme' version(`version')" _col(77) " ///" _n ///
	   `"     license("`license'")"' _col(77) " ///" _n ///
	   `"     author("`author'")"' _col(77) " ///" _n ///
	   `"     affiliation("`affiliation'")"' _col(77) " ///" _n ///
	   `"     email("`email'")"' _col(77) " ///" _n ///
	   `"     url("`url'")"' _col(77) " ///" _n ///
	   `"     title("`title'")"' _col(77) " ///" _n ///
	   `"     description("`description'")"' _col(77) " ///" _n ///
	   `"     install("`inst'")"' _col(77) " ///" _n ///
       `"     iancillary("`anc'")"' _col(77)  _n 
	   
	// generate the make.do
	if !missing("`make'") {
		tempfile temp
        tempname knot
        file open `knot' using "`temp'", write
		file write `knot' "// the 'make.do' file is automatically created by 'github' package." _n ///
		                  "// execute the code below to generate the package installation files." _n ///
		                  "// DO NOT FORGET to update the version of the package, if changed!" _n ///
						  "// for more information visit http://github.com/haghish/github" _n(2)
						  
		file write `knot' "make `anything', `replace' `toc' `pkg' `readme' version(`version')" _col(77) " ///" _n ///
	   `"     license("`license'")"' _col(77) " ///" _n ///
	   `"     author("`author'")"' _col(77) " ///" _n ///
	   `"     affiliation("`affiliation'")"' _col(77) " ///" _n ///
	   `"     email("`email'")"' _col(77) " ///" _n ///
	   `"     url("`url'")"' _col(77) " ///" _n ///
	   `"     title("`title'")"' _col(77) " ///" _n ///
	   `"     description("`description'")"' _col(77) " ///" _n ///
	   `"     install("`inst'")"' _col(77) " ///" _n ///
       `"     iancillary("`anc'")"' _col(77)  _n 
		 
	   
    file close `knot' 
		copy "`temp'" make.do , replace 
		
		cap confirm file "make.do"
		if _rc == 0 {
			di as txt "(make created "`"{bf:{browse "make.do"}})"' _n
		}
		else display as err "make could not produce make.do" _n
	}
	
	// call the make function 
	make `anything',                    ///
	     `toc'                          ///
		 `pkg'                          ///
		 `readme'                       ///
		 `replace'                      ///
		 title(`title')                 ///
	     version(`version')             ///
		 license("`license'")           ///
	     description(`description')     ///
		 author(`author')               ///
		 affiliation(`affiliation')     ///
		 email(`email')                 ///
		 url(`url')                     ///
	     install("`inst'")              ///
		 ancillary("`anc'")
	
end

