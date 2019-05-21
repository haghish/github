/***
_v. 1.0.0_

Title
=====

__pkgzip__ - creates and downloads a Zip file from SSC and names it based on the package release date

Syntax
======

> __pkgzip__ _packagename_ 


Description
===========

__pkgzip__ downloads a package from SSC. t will also analyze the last release 
date of the package and creates a Zip file with the release date, to imply the 
version of the package. packages hosted on SSC do not have a version specified 
within the package description and instead, the release date is used to show 
package versions. 


Example(s)
=================
		
    download adoedit package from SSC, along with its version
        . pkgzip adoedit
		
		
Author
======

E. F. Haghish   
Department of Mathematics and Computer Science (IMADA)    
University of Southern Denmark    

- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/




*cap prog drop pkgzip
prog pkgzip

	syntax [anything]
	ssclastupdate `anything', download remove 	

end


