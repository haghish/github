// documentation is written for markdoc package (github.com/haghish/markdoc) 
// . markdoc make.ado, mini export(sthlp) replace

/***
_v. 1.1_ 

make
====

builds package installation files

Syntax
------ 

> __make__ _pakagename_ [, _options_]

### options

| _option_          |  _Description_                       |
|:------------------|:-------------------------------------|
| replace            | replace existing files              |
| toc                | generates __stata.toc__ file        |
| pkg                | generates __packagename.pkg__ file  |
| readme             | generates __README.md__ file        |
| title(_str_)       | title of the package                |
| version(_str_)     | Version of the package              |
| description(_str_) | description of the package          |
| license(_str_)     | license of the package              |
| author(_str_)      | author of the package               |
| affiliation(_str_) | author's affiliation                |
| url(_str_)         | package or relevant url address     |
| email(_str_)       | package maintainer's email address  |
| install(_str_)     | installation files, seperated by ";"|
| ancillary(_str_)   | ancillary files, seperated by ";"   |


Description
-----------

__make__ generates the required files to make a Stata program 
installable. the command is particularly handy for packages 
hosted on private websites or GitHub


Example
-------

building the installation files for "mypackage" program

        . make mypackage, replace toc pkg readme          ///
               title(title) version(1.0.0) license("MIT") ///
               description(describe the package)          ///
               author(author name)                        ///
               affiliation(author's affiliation)          ///
               email(package maintained email)            ///
               url(relevant URL)                          ///
               install("a.ado;a.sthlp;b.ado;b.sthlp")     ///
               ancillary("x.dta;y.dta")

Author
------

E. F. Haghish   
University of Göttingen    
_haghish@med.uni-goesttingen.de_  
[https://github.com/haghish](https://github.com/haghish)

License
-------

MIT License

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/




	
*cap prog drop make
prog make
	
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
	

	//title of the package
	//local anything : di `anything'
	local capital : di ustrupper("`anything'") 
	
	//make the temporary files
	tempfile toctmp pkgtmp readtmp
	tempname hitch knot tocfile pkgfile readmefile
	
	// Creating the TOC file
	// -------------------------------------------------------
	qui file open `tocfile' using "`toctmp'", write replace
	if !missing("`version'") {
		file write `tocfile' "v `version'" _n 
	}
	if !missing("`author'") {
		file write `tocfile' "d Materials by `author'" _n 
	}
	

	if !missing("`affiliation'") {
		file write `tocfile' "d `affiliation'" _n 
	}
	if !missing("`email'") {
		file write `tocfile' "d `email'" _n 
	}
	if !missing("`url'") {
		file write `tocfile' "d `url'" _n 
	}

	
	file write `tocfile' _n
	
	*file write `tocfile' "d '`capital''" _n(2) 
	
	if !missing("`description'") {
		file write `tocfile' "d '`anything'': `description'" _n(2) 
	}
	file write `tocfile' "p `anything'" _n
	
	
	// Creating the PKG file
	// -------------------------------------------------------
	qui file open `pkgfile' using `"`pkgtmp'"', write replace
	if !missing("`version'") {
		file write `pkgfile' "v `version'" _n 
	}
	if !missing("`title'") {
		file write `pkgfile' "d '`capital'': `title'" _n
	}
	else file write `pkgfile' "d '`capital''" _n
	
	if !missing("`description'") {
		file write `pkgfile' "d " _n  "d `description'" _n
	}
	
	
	//date
	local today : di %td_CYND  date("$S_DATE", "DMY")
	file write `pkgfile' "d " _n 
	file write `pkgfile' "d Distribution-Date: `today'" _n 
	if !missing("`license'") {
		file write `pkgfile' "d License:" " `license'" _n
	}
	file write `pkgfile' "d " _n
	
	//if install and ancillary are empty, list all files 
	if missing("`install'") & missing("`ancillary'") {
		//local install : dir . files "*" //the files are manually selected
		tokenize `"`install'"'
		while `"`macval(1)'"' != "" {
			if `"`macval(1)'"' != ".DS_Store"  								    ///
			& substr(`"`macval(1)'"', -4,.) != ".pkg" 						///
			& substr(`"`macval(1)'"', -4,.) != ".toc" 						///
			& `"`macval(1)'"' != "README.md"                      ///
			& `"`macval(1)'"' != "readme.md"		                  ///
			& `"`macval(1)'"' != "index.md"		                    ///
			& `"`macval(1)'"' != "index.html"  									  ///
			& `"`macval(1)'"' != "license.md"		                  ///
			& `"`macval(1)'"' != "dependency.do"								  ///
			& `"`macval(1)'"' != "params.json"  								  ///
			& `"`macval(1)'"' != ".gitignore"									    ///
			{
				file write `pkgfile' `"F `1'"' _n
			}
			macro shift
		}
	}
	
	if !missing("`install'") {
		// get the file names install option
		tokenize `"`install'"', parse(";")	
		preserve
		qui clear
		qui generate str files = ""
		qui set obs 1000
		local start = 0
		while !missing("`1'") {
				if "`1'" != ";" {
				local start = `start' + 1
				qui replace files = `"`1'"' in `start'
			}
			macro shift
		}

		qui drop if files==""
		qui sort files
		forval m = 1/`start' {
		  local n : di files[`m']
		  file write `pkgfile' `"F `n'"' _n
		}
		restore
	}
	if !missing("`ancillary'") {
		// get the file names ancillary option
		tokenize `"`ancillary'"', parse(";")	
		while !missing("`1'") {
				if "`1'" != ";" {
				file write `pkgfile' `"f `1'"' _n
			}
			macro shift
		}
	}
	
	
	// Creating the README.md file
	// -------------------------------------------------------
	qui file open `readmefile' using "`readtmp'", write replace
	
	if !missing("`version'") {
	  file write `readmefile' "_v. `version'_  " _n(2)
	}
	
	file write `readmefile' "`" "`anything'" "` "
	if !missing("`title'") {
		file write `readmefile' ": `title'"
	}
	local len = length(" `anything' : `title' ")
	file write `readmefile' _n  _dup(`len') "=" _n(2)
	
	
	if !missing("`description'") {
		file write `readmefile' "Description" _n
		file write `readmefile' "-----------" _n(2)
		file write `readmefile' "`description'" _n
	}
	
	if !missing("`license'") {
	  file write `readmefile' _n "### License" _n
		file write `readmefile' "`license'" _n
	}
	
	if !missing("`author'") {
	  file write `readmefile' _n "Author" _n
		file write `readmefile' "------" _n(2)
		file write `readmefile' "**`author'**  " _n
		if !missing("`affiliation'") file write `readmefile' "`affiliation'  " _n
		if !missing("`email'") file write `readmefile' "`email'  " _n
		if !missing("`url'") file write `readmefile' "<`url'>  " _n
	}

	
	//close and copy the files
	file close `tocfile'
	file close `pkgfile'
	file close `readmefile'
	if !missing("`toc'") quietly copy "`toctmp'" "stata.toc", `replace'
	if !missing("`pkg'") quietly copy "`pkgtmp'" "`anything'.pkg", `replace'
	if !missing("`readme'") quietly copy "`readtmp'" "README.md", `replace'


end



// make "test" 
//, install("githubdependency.ado;githublist.ado;githubmake.ado")
