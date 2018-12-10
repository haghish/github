//this file is written for MarkDoc package

qui log using packagelist, replace smcl


/***
Updating list of Stata repositories on GitHub
==============================================

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date
***/


//OFF
qui log off
timer clear 1
timer on 1
githublistpack , language(Stata) append replace save("packagelist")             ///
                 duration(10) all in(all) 
timer off 1
qui log on
//ON

/***
Execution time
--------------

***/

timer list 1

txt "there are " _N " obserbations in the data set"



qui log c
