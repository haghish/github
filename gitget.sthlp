{smcl}
{it:v. 1.2} 


{title:gitget}

{p 4 4 2}
{bf:gitget} installs or updates a package from GitHub using the {it:packagename} only. 
this is an exploratory alternative to {bf:github} command. 


{title:Syntax}

{p 8 8 2} {bf:gitget} {it:packagename} [, stable version({it:str}) ]

{p 4 4 2}
{it:options}

{col 5}{it:option}{col 24}{it:Description}
{space 4}{hline}
{col 5}stable{col 24}installs the latest stable release. otherwise the main branch is installed
{col 5}{ul:v}erson({it:str}){col 24}specifies a particular stable version (release tags) for the installation
{space 4}{hline}


{title:Description}

{p 4 4 2}
{bf:github} is a wrapper for  {browse "help github":github install} command. it uses the 
{bf:gitget.dta} data set, which is installed with {bf:github} package to obtain 
the {it:username/reponame} of the package. if multiple packages with identical name 
are found, the command describes them in a table without installing any module.    {break}

{p 4 4 2}
by default, the command installs the development version of a repository. if you 
wish to install a stable release rather than the developmnt version, add the 
{bf:stable} option or specify the version within the {bf:version} option. 


{title:Example}

{p 4 4 2}
installing markdoc package and its dependencies

    . gitget markdoc

{p 4 4 2}
installing the latest stable version of markdoc package and its dependencies

    . gitget markdoc, stable


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
University of Göttingen     {break}
haghish@med.uni-goettingen.de      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


