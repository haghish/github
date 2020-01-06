{smcl}
version: 1.3


{title:githubfindall}

{p 4 4 2}
a program to search for Stata packages on GitHub, Stata Journal, 
SSC, and the web. ths program is executed by {bf:github search} command, with 
the {bf:net} option and is not called on its own.


{title:Syntax}

{p 8 8 2} {bf:githubfindall} {it:keyword}


{title:Description}

{p 4 4 2}
{bf:githubfindall} is a general command for searching for Stata packages on variety of 
web hosts, including GitHub, Stata, SSC, etc. The command wraps the Stata{c 39}s 
{help search} command and adds the results of {bf:github search} command from the 
{browse "https://github.com/haghish/github":github package}. 

{p 4 4 2}
In addition, the command shows the date of the last update of Stata modules on 
SSC as well as GitHub, allowing the users to get the most recent version of the 
package.    {break}


{title:Example}

{p 4 4 2}
search for markdoc package on SSC and GitHub and show the last update

    . githubfindall markdoc


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}       {break}
Center for Medical Biometry and Medical Informatics       {break}
University of Freiburg, Germany       {break}
{it:and}          {break}
Department of Mathematics and Computer Science         {break}
University of Southern Denmark       {break}
haghish@imbi.uni-freiburg.de          {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


