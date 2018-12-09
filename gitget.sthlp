{smcl}
{it:v. 1.0.3} 


{title:Title}

{p 4 4 2}
gitget {hline 2} install/update a package from GitHub using the {it:packagename} only 


{title:Syntax}

{p 8 8 2} {bf:gitget} {it:packagename} 


{title:Description}

{p 4 4 2}
{bf:github} is a wrapper for  {browse "help github":github install} command. it uses the 
{bf:gitget.dta} data set, which is installed with {bf:github} package to obtain 
the {it:username/reponame} of the package. if multiple packages with identical name 
are found, the command describes them in a table without installing any module.    {break}


{title:Example}

    installing markdoc package and its dependencies
        . gitget markdoc


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
University of Göttingen     {break}
haghish@med.uni-goettingen.de      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 

