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
<a href="https://github.com/haghish/github/raw/master/images/list.png"><img src="https://github.com/haghish/github/raw/master/images/list.png"  width="650" hspace="10" vspace="6"></a>
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
<a href="https://github.com/haghish/github/raw/master/images/search.png"><img src="https://github.com/haghish/github/raw/master/images/search.png"  width="400" hspace="10" vspace="6"></a>
</center>

For example, if you use the `github search` command to search for `markdoc` package, you get the following output:

<center>
<a href="https://github.com/haghish/github/raw/master/images/example.png"><img src="https://github.com/haghish/github/raw/master/images/example.png"  width="650" hspace="10" vspace="6"></a>
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
Imagine you have created an ado-file and Stata help files. How do you make your repository installable? You need to create a *stata.toc* aand a *packagename.pkg* files manually, specify the required information, files that should be installed, etc. The `
github` package introduces the `make` GUI that generates the package installations for you in a stricted way. You can just select the files that you wish to install, specify the required information, and have your *toc* and *pkg* files ready. Then, as soon as you copy these files to your repository, it would be installable! To run the GUI, type:

    db make
 
<center>
<a href="https://github.com/haghish/github/raw/master/images/make.png"><img src="https://github.com/haghish/github/raw/master/images/make.png"  width="450" hspace="10" vspace="6"></a>
</center>

Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics   
  University of Freiburg, Germany      
  _[@Haghish](https://twitter.com/Haghish)_   
  

    





