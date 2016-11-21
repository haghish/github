# Installing Stata packages from GitHub


---
__NOTE__: to make your repository installable, you need __packagename.pkg__ and __stata.toc__ files. The [__MarkDoc Package__](https://github.com/haghish/MarkDoc) can __automatically__ build these files for you, making your package ready to be installable from any platform. I strongly recommend you to use __MarkDoc__ for writing your package documentation (sthlp) files and creating the __pkg__ and __toc__ files, because the package updates all of these files automatically. It is noteworthy that there are many Stata modules on GitHub which are not installable. Make sure your repository won't be one of them! It is noteworthy that the __`github`__ package favores repositories that are installable. Therefore, by making your package installable, you will receive much more attention from Stata users on GitHub. 

---


`github` is a Stata module for installing Stata packages from GitHub, including previous releases of 
a package. You can install the latest version of the `github` command by executing the following code:

```{js}
net install github, from("https://haghish.github.io/github/")
```

### Installing a package
To install a package, all you need is the GitHub username and the name of the repository. For example, 
to install [MarkDoc](https://github.com/haghish/MarkDoc) package, it is enough to type:

    github install haghish/markdoc

Not all packages are installable. Stata repositories must have __toc__ and __pkg__ files in order to be installable. You can check whether a package is installable or not using the `check` subcommand. The `search` subcommand automatically checks for this.

    github check haghish/markdoc

### Uninstalling a package
To install a package, use the `uninstall` subcommand, followed by the package name. For example:

    github uninstall markdoc

to uninstall __`github`__ package itself, type:

    ado uninstall github

### Searching for a Stata package
You can search GitHub for Stata package using a keyword. Read the help file for more information

    github search weaver, in(all)

### Package Versions
GitHub allows archiving unlimited number of package versions. The `github` command has an option for specifying 
the package version, allowing installing previous package versions. For example, for installing an older 
version of MarkDoc package, say `3.8.0`. you can type:

    github install haghish/MarkDoc , version("3.8.0")

But were can you see the package versions? GitHub has a ___release___ tab that lists all of the previous releases of the software ([__See for example the previous releases of MarkDoc__](https://github.com/haghish/MarkDoc/releases)). But the good news is that `github` has a subcommand for listing all of the previous releases in Stata results windows and allows you to install any of them (_as well as their package dependencies for that particular version, if specified_) with a single mouse click or programmatically. To do so, type:

    github query username/repository

For example, to list [__MarkDoc__](https://github.com/haghish/MarkDoc/releases)'s previous releases, type:

```
. github query haghish/markdoc

 ----------------------------------------
  Version      Release Date      Install 
 ----------------------------------------
  3.8.5        2016-10-16        Install
  3.8.4        2016-10-13        Install
  3.8.3        2016-10-03        Install
  3.8.2        2016-10-01        Install
  3.8.1        2016-09-29        Install
  3.8.0        2016-09-24        Install
  3.7.9        2016-09-20        Install
  3.7.8        2016-09-19        Install
  3.7.7        2016-09-18        Install
  3.7.6        2016-09-13        Install
  3.7.5        2016-09-08        Install
  3.7.4        2016-09-07        Install
  3.7.3        2016-09-06        Install
  3.7.2        2016-09-05        Install
  3.7.0        2016-08-23        Install
  3.6.9        2016-08-16        Install
  3.6.7        2016-02-27        Install
 ----------------------------------------
```

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

For example, [__MarkDoc package has a `dependency.do` file__](https://raw.githubusercontent.com/haghish/MarkDoc/master/dependency.do) that can serve as an example how the dependency file should be created. Naturally, the `dependenc.do` file is only executable by __`github install`__ command.
 

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
  

    





