{smcl}
{right:version 1.0.0}
{title:Title}

{phang}
{cmd:github} {hline 2} installs Stata packages with a particular version (release) as well as their dependencies from 
 {browse "http://www.github.com/haghish/githubinstall":GitHub} 
 

{title:Syntax}

{p 8 16 2}
{cmd: github} [ {bf:install} | {bf:query} ] {it:username}{bf:/}{it:repository} [{cmd:,} version(str) {it:replace force}]
{p_end}

{* the new Stata help format of putting detail before generality}{...}
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt v:ersion}}specifies a particular version (release tags){p_end}
{synopt:{opt replace}}specifies that the downloaded files replace existing files 
if any of the files already exists{p_end}
{synopt:{opt force}}specifies that the downloaded files replace existing files 
if any of the files already exists, even if Stata thinks all the files are the same.
force implies {bf:replace}.{p_end}
{synoptline}
{p2colreset}{...}

{p 4 4 2}
The {bf:install} subcommand installs the package and its dependencies (if specified) 
and the {bf:query} subcommand lists the previous versions (releases) of the 
package. 


{title:Description}

{p 4 4 2}
{bf:github} simplifies installing Stata packages from 
{browse "http://www.github.com/":GitHub} website. The package also allows installing 
older releaes of the package using the {bf:version()} option, a feature that 
improves reproducibility of analyses carried out by user-written packages. 
Packages installed by {bf:github} command can also automatically install the 
package dependencies. 

{p 4 4 2}
For example, the {browse "https://github.com/haghish/MarkDoc":MarkDoc} package 
requires two other Stata packages which are 
{browse "https://github.com/haghish/weaver":Weaver} and
{browse "https://github.com/haghish/MarkDoc":Statax}. 
Usually, users have to install these packages manually after installing 
MarkDoc from GitHub or SSC. However, the {bf:github install} command will look 
for a file named {bf:dependency.do} and executes this file if its exists. 
Package developers can simply {bf:write the code required for installing the} 
{bf:dependencies in this file} to take care of the dependencies automatically. 


{title:Example(s)}

    install the latest version of MarkDoc package from GitHub
        . github install haghish/markdoc, replace

    install MarkDoc version 3.8.1 from GitHub (older version)
        . github haghish/markdoc, replace version("3.8.1")

    list all of the available versions of the MarkDoc package
        . github query haghish/markdoc


{title:Acknowledgements}

{p 4 4 2}
If you have thanks specific to this command, put them here.


{title:Author}

{p 4 4 2}
E. F. Haghish     {break}
Department of Mathematics and Computer Science (IMADA)      {break}
University of Southern Denmark      {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 

