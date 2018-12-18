/***

Adding packages which are not primarily in Stata language, but are for Stata
============================================================================

Expected repositories
---------------------

***/

// expected repositories
githubsearch stata, language(all) in(all)  perpage(1) quiet


// mining stata-related repositories
githublistpack stata, language(all) append replace save("langlist")             ///
                 duration(1) all in(all) perpage(100)

//UPDATE					 
githublistpack stata, language(all) append replace save("update1")              ///
duration(1) all in(all) reference("2012-03-10") perpage(100)
