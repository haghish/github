{smcl}
{it:v. 1.1} 


{title:make}

{p 4 4 2}
builds package installation files


{title:Syntax}

{p 8 8 2} {bf:make} {it:pakagename} [, {it:options}]

{p 4 4 2}{bf:options}

{col 5}{it:option}{col 24}{it:Description}
{space 4}{hline 57}
{col 5}replace{col 24}replace existing files
{col 5}toc{col 24}generates {bf:stata.toc} file
{col 5}pkg{col 24}generates {bf:packagename.pkg} file
{col 5}readme{col 24}generates {bf:README.md} file
{col 5}title({it:str}){col 24}title of the package
{col 5}version({it:str}){col 24}Version of the package
{col 5}description({it:str}){col 24}description of the package
{col 5}license({it:str}){col 24}license of the package
{col 5}author({it:str}){col 24}author of the package
{col 5}affiliation({it:str}){col 24}author{c 39}s affiliation
{col 5}url({it:str}){col 24}package or relevant url address
{col 5}email({it:str}){col 24}package maintainer{c 39}s email address
{col 5}install({it:str}){col 24}installation files, seperated by ";"
{col 5}ancillary({it:str}){col 24}ancillary files, seperated by ";"
{space 4}{hline 57}


{title:Description}

{p 4 4 2}
{bf:make} generates the required files to make a Stata program 
installable. the command is particularly handy for packages 
hosted on private websites or GitHub



{title:Example}

{p 4 4 2}
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


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
University of Göttingen     {break}
{it:haghish@med.uni-goesttingen.de}    {break}
{browse "https://github.com/haghish":https://github.com/haghish}


{title:License}

{p 4 4 2}
MIT License

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


