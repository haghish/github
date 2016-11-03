/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.0.0
Title: github
Description: installs Stata packages with a particular version (release) from 
[GitHub](http://www.github.com/haghish/githubinstall) 
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Syntax
======

{p 8 16 2}
{cmd: github} [ {bf:install} | {bf:query} ] {it:username}{bf:/}{it:repository} [{cmd:,} version(str) {it:replace force}]
{p_end}

{* the new Stata help format of putting detail before generality}{...}
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt v:ersion}}specifies a particular version{p_end}
{synopt:{opt replace}}specifies that the downloaded files replace existing files 
if any of the files already exists{p_end}
{synopt:{opt replace}}specifies that the downloaded files replace existing files 
if any of the files already exists, even if Stata thinks all the files are the same.
force implies replace{p_end}
{synoptline}
{p2colreset}{...}

Description
===========

__github__ simplifies installing Stata packages from 
[GitHub](http://www.github.com/) website. The package also allows installing 
older releaes of the package using the __version()__ option, a feature that 
improves reproducibility of analyses carried out by user-written packages. 

Example(s)
=================

    install the latest version of MarkDoc package from GitHub
        . github haghish/markdoc, replace

    install MarkDoc version 3.8.1 from GitHub
        . github haghish/markdoc, replace version("3.8.1")

Acknowledgements
================

If you have thanks specific to this command, put them here.

Author
======

E. F. Haghish   
Department of Mathematics and Computer Science (IMADA)    
University of Southern Denmark    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/



cap prog drop github
prog define github
	
	*installgithub username/path/to/repo , version() 
	
	syntax anything, [Version(str) replace force] 
	
	tokenize `anything'
	local anything "`2'"
	
	if "`1'" == "query" {
		githubQuery `anything'
		exit
	}
	else if "`1'" != "install" {
		err 198
	}
	
	// Get the packagename
	// -------------------
	tempfile api tmp
	tempname hitch knot
	qui copy "https://api.github.com/repos/`anything'/contents" `api', replace
	qui copy "https://api.github.com/repos/`anything'/contents" "sth.txt", replace
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
		if missing("`package'") {
			local package "`1'"
		}	
		macro shift
	}
	
	if !missing("`version'") {
		local path "https://github.com/`anything'/archive/`version'.zip"
		
		quietly copy "`path'" "`version'.zip", replace
	
		
		quietly unzipfile "`version'.zip", replace
		local dir "`package'-`version'"
		
		local wd : pwd
		qui cd "`dir'" 
		local pkg : pwd
		qui cd "`wd'"

		net install "`package'", from("`pkg'") `replace' `force' 
		
		di _n "{title:Checking package dipendencies}" 
		capture quietly findfile "dependency.do", path("`pkg'")
		if _rc == 0 {
			di as txt "installing package dependencies:" _n
			noisily do `r(fn)'
		}
		else {
			di as txt "`package' package has no dependency"
		}
		
	}
	else {
		//goes to the current directory path
		//local path "https://github.com/`anything'/archive/`version'.zip" 
		
		net install `package', from("https://raw.githubusercontent.com/`anything'/master/") `replace' `force' 
		
		di _n "{title:Checking package dipendencies}" 
		tempfile dep
		capture quietly copy "https://raw.githubusercontent.com/`anything'/master/dependency.do" `dep'
		if _rc == 0 {
			di as txt "{bf:installing package dependencies:}" _n
			noisily do `dep'
		}
		else {
			di as txt "`package' package has no dependency"
		}
		
	}
	
	
	*di as err "`anything'"
	
end

markdoc github.ado, export(sthlp) replace

