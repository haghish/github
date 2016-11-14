cap prog drop githubhit
prog githubhit
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) pushed(str) Number(numlist max=1)] 
	
	
	
	//before 2013 there were less than 100 packages
	*github search stata, language(stata) in(name) //created("<2013-02-01") in(all) all save("`tmp1'")
	
	githubsearch stata, created("<2014-11-01") language(stata) in(all) all save("__`save'")
	
	capture findfile "__`save'.dta"
	if _rc == 0 {
		quietly copy "__`save'.dta" "`save'.dta", replace
		cap erase __`save'.dta
	}
	
	use `save', clear
	githubsearch stata, created("2014-11-01..2015-09-01") language(stata) in(all) all save("__`save'")
	append using "`save'"
	
	githubsearch stata, created("2015-09-01..2016-03-01") language(stata) in(all) all save("__`save'")
	append using "`save'"
	
	githubsearch stata, created("2016-03-01..2016-08-01") language(stata) in(all) all save("__`save'")
	append using "`save'"
	
	githubsearch stata, created("2016-08-01..2016-11-01") language(stata) in(all) all save("__`save'")
	append using "`save'"
	
	*current date c(current_date)
	*append using "`tmp2'", clear
	*copy "`tmp2'" "mydata.dta", replace
	
	
	githublist stata, reference("2016-11-01") duration(30) language(stata) in(all) all  save("__`save'")
	append using "`save'"
	cap erase `"__`save'.dta"' 
	
	/*
	use __data1, clear
	save data, replace
	append using __data2
	append using __data3
	append using __data4
	append using __data5
	*/
	
end 

githubhit , save(hits) 
*use data, clear
