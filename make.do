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
		 "ssclastupdate.ado;sscminer.ado;sscminer.sthlpM")               ///
     ancillary("")                                                  


