{smcl}
{it:v. 1.1}


{title:Title}

{p 4 4 2}
{bf:pkgzip} - creates and downloads a Zip file from SSC and names it based on the package release date


{title:Syntax}

{p 8 8 2} {bf:pkgzip} {it:packagename} 



{title:Description}

{p 4 4 2}
{bf:pkgzip} downloads a package from SSC. t will also analyze the last release 
date of the package and creates a Zip file with the release date, to imply the 
version of the package. packages hosted on SSC do not have a version specified 
within the package description and instead, the release date is used to show 
package versions. 



{title:Example(s)}
		
{p 4 4 2}
download adoedit package from SSC, along with its version

    . pkgzip adoedit


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
Department of Mathematics and Computer Science (IMADA)      {break}
University of Southern Denmark      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


