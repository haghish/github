//this file is written for MarkDoc package

qui log using update, replace smcl


/***
Updating list of Stata repositories on GitHub
==============================================

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date. the `reference("yyyy-mm-dd")` in the example below 
shows the __last update__ made for the *packagelist.dta* dataset
***/

//OFF
timer clear 1
timer on 1
qui log off
githublistpack , language(Stata) append replace save("update")                  ///
                 duration(10) all in(all) reference("2018-12-04")
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
