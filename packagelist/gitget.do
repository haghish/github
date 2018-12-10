/***
Generating `gitget.dta` data set
============================================================

The `gitget` data set is used as a short-cut for installing Stata packages 
from the complete list of Stata repositories, stored in `packagelist.dta` data set.
In this document, I will create a subset of the installable repositories to be 
used by the `gitget` command
***/

use "packagelist.dta", clear
keep if installable == 1

saveold "gitget.dta", replace
