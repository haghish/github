{smcl}
{it:v. 1.0.4} 


{title:Title}

{p 4 4 2}
{bf: {browse "https://github.com/haghish/github":gitget}} {hline 2} install or update a package from GitHub using the {it:packagename} only 


{title:Syntax}

{p 8 8 2} {bf:gitget} {it:packagename} [, stable version({it:str}) ]

{p 4 4 2}
{it:options}

{space 4}{hline}

{p 4 4 2}
stable: installs the latest released version of a package     {break}
{ul:v}ersion({it:str}): installs a particular released version     {break}

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

    installing markdoc package and its dependencies
        . gitget markdoc
				
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

