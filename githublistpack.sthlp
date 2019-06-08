{smcl}
{it:v. 1.0.0}


{title:githublistpack}

{p 4 4 2}
mines the GitHub API for Stata repositories


{title:Syntax}

{p 8 8 2} {bf:githublistpack} [ {it:keyword} ] [, {it:options} ]

{p 4 4 2}{bf:Options}

{col 5}{it:option}{col 20}{it:Description}
{space 4}{hline}
{col 5}language({it:str}){col 20}specifies the programming language of the repository. the default is {bf:Stata}
{col 5}in({it:str}){col 20}specifies the domain of the search which can be {bf:name}, {bf:description}, {bf:readme}, or {bf:all}
{col 5}all{col 20}shows repositories that lack the {bf:pkg} and {bf:stata.toc} files in the search results
{col 5}duration({it:num}){col 20}search time frame in number of days. the default is {bf:1}
{col 5}delay{col 20}number of miliseconds to let the API rest after each search. the default is 10000 ms
{col 5}save{col 20}saves the search results in a data set
{col 5}replace{col 20}replaces existing data set
{col 5}append{col 20}appends results to an existing data set
{col 5}created({it:str}){col 20}initial date for beginning of the search
{col 5}pushed({it:str}){col 20}initial pushing date of the repository, which is useful for updating the archive
{col 5}reference({it:str}){col 20}initial date. if missing, it is set to {bf:"2012.01.01"}
{col 5}perpage({it:num}){col 20}maximum number of returned results (check GitHub API limits)
{col 5}quite{col 20}avoids output log
{col 5}debug{col 20}detailed output log
{space 4}{hline}

{title:Description}

{p 4 4 2}
{bf:githublistpack} searches for repositories on GitHub within 
a limited time frame (i.e. {it:duration}). It can save and update
the results in a data set. It also provides options for 
narrowing down or expanding the search. 




{title:Examples}

{p 4 4 2}{bf:examples of mining Stata packages on packages }

{p 4 4 2}
list all GitHub repositories in Stata language 

        . githublistpack , language(Stata) append replace   ///
          save("repolist") duration(1) all in(all)          ///
					perpage(100)

{p 4 4 2}
search for repositories created from 2019 on    {break}

        . githublistpack , language(Stata) append replace   ///
          save("update") duration(1) all in(all)            ///
          reference("2019-01-01") perpage(100)


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
Department of Mathematics and Computer Science (IMADA)      {break}
University of Southern Denmark      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


