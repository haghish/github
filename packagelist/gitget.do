
/***
Generating `gitget.dta` data set
================================

The `gitget` data set is used as a short-cut for installing Stata packages 
from the complete list of Stata repositories, stored in `packagelist.dta` data set.
In this document, I will create a subset of the installable repositories to be 
used by the `gitget` command
***/

use "packagelist.dta", clear
keep if installable == 1

saveold "gitget.dta", replace

*duplicates report name
*duplicates tag name, generate(tag)
*keep if tag > 0

/***
Duplicated package names
------------------------

There might be several installable Stata repositories with an identical 
repository name. If a package name is claimed in multiple repositories, 
a table is returned by their URL address and a possibility to install them 
with a mouse click. 
***/
