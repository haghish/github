/***
_v. 1.9.8_

Title
=====

__github__ - search, install, and uninstall Stata packages with a particular 
version (release) as well as their dependencies from 
[GitHub](http://www.github.com/haghish/github) website

Syntax
======

> __github__ [ _subcommand_ ] [ _keyword_ | _username/repository_ ] [, _options_ ]


where the subcommands can be:

| _subcommand_ |  _Description_                                                           |
|:-------------|:-------------------------------------------------------------------------|
| install      | followed by the _username/repository_, installs the specified repository |
| query        | followed by _username/repository_, returns all released versions of that package |
| check        | followed by _username/repository_, evaluates whether the repository is installable |
| uninstall    | followed by _package name_, uninstalls a package |
| search       | followed by _keywords_, it searches the GitHub API for relevant packages or repositories |
| findfile     | followed by a _keyword_, it searches Stata packages for files that include the keyword |
| list         | lists the packages installed from GitHub and checkes if they have an update |


Description
===========

__github__ simplifies searching and installing Stata packages from 
[GitHub](http://www.github.com/) website. The package also allows installing 
older releaes of the package using the __version()__ option, if the author 
has made different release versions on GitHub. In addition, the command allows 
the authors to specify package dependencies - that must be installed prior to 
using the package - to be installed automatically. 

If the dependencies are also hosted on GitHub, the author can specify a 
particular version of the dependencies to ensure the software works with the 
tested version of the dependencies. The information about the 
package dependencies also appear in the __github search__ command, allowing 
the user to view the dependencies and their particular version that will be 
installed automatically. 

Options
=======

The __github__ command also takes several options for installing a package or 
searching for a keyword. The table shows the options accordingly:


### __github install__ options:

| _option_    |  _Description_                                                           |
|:------------|:-------------------------------------------------------------------------|
| package(_str_) | the package name. only needed if the repository name is not identical to the package name |
| stable   | installs the latest stable release. otherwise the main branch is installed |
| verson(_str_) | specifies a particular stable version (release tags) for the installation |


### __github search__ options:

| _option_     |  _Description_                                                           |
|:-------------|:-------------------------------------------------------------------------|
| language(_str_)   | specifies the programming language of the repository. the default is __Stata__ |
| in(_str_) | specifies the domain of the search which can be __name__, __description__, __readme__, or __all__ |
| all | shows repositories that lack the __pkg__ and __stata.toc__ files in the search results |


Installing package dependencies
===============================

Packages installed by __github__ command can also automatically install the 
package dependencies. The __github install__ command will look 
for a file named __dependency.do__ in the repository and executes this file 
if it exists. 

The __dependency.do__ file will not be copied to the PLUS 
directory and is simply executed by Stata after installing the package. It can 
include a command for installing dependency packages using __ssc__, 
__net install__, or __github install__ commands. The latter is preferable because 
it also allows you to specify a particular version for the dependency packages. 

Note that the __dependency.do__ file will only be executed by __github install__ 
command and other installation commands such as __net install__ will not 
install the dependencies. 

Example(s)
=================

__examples of installing and uninstalling packages__ 

    install the latest development version of MarkDoc package 
        . github install haghish/markdoc
		
		install the latest stable version of MarkDoc package
        . github haghish/markdoc, stable

    install MarkDoc version 3.8.1 from GitHub (older version)
        . github haghish/markdoc, version("3.8.1")
		
    Uninstall MarkDoc repository
        . github uninstall markdoc
		
    list all of the available versions of the MarkDoc package
        . github query haghish/markdoc
		
		
__examples of searching for a package__ 
		
    search for MarkDoc package on GitHub
        . github search markdoc
		
    search for a Stata package named "weaver"
        . github search weaver, language(stata)
	
    search for Stata packages that mention the keyword "likelihood" 
        . github search likelihood, language(stata) in(all)
		
    search for a script files with the name _dy_
        . github findfile dy


__examples of searching the popular packages__ 
	
    build the complete list of Stata packages on GiutHub
        . github list stata, language(all) in(all) all save(archive) append
		
Author
======

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

*cap prog drop github
prog define github

	version 13
	
	syntax anything, [stable Version(str) save(str) in(str) 				              ///
	language(str) all NET package(str)                                            ///
	/// the options below are not documented yet                                  ///
	force created(str) pushed(str) debug reference(str)			                      ///
	duration(numlist max=1) perpage(numlist max=1)                                ///
	append replace Number(numlist max=1) local path(str)] 
	
	
	// correct the language
	if "`language'" == "stata" local language Stata
	if "`language'" == "r" local language R
	if "`language'" == "python" local language Python
	
	tokenize `anything'
	local anything "`2'"
	
	
	
	// Query
	// ---------
	if "`1'" == "query" {
		githubquery `anything'
		exit
	}
	
	// Version     //CHANGE THIS TO INFO?
	// ---------
	if "`1'" == "version" {
		githubdb version, name(`anything')
		exit
	}
	
	// Hot
	// ---------
	// THIS COMMAND IS EXPERIMENTAL AND IS NOT DOCUMENTED YET. 
	if "`1'" == "hot" {
		githubhot `anything'
		exit
	}
	
	// List
	// ---------
	else if "`1'" == "list" {
		if !missing("`3'") {
			err 198
		}
		githubdb list, name("`2'")
		exit
	}
	
	// Update
	// ---------
	if "`1'" == "update" {
		
		// if a package name is specified
		if missing("`anything'") {
		  di as err "package name is required"
		  qui err 198
		}
		
		// Make github command to update a package, if the username is also specified 
		capture githubdb check, name("`anything'")
		if !missing("`r(address)'") {
			github install `r(address)'
		}
		else {
			tokenize "`anything'", parse("/")
			if !missing("`3'") {
				capture githubdb check, name("`anything'")
				if !missing("`r(address)'") {
					github install `r(address)'
				}
			}
			//otherwise display the original error
			else {
				githubdb check, name("`anything'")
			}
		}
		exit
	}
	
	// Uninstall
	// ---------
	else if "`1'" == "uninstall" {
		// if a package name is specified
		if missing("`anything'") {
		  di as err "package name is required"
		  qui err 198
		}
		githubdb erase, name("`2'")
		ado uninstall `2'
		exit
	}
	
	else if "`1'" == "findfile" {
		// searching githubfiles database
		preserve
		sysuse githubfiles.dta, clear
		qui gen found = strpos(file, "`2'")
		qui keep if found == 1
		local N = _N
		if `N' > 0 {
			di in text _n " {hline 33}" _n												///
		  "  {bf:Searching githubfiles database}" _n 	///
		  " {hline 33}"
			
			forval j = 1/`N' {
				local address : di address[`j']
				local fname : di file[`j']
				di `"  {browse "https://github.com/`address'":`fname'}"'
			}
			di in text " {hline 33}" _n
		}
		else di in text "({it:nothing found in the database})"
		restore
		
		exit
	}
	
	// Search
	// ---------
	else if "`1'" == "search" {

	  if !missing("`local'") | !missing("`net'") {
	    findall `2', language(`language') in(`in') `local'  `net' `all' 
	  }
	  else {
		githubsearch `2', language(`language') in(`in') save(`save') `all' 		///
		  created(`created') pushed(`pushed') `debug' `append' `replace'        ///
		  number(`number') perpage(`perpage')
	  }
		
		// searching githubfiles database
		/*
		preserve
		sysuse gitget.dta, clear
		qui gen found = strpos(packagename, "`2'")
		qui keep if found == 1
		qui duplicates drop packagename, force
		local N = _N
		if `N' > 0 {
			di in text _n "{ul:Searching gitget package list}" _n
			
			forval j = 1/`N' {
				local address : di address[`j']
				local fname : di packagename[`j']
				di `" - {browse "https://github.com/`address'":`fname'}"'
			}
			di in text _n
		}
		restore
		*/
		
		exit
	}
	
	// Make
	// ---------
	else if "`1'" == "check" {
		githubcheck `2'
		exit
	}
	
	// Make
	// ---------
	else if "`1'" == "make" {
		//githubmake `2'
		//exit
	}
	
	// Listpack (EXPERIMENTAL, UNDOCUMENTED)
	// ---------
	else if "`1'" == "listpack" {
		githublistpack `2' ,  language(`language') duration(`duration')							///
		save(`save') created(`created') pushed(`pushed') `debug' `append' 		///
		`replace'
		exit
	}
	
	// Install
	// ---------
	else if "`1'" != "install" {
		err 198
	}
	
	// PACKAGE INSTALLATION ----------------------------------------------------
	
	// Get the packagename
	// -------------------
	tempfile api tmp
	tempname hitch knot
	capture qui copy "https://api.github.com/repos/`anything'/contents" `api', replace
	if _rc {
		di as txt `"API error occured. visit {browse "https://api.github.com/repos/`anything'/contents"}"'
		qui copy "https://api.github.com/repos/`anything'/contents" `api', replace
	}

	file open `hitch' using "`api'", read
	qui file open `knot' using "`tmp'", write replace
	file read `hitch' line
	//remove the beginning brackets
	local line : subinstr local line "[" "", all
	local line : subinstr local line "]" "", all
	local line : subinstr local line "{" "", all
	local line : subinstr local line "}" "", all
	
	while r(eof) == 0 {

		tokenize `"`macval(line)'"' , parse(",")
		
		while !missing(`"`macval(1)'"') | !missing(`"`macval(2)'"') | !missing(`"`macval(3)'"')  {
			if `"`macval(1)'"' == "," {
				macro shift
			}
			else if `"`macval(1)'"' == "name" { 
				*di as err `"`macval(1)'"'  `"`macval(2)'"' //`"`macval(3)'"'
				macro shift
				local l strlen(`"`macval(1)'"')
				local name : di substr(`"`macval(1)'"', 3,`l'-3) 
				if substr(`"`macval(name)'"', -4,.) == ".pkg" {
					local l strlen(`"`macval(name)'"')
					local packagename : di substr(`"`macval(name)'"', 1,`l'-4)
				}
				macro shift
			}
			else {
				macro shift
			}
		}
		file read `hitch' line
	}
	
	file close `hitch'		
	file close `knot'
	
	//avoid capital letters in the path. It can cause trouble in some cases. The 
	//important file is name.pkg 
	local anything : display ustrlower(`"`anything'"')
	
	tokenize `"`anything'"', parse("/")
	local username `1'
    macro shift
	
	while "`1'" != "" {
		local reponame "`1'"
		macro shift
	}
	if missing("`packagename'") {
		local packagename `reponame'
	}
	
	//If the user has not specified the package name, use the repository name
	if missing("`package'") {
		local package `packagename'
	}
	
	//BY HERE we have the username, repositoryname, and packagename. what else?
	//link address, and possibly downloaded date
	
	
	// Installing a stable version
	// -----------------------------------------------------------------------
	if !missing("`version'") & !missing("`stable'") {
		di as txt "when you specify {bf:version}, adding {bf:stable} is redundant!"
		local stable //reset
	}
	if missing("`version'") & !missing("`stable'") {
		quietly github query `anything'
		local version `r(latestversion)' 
	}
		
	// Installing an archived version
	// -----------------------------------------------------------------------
	if !missing("`version'") | !missing("`force'") {
		
		if !missing("`version'") {
			local path "https://github.com/`anything'/archive/`version'.zip"
		}
		else {
			local path "https://github.com/`anything'/archive/master.zip" 
			local version master
		}
		
		quietly copy "`path'" "`packagename'-`version'.zip", replace
		quietly unzipfile "`packagename'-`version'.zip", replace
		local dir "`packagename'-`version'"
		local wd : pwd
		qui cd "`dir'" 
		local pkg : pwd
		
		// check that the package does not include PKG and TOC before `force'
		if !missing("`force'") {
			capture findfile "`package'.pkg"
			if _rc == 0 {
				capture findfile "Stata.toc"
				if _rc != 0 {
					githubmake "`package'"
				}
			}
			else githubmake "`package'"
		}
		
		qui cd "`wd'"
		
		
		// make sure it is first uninstalled 
		capture quietly ado uninstall "`package'"
		net install "`package'", from("`pkg'") `replace' `force' 
		
		// register the package in the database
		githubdb add, address("`anything'") username("`username'") 			          	///
		              reponame("`reponame'") name("`package'") force("`force'")     ///
									version("`version'")
									
		di _n "{title:Checking package dependencies}" 
		capture quietly findfile "dependency.do", path("`pkg'")
		if _rc == 0 {
			di as txt "installing {bf:`package'} package dependencies:" _n
			noisily do "`r(fn)'"
		}
		else {
			di as txt "{bf:`package'} package has no dependency"
		}
		
		cap qui erase "`package'-`version'.zip"
	}
	
	// Installing from the master
	// -----------------------------------------------------------------------
	else {		
		
		// make sure it is first uninstalled 
		githubdb erase, name("`package'")
		capture quietly ado uninstall "`package'"
		
		if missing("`package'") {
			net install `packagename', ///
			from("https://raw.githubusercontent.com/`anything'/master/`path'") `replace' //`force' 
		}
		else {
			net install `package', ///
			from("https://raw.githubusercontent.com/`anything'/master/`path'")
		}
		
		// check the version of the installing package
		if missing("`version'") {
			quietly github query `anything'
			local version `r(latestversion)'
		}
		
		githubdb add, address("`anything'") username("`username'") 			          	///
		              reponame("`reponame'") name("`package'") force("`force'")     ///
									version("`version'")
		
		di _n "{title:Checking package dependencies}" 
		tempfile dep
		capture quietly copy "https://raw.githubusercontent.com/`anything'/master/dependency.do" `dep'
		if _rc == 0 {
			di as txt "installing {bf:`package'} package dependencies:" _n
			noisily do `dep'
		}
		else {
			di as txt "{bf:`package'} package has no dependency"
		}
	}
	
end

/*
capture prog drop github
markdoc github.ado, export(sthlp) replace build

