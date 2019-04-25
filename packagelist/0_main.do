/*
This file executes the script files to mine GitHub for Stata packages. In 
addition to the github package, you also need the following packages:

     github install haghish/markdoc, stable
		 github install haghish/rcall
		 ssc install sdecode

make sure your _rcall_ package is connected to R. For more information, visit
https://github.com/haghish/rcall

before runing the code below, save the files on your hard drive, place them in 
a directory, and change your working directory to the specified directory
*/



// Creating  acomplete list of Stata repositories
markdoc "1_list.do" , mini export(html) replace statax master style("simple")
