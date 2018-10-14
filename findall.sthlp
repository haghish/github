{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:findall} {hline 2} a Stata module to search for Stata packages on GitHub, Stata Journal, SSC, and the web. The command also shows the last update of the module on each 
 server. 
 

{title:Syntax}

{p 8 16 2}
{cmd: findall} {it:keyword} {p_end}


{title:Description}

{p 4 4 2}
{bf:findall} is a general command for searching for Stata packages on variety of 
web hosts, including GitHub, Stata, SSC, etc. The command wraps the Stata{c 39}s 
{help search} command and adds the results of {bf:github search} command from the 
{browse "https://github.com/haghish/github":github package}. 

{p 4 4 2}
In addition, the command shows the date of the last update of Stata modules on 
SSC as well as GitHub, allowing the users to get the most recent version of the 
package.    {break}


{title:Example}

    search for markdoc package on SSC and GitHub and show the last update 
        . findall markdoc


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}       {break}
Center for Medical Biometry and Medical Informatics       {break}
University of Freiburg, Germany       {break}
{it:and}          {break}
Department of Mathematics and Computer Science         {break}
University of Southern Denmark       {break}
haghish@imbi.uni-freiburg.de          {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 

