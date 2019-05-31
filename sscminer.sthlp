{smcl}
{it:v. 1.0.0}


{title:Title}

{p 4 4 2}
{bf:sscminer} - mines and archives SSC packages based on their updates


{title:Syntax}

{p 8 8 2} {bf:sscminer} , {it:save(str)} [ {it:download} ]

{p 4 4 2}{bf:options}

{col 5}{it:option}{col 18}{it:Description}
{space 4}{hline}
{col 5}save({it:str}){col 18}specifies the name of the data set to include packages information
{col 5}download{col 18}downloads and archives SSC packages in zip files
{space 4}{hline}

{title:Description}

{p 4 4 2}
{bf:sscminer} mines packages on SSC server and summarizes them in a data set. 
it also list the files that are installable within each packages and categorizes 
them based on the Stata programming language they are using (ado, mata, dlg, etc.)

{p 4 4 2}
originally, the archive was developed for education purpose. 


{title:Examples}

{p 4 4 2}
mine Stata packages on SSC without downloading any package

        . sscminer, save("archive.dta")

{p 4 4 2}
mine stata packages and download the files

        . sscminer, save("archive.dta") download


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
Department of Mathematics and Computer Science (IMADA)      {break}
University of Southern Denmark      {break}

{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


