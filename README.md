# Installing Stata packages from GitHub



`github` is a Stata module for installing Stata packages from GitHub, including previous releases of 
a package. You can install the latest version of the `github` command by executing the following code:

    net install github, replace from("https://raw.githubusercontent.com/haghish/github/master/")

### Installing a package
To install a package, all you need is the GitHub username and the name of the repository. For example, 
to install [MarkDoc](https://github.com/haghish/MarkDoc) package, it is enough to type:

    github install haghish/markdoc

### Package Versions
GitHub allows archiving unlimited number of package versions. The `github` command has an option for specifying 
the package version, allowing installing previous package versions. For example, for installing an older 
version of MarkDoc package, say `3.8.0`. you can type:

    github install haghish/MarkDoc , version("3.8.0")

### Package Dependencies
Some package rely on other packages. The `github` command allows you to install the package 
dependencies with the specified version. To do so:

1. create a file named `dependency.do` and include it in the repository
2. this file is not meant to be installed in the PLUS directory therefore it should not be mentioned in the 
pkg file (see below)
3. include the code for installing the package dependencies in this do file. If the packages 
are hosted on GitHub, use the `github` command for installing the package dependencies and 
specify the requiered version. 
4. `github` command looks for `dependency.do` after installing the package and if it finds it 
in the repository, it executes it. 
 

### Example of pkg file
The repository should include a file __with `.pkg` suffix and an identical name as the package name__. 
The name of the file doesn't have to be identical to the repository name, but it is strongly adviced 
to name the repository identical to the package name. Below is an example file 
of the [`github.pkg`](https://raw.githubusercontent.com/haghish/github/master/github.pkg) that is used for installing the package on your system.
Note that the files that are meant to be copied on your system begin with `F` (bottom of the file)

~~~
d 'GITHUB': module to install Stata packages and their dependencies from GitHub
d
d  github is a module for installing Stata packages with a particular
d  version as well as their dependencies from GitHub.
d
d KW: Version control
d KW: GitHub
d KW: Git
d KW: net
d
d Requires: Stata version 11 
d
d Distribution-Date: 20161103
d
d Author: E.F. Haghish, University of Southern Denmark
d Support: email haghish@imada.sdu.dk
d
F github.ado
F github.sthlp
F githubQuery.ado
~~~


Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics
  University of Freiburg, Germany      
  _haghish@imbi.uni-freiburg.de_     
  _http://www.haghish.com/weaver_  
  _[@Haghish](https://twitter.com/Haghish)_   
  

    





