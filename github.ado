/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.9.0
Title: github
Description: search, install, and uninstall Stata packages with a particular  
version (release) as well as their dependencies from 
[GitHub](http://www.github.com/haghish/github) website
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Syntax
======

{p 8 16 2}
{cmd: github} [ {help github##subcommand:{it:subcommand}} ] [ {it:keyword} | {it:username/repository} ] [{cmd:,} options]
{p_end}

The __github__ command takes several subcommands:

{marker subcommand}{...}
{synoptset 20 tabbed}{...}
{synopthdr:subcommand}
{synoptline}
{synopt:{opt install}}installs the specified repository. The command should be 
followed by the {bf:username/repository}{p_end}
{synopt:{opt uninstall}}uninstalls a package{p_end}
{synopt:{opt query}}followed by {bf:username/repository}, it makes a table of 
all of the released versions of that package and allows you to install any version 
with a single click.{p_end}
{synopt:{opt check}}followed by a {bf:username/repository} evaluates whether the 
repository is installable (i.e. includes {bf:toc} and {bf:pkg} files{p_end}
{synopt:{opt search}}followed by a {bf:keyword}, it searches the GitHub API in
repository name (default), repository description, {bf:README.md} file in 
the repository, or all of the above. the {bf:in(str)} option specifies the 
field of the API search.{p_end}
{synopt:{opt list}}GitHub API returns maximum of 100 research results. therefore, 
a recursive search is needed to build the complete list of Stata packages on 
GitHub. followed by a keyword (e.g. stata) the {bf:list} command searches the 
API within a specific time periods and aggregate the results to build the complete 
list of Stata packages. {p_end}
the {bf:language}, {bf:all}, and {bf:number} options can be used to narrow 
or expand the results. {p_end}
{synoptline}
{p2colreset}{...}

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

{* the new Stata help format of putting detail before generality}{...}
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Installation Options}
{synopt:{opt stable}}will install the latest released version of the software. otherwise, the depelopment version of the package will be installed.{p_end}
{synopt:{opt v:ersion(str)}}specifies a particular stable version (release tags) for 
installing a new repository{p_end}
{synopt:{opt force}}specifies that the downloaded files be installed even if the 
__packagename.pkg__ and __Stata.toc__ files are missing. Use this option 
wisely because by forcing the installation, you are installing a software that 
is not prepared for installation. {p_end}

{syntab:Search Options}
{synopt:{opt language(str)}}specifies the programming language of the repository. 
the default is {bf:stata}. To search for all programming languages related 
to the {it:keyword}, specify {bf:language(all)}. {p_end}
{synopt:{opt in(str)}}specifies the domain of the search which can be {bf:name} (default) 
{bf:description}, {bf:readme}, or {bf:all}. To search for the {it:keyword} in 
repository name, repository description, and the readme.md file, 
specify {bf:in(all)}. {p_end}
{synopt:{opt save(str)}}saves the results in a data set with the given name. {p_end}
{synopt:{opt all}}shows repositories that lack the {bf:pkg} and {bf:stata.toc} 
files. by default these repositories are not shown in the output because they 
are not installable packages {p_end}
{synopt:{opt append}}when the {bf:save} option is specified, the {bf:append} 
option will add the new results to the saved dataset{p_end}
{synopt:{opt replace}}when the {bf:save} option is specified, the {bf:replace} 
option will replaces the dataset, if it exists{p_end}
{synopt:{opt number(int)}}limits the number of displayed repositories.{p_end}
{synopt:{opt created(str)}}filters the search results based on the date that the 
repository was created on github. The date must be written with the format of 
"{bf:yyyy-mm-dd}" which is required by GitHub. This option can also specify 
a range of time between two dates. 
{browse "https://help.github.com/articles/searching-repositories/#search-based-on-when-a-repository-was-created-or-last-updated":See the documentations on GitHub}.{p_end}
{synopt:{opt pushed(str)}}filters the search results based on the date that the 
repository was last updated on github. The format for entering the date 
is identical to the {bf:created} option.{p_end}
{synoptline}
{p2colreset}{...}


Installing package dependencies
===============================

Packages installed by __github__ command can also automatically install the 
package dependencies. 
For example, the {browse "https://github.com/haghish/MarkDoc":MarkDoc} package 
requires two other Stata packages which are 
{browse "https://github.com/haghish/weaver":Weaver} and
{browse "https://github.com/haghish/MarkDoc":Statax}. 
Usually, users have to install these packages manually after installing 
MarkDoc from GitHub or SSC. However, the __github install__ command will look 
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

    install the latest version of MarkDoc package from GitHub
        . github install haghish/markdoc

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
		
    search for a repository named "github" and published in November 2016 
        . github search github, created("2016-11-01..2016-11-30") 


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
	
	syntax anything, [stable Version(str) force save(str) in(str) 				        ///
	language(str) all NET                                                         ///
	/// some of the options of the program are not documented yet                 ///
	created(str) pushed(str) debug reference(str)			                            ///
	duration(numlist max=1) perpage(numlist max=1)                              ///
	append replace Number(numlist max=1) local] 
	
	
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
	if "`1'" == "hot" {
		githubhot `anything'
		exit
	}
	
	// List
	// ---------
	else if "`1'" == "list" {
		if !missing("`anything'") {
			err 198
		}
		githubdb list
		exit
	}
	
	// Update
	// ---------
	if "`1'" == "update" {
		
		// if a package name is specified, update it
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
		githubdb erase, name("`2'")
		ado uninstall `2'
		exit
	}
	
	// Search
	// ---------
	else if "`1'" == "search" {
	  if !missing("`local'") | !missing("`net'") {
	    findall `2', language(`language') in(`in') `local'  `net' `all' 
		exit
	  }
	  else {
		githubsearch `2', language(`language') in(`in') save(`save') `all' 		///
		  created(`created') pushed(`pushed') `debug' `append' `replace'        ///
		  number(`number') perpage(`perpage')
		exit
	  }
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
	qui copy "https://api.github.com/repos/`anything'/contents" `api', replace
	*qui copy "https://api.github.com/repos/`anything'/contents" "sth.txt", replace
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
					local package : di substr(`"`macval(name)'"', 1,`l'-4)
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
	if missing("`package'") {
		local package `reponame'
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
		
		quietly copy "`path'" "`package'-`version'.zip", replace
		quietly unzipfile "`package'-`version'.zip", replace
		local dir "`package'-`version'"
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
		
		net install `package', from("https://raw.githubusercontent.com/`anything'/master/") `replace' //`force' 
		
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

