> __Cite__: Haghish, E. F. (2020). Developing, maintaining, and hosting Stata statistical software on GitHub. The Stata Journal, 20(4), 931-951.

# GITHUB : a module for building, searching, installing, and managing Stata packages from GitHub

<a href="http://github.com/haghish/github"><img src="https://github.com/haghish/markdoc/raw/master/Resources/images/github3.png" align="left" width="140" hspace="10" vspace="6"></a>

`github` is a Stata module for searching and installing Stata packages from GitHub, including previous releases of
a package. It is a combination of several Stata commands such as `search`, `findit`, and `ssc`, but instead, made for managing Stata packages hosted on GitHub. In addition, the package provides new features for version control which are not available to Stata users elsewhere (for example, the package allows installing older releases of a Stata package to reproduce an analysis carried out with older software).

<br>

<img src="./images/news.png" width="140px" height="140px"  align="left" hspace="10" vspace="6">**NEWS**: Introducing `gitget` command. `gitget` further simplifies installing and updating a package. it provides a database for [all existing Stata packages on GitHub](https://github.com/haghish/github/blob/master/gitget.md), which allows you to install a package that is hosted on GitHub - and is known by `gitget`, simply by typing:

    gitget packagename

<img src="./images/white.png" width="140px" height="140px"  align="left" hspace="10" vspace="6">The `gitget` command relies on a complete list of Stata packages on GitHub to identify the URL of a project. This list is created programmatically using a search program that detects Stata packages. First, all of the Stata repositories are identified and stored in *[repolist.dta](https://github.com/haghish/github/blob/master/repolist.dta)*. Next, the installable packages are extracted and stored in *[gitget.dta](https://github.com/haghish/github/blob/master/gitget.dta)* which also is installed with the package on your machine. [**The complete list of the archive is also available for preview within this repository**](https://github.com/haghish/github/blob/master/gitget.md)

<br>
<br>

__Table of Contents__  
1. [Introduction](#1-introduction)
2. [Installation](#2-installing-github-module)
3. [Syntax](#3-syntax)
4. [Subcommands](#4-subcommands)
    1. [Installing a package](#41-installing-a-package) 
    2. [Searching for a Stata package](#42-searching-for-a-stata-package) 
    3. [Managing installed packages](#43-managing-installed-packages) 
    4. [Checking a Stata repository](#44-checking-a-stata-repository) 
    5. [Uninstalling a package](#45-uninstalling-a-package) 
    6. [Package Versions](#46-package-versions) 
        1. [Installing a particular version](#461-installing-a-particular-version)
        2. [Listing all previous releases](#462-listing-all-previous-releases)
        3. [Getting the version of an installed package](#463-getting-the-version-of-an-installed-package) 
    7. [Package dependencies](#47-package-dependencies) 
    8. [Searching for a file in Stata packages](#48-searching-for-a-package-file) 
5. [Building package installation files automatically](#5-building-package-installation-files-automatically) 
6. [List of Stata Packages Recognized by `gitget` command](#6-list-of-stata-packages-recognized-by-gitget-command) 

# 1. Introduction

In the recent years, Stata users have been increasingly using GitHub for sharing Stata code and datasets, developing statistical software, and hosting Stata packages, as shown in the figure below. This is indeed a good news for the Stata community and anyone promoting research transparency! The `github` module, facilitates searching, installing, managing, and even building Stata packages. Furthermore, it allows installing development version or alternatively, stable releases of a package. It also allows specifying package dependencies that will be installed automatically, making GitHub even more appealing for Stata users and developers. Here, I quickly show you how to install and use the `github` package.

<center>
<a href="https://github.com/haghish/github/raw/master/images/combined.png"><img src="https://github.com/haghish/github/raw/master/images/combined.png"  width="650"></a>
</center>

<br>

# 2. Installing `github` module

You can install the latest version of the `github` command by executing the following code:

```{js}
net install github, from("https://haghish.github.io/github/")
```

# 3. Syntax

The general syntax of the package can be summarized as:

    github [subcommand] [...]

Where the [*subcommand*] can be:

| Subcommand   | Description                                                 |
|--------------|-------------------------------------------------------------|
| `search`     | finds a Stata package on GitHub                             |
| `findfile`   | searches for a filee among all Stata packages on GitHub     |
| `install`    | installs a package from GitHub                              |
| `list`       | provides information about packages installed with `github` |
| `query`      | lists all previous releases of a packag                     |
| `check`      | tests whether a repository is installable                   |
| `uninstall`  | removes a package from Stata                                |
| `update`     | updates a package from GitHub                               |
| `version`    | returns the version of an installed package                 |

and the [*...*] can be whether *username/repository* or *packagename* based on the specified subcommand.

# 4. Subcommands

## 4.1 Installing a package
To install a package, all you need is the GitHub username and the name of the repository. The combination of username and repository name - seperated by a slash - provides the needed URL to the repository.  For example,
to install [MarkDoc](https://github.com/haghish/markdoc) package, which is hosted on <https://github.com/haghish/markdoc>, it is enough to type:

    github install haghish/markdoc [, stable version("")]

The `github` package includes a database for the complete list of Stata packages hosted on GitHub. Therefore, you can also install a package just by specifying the package name. The __`gitget`__ command - which is a wrapper for `github install` - can install or update Stata packages from GitHub only by asking the package name:

    gitget packagename [, stable version("")]

For example, if you wish to install `markdoc` package, typing `gitget markdoc` would be as goo as typing `github install haghish/markdoc`. If you wish to inspect the list of Stata packages hosted on GitHub, see the *[gitget.dta](https://github.com/haghish/github/blob/master/gitget.dta)* data set.

| Options      | Description                                                 |
|--------------|-------------------------------------------------------------|
| `stable`     | installs the latest stable release version of the package   |
| `version(str)`| installs the specified release version                     |


## 4.2 Searching for a Stata package
You can search GitHub for Stata package using a keyword or many keywords. This is similar to Stata's `search` or `findit` commands, but instead, only used for searching GitHub packages:

    github search weaver

Searching GitHub API effectively is very important. For this, the package includes a search GUI that shows the syntax you can use to narrow down your search or expand it to include other sources. The search command also analyzes the release dates for packages hosted on the `net` command, which is a very useful feature. To launch the GUI, type:

    db github

<center>
<a href="https://github.com/haghish/github/raw/master/images/search.png"><img src="https://github.com/haghish/github/raw/master/images/search.png"  width="400" hspace="10" vspace="6"></a>
</center>

For example, if you use the `github search` command to search for `markdoc` package, you get the following output:

<center>
<a href="https://github.com/haghish/github/raw/master/images/example.png"><img src="https://github.com/haghish/github/raw/master/images/example.png"  width="650" hspace="10" vspace="6"></a>
</center>

## 4.3 Managing installed packages

`github` has a built-in database that keeps track of the packages installed on your machine, and of course, also tells you the versions of the packages installed on the machine. The version is taken from the unique release tags of the package, specified by the developer. You can `list` the installed packages and get helpful information about them. **This command also notifies you if there is an available update for any of your GitHub packages**. For example, in the output below, we know that there are updates available for two of our packages. we can also click on the `(update)` link to update the package to the latest release.

    . github list

<center>
<a href="https://github.com/haghish/github/raw/master/images/list.png"><img src="https://github.com/haghish/github/raw/master/images/list.png"  width="650" hspace="10" vspace="6"></a>
</center>

## 4.4 Checking a Stata repository

Not all packages are installable. Stata repositories must have __toc__ and __pkg__ files in order to be installable. You can check whether a package is installable or not using the `check` subcommand.

    github check haghish/markdoc



> <img src="https://github.com/haghish/markdoc/raw/master/Resources/images/attention.png" width="20px" height="20px"  align="left" hspace="0" vspace="0">This is rather important point to pay attention to because the `github search` command that is used for searching Stata packages on GitHub, tends to dismiss Stata repositories that are not installable. In other words, if your repository does not include these files, it will not be considered a Stata package, unless you specify the option `all` in your search (in the search GUI check the **show GitHub repositories that are not installable** option). However, the `github` package also includes a GUI for building these files. Using the GUI that comes with `github`, you can easily build these files for your repository (see below).



## 4.5 Uninstalling a package
To install a package, use the `uninstall` subcommand, followed by the package name. For example:

    github uninstall markdoc





## 4.6 Package versions

### 4.6.1 Installing a particular version
GitHub allows archiving unlimited number of package versions. The `github` command has an option for specifying
the package version, allowing installing previous package versions. For example, for installing an older
version of MarkDoc package, say `3.8.0`. you can type:

    github install haghish/markdoc , version("3.8.0")

### 4.6.2 Listing all previous releases
But were can you see the package versions? GitHub has a ___release___ tab that lists all of the previous releases of the software ([__See for example the previous releases of MarkDoc__](https://github.com/haghish/markdoc/releases)). But the good news is that `github` has a subcommand for listing all of the previous releases in Stata results windows and allows you to install any of them (_as well as their package dependencies for that particular version, if specified_) with a single mouse click or programmatically. To do so, type:

    github query username/repository

For example, to list [__MarkDoc__](https://github.com/haghish/markdoc/releases)'s previous releases, type:

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
### 4.6.3 Getting the version of an installed package

When writing an analysis with a dynamic documentation software, such as [**MarkDoc**](https://github.com/haghish/markdoc), you should report the version of the packages that use are using in your analysis. You can obtain the version of an installed package programmatically using the `version` subcommand, followed by the :

~~~
. github version markdoc
3.8.0
~~~

This command does not have any other uses because the `github list` command already shows the version of the installed packages and also checks whether there is a newer version of them available...

## 4.7 Package dependencies
Some packages rely on other packages. The `github` command allows you to install the package
dependencies with or without a specific version. To do so:

1. create a file named `dependency.do` and include it in the repository
2. this file is not meant to be installed in the PLUS directory therefore it should not be mentioned in the
pkg file, when you are building the package (see below)
3. include the code for installing the package dependencies in this do file. If the packages
are hosted on GitHub, use the `github` command for installing the package dependencies and
even specify the requiered version.
4. `github` command looks for `dependency.do` after installing the package and if it finds it
in the repository, it executes it.

For example, [__MarkDoc package has a `dependency.do` file__](https://raw.githubusercontent.com/haghish/MarkDoc/master/dependency.do) that can serve as an example how the dependency file should be created. Naturally, the `dependenc.do` file is only executable by __`github install`__ command.

## 4.8 Searching for a package file

The `github` package includes a database of all files that are installed within packages hosted on GitHub. This is an important feature for the developers to avoid creating a file with a name used by another developer because such packages cannot be installed together on the same system (the problem also exists for _program name_). The `github` package allows developers to check whether a particular name has been used in a package before. 

The `findfile` subcommand searches the `githubfiles.dta` (installed with the package) and if found, it points out the repository that includes the file. For example, searching for files that have the keyword "dy" will result in:

~~~
. github findfile dy

 ---------------------------------
  Searching githubfiles database
 ---------------------------------
  dynpandoc.ado
  dynpandoc.sthlp
  dynamicPage1.mata
 ---------------------------------
~~~

These files also include the link to their repositories, if you click on them on the results window.

# 5. Building package installation files automatically

Imagine you have created an ado-file and Stata help files. How do you make your repository installable? You need to create a *stata.toc* and a *packagename.pkg* files manually, specify the required information, files that should be installed, etc. The `
github` package introduces the `make` GUI that generates the package installations for you, using a strict layout. You can just select the files that you wish to install, specify the required information, and have your *toc* and *pkg* files ready. Then, as soon as you copy these files to your repository, it would be installable!

Change the working directory to the repository path and then run the GUI, typing:

    db make

<center>
<a href="https://github.com/haghish/github/raw/master/images/make.png"><img src="https://github.com/haghish/github/raw/master/images/make.png"  width="450" hspace="10" vspace="6"></a>
</center>

write down the required information and select the files that should be installed. Press OK, and enjoy!

# 6. List of Stata Packages Recognized by `gitget` command

The `gitget` data set is downloaded along with `github` package. This data set is updated monthly. [Click here to see the complete list of __`gitget`__ packages](https://github.com/haghish/github/blob/master/gitget.md).


Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics   
  University of Freiburg, Germany      
  _[@Haghish](https://twitter.com/Haghish)_   
