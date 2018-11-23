# `github` : a module for building, searching, and installing Stata packages from GitHub

<a href="http://github.com/haghish/github"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/github3.png" align="left" width="140" hspace="10" vspace="6"></a>

`github` is a Stata module for searching and installing Stata packages from GitHub, including previous releases of 
a package. It is a combination of several Stata commands such as `search`, `findit`, and `ssc`, but instead, made for managing Stata packages hosted on GitHub. In addition, the package provides new features for version control which are not available to Stata users elsewhere (for example, the package allows installing older releases of a Stata package to reproduce an analysis carried out with older software). 

Instalation
-----------

You can install the latest version of the `github` command by executing the following code:

```{js}
net install github, from("https://haghish.github.io/github/")
```

### Installing a package
To install a package, all you need is the GitHub username and the name of the repository. For example, 
to install [MarkDoc](https://github.com/haghish/MarkDoc) package, it is enough to type:

    github install haghish/markdoc

Not all packages are installable. Stata repositories must have __toc__ and __pkg__ files in order to be installable. You can check whether a package is installable or not using the `check` subcommand. The `search` subcommand automatically checks for this.

    github check haghish/markdoc

> <img src="https://github.com/haghish/markdoc/raw/master/Resources/images/attention.png" width="20px" height="20px"  align="left" hspace="0" vspace="0"> to make your repository installable, you need __packagename.pkg__ and __stata.toc__ files. The [__MarkDoc Package__](https://github.com/haghish/MarkDoc) can __automatically__ build these files for you, making your package ready to be installable from any platform. __`github`__ package provide an option named `force` that allows you to force install repositories which are not installable. However, the package still gives more credit to installable packages when using the __`github search`__ command. Therefore, by making your package installable, you will receive much more attention from Stata users on GitHub. Using [__MarkDoc Package__](https://github.com/haghish/MarkDoc) you can write the Stata help files using Markdown and build the __toc__ and __pkg__ files effortlessly. 

### Managing installed packages

`github` has a built-in database that keeps track of the packages installed on your machine, and of course, also tells you the versions of the packages. The version is taken from the release of the package that you are installing. You can `list` the installed packages and get helpful information about them, as well as update or uninstall them:

    github list

<center>
<a href="https://github.com/haghish/github/raw/master/images/list.png"><img src="https://github.com/haghish/github/raw/master/images/list.png"  width="550" hspace="10" vspace="6"></a>
</center>

### Uninstalling a package
To install a package, use the `uninstall` subcommand, followed by the package name. For example:

    github uninstall markdoc

### Installing package dependencies

let's assume you have written a Stata package that requiers other packages to work properly. You can include a `dependency.do` file in your repository to tell `github install` command that these dependencies are necessary. the package will execute this file in Stata after installing your package. You will have plenty of options. For example, you can write the code for installing the package. Or, alternatively, you can simply notify the user... In either case, you should know that the `dependency.do` will be executed after the package installation. 

### Searching for a Stata package
You can search GitHub for Stata package using a keyword or many keywords. This is similar to Stata's `search` or `findit` commands, but instead, only used for searching GitHub packages:

    github search weaver, in(all)
    
Searching GitHub API effectively is very important. For this, the package includes a search GUI that shows the syntax you can use to narrow down your search or expand it to include other sources. The search command also analyzes the release dates for packages hosted on the `net` command, which is a very useful feature. To launch the GUI, type:

    db github

<center>
<a href="https://github.com/haghish/github/raw/master/images/search.png"><img src="https://github.com/haghish/github/raw/master/images/search.png"  width="350" hspace="10" vspace="6"></a>
</center>

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


Searching for a package in Stata
--------------------------------

As mentioned earlier, the `github search` command can search GitHub API for a particular repository or a keyword. However, often Stata users wish to search other software hosts as well, e.g. stata.com or SSC. The `findall` command is a general search tool for searching Stata modules on GitHub, Stata Journal, Web, SSC, etc

`findall` not only provides more general results to the `search` command, but also, __it adds the date of the latest update of the module to the results obtained from SSC and GitHub__. 

```js
findall keyword
```




Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics   
  University of Freiburg, Germany      
  _[@Haghish](https://twitter.com/Haghish)_   
  

    





