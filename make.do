// the 'make.do' file is automatically created by 'github' package.
// execute the code below to generate the package installation files.
// DO NOT FORGET to update the version of the package, if changed!
// for more information visit http://github.com/haghish/github

make github, replace toc pkg  version(2.0.0)                         ///
     license("MIT")                                                  ///
     author("E. F. Haghish")                                         ///
     affiliation("University of Göttingen")                          ///
     email("haghish@med.uni-goettingen.de")                          ///
     url("https://github.com/haghish/github")                        ///
     title("github package manager")                                 ///
     description("search, install, and manage github packages")      ///
     install("abspath.ado;findall.ado;findall.sthlp;gitget.ado;"     /// 
		 "gitget.dta;gitget.sthlp;gitgetlist.ado;github.ado;"            ///
		 "github.dlg;github.sthlp;githubcheck.ado;githubconfirm.ado;"    ///
		 "githubdb.ado;githubdependency.ado;githubfiles.dta;"            ///
		 "githubhot.ado;githublistpack.ado;githublistpack.sthlp;"        ///
		 "githuboutput.ado;githubquery.ado;githubsearch.ado;"            ///
		 "githubmake.ado;githubsearchsteps.ado;pkgzip.ado;"              ///
		 "pkgzip.sthlp;make.ado;make.dlg;make.sthlp;makedlg.ado;"        ///
		 "ssclastupdate.ado;sscminer.ado;sscminer.sthlp")               ///
     ancillary("")                                                  


/*
Generating the package documentation
====================================

The package documentation is written in Markdown language. 
The MARKDOC package extract these documentation and 
create the Stata help files as well as Markdown 
documentation for GitHub Wiki. Learn more about MARKDOC
here: https://github.com/haghish/markdoc

Generating Stata Help Files
---------------------------
*/

markdoc "github.ado", mini export(sthlp) replace
markdoc "gitget.ado", mini export(sthlp) replace
markdoc "make.ado", mini export(sthlp) replace
markdoc "pkgzip.ado", mini export(sthlp) replace
markdoc "githublistpack.ado", mini export(sthlp) replace
markdoc "sscminer.ado", mini export(sthlp) replace
markdoc "abspath.ado", mini export(sthlp) replace
markdoc "findall.ado", mini export(sthlp) replace

/*
Generating markdown files for GitHub Wiki
-----------------------------------------
*/

markdoc "github.ado", mini export(md) replace
markdoc "gitget.ado", mini export(md) replace
markdoc "make.ado", mini export(md) replace
markdoc "pkgzip.ado", mini export(md) replace
markdoc "githublistpack.ado", mini export(md) replace
markdoc "sscminer.ado", mini export(md) replace
markdoc "abspath.ado", mini export(md) replace
markdoc "findall.ado", mini export(md) replace

/*
Generating the package vignette
-----------------------------------------
*/

markdoc "vignette.do", mini export(html) replace                             ///
        title("github v. 2.0.0 package vignette")                            ///
				author("E. F. Haghish")                                              ///
				affiliation("University of Goettingen")                              ///
				address("haghish@med.uni-goettingen.de") 

markdoc "vignette.do", export(tex) toc replace master                        ///
        title("github v. 2.0.0 package vignette")                            ///
				author("E. F. Haghish")                                              ///
				affiliation("University of Goettingen")                              ///
				address("haghish@med.uni-goettingen.de") 




