
program githubdependency, rclass

	syntax anything
	tempfile api 
	
	capture quietly copy "https://raw.githubusercontent.com/`anything'/master/dependency.do" `api', replace
	if _rc == 0 {
		return local dependency 1
		di as txt `"{bf:{browse "http://github.com/`anything'":`anything'}} includes dependencies"'
	}
	else {
		return local dependency 0
		di as err `"{bf:{browse "http://github.com/`anything'":`anything'}} does not includes dependencies"'
	}
	
end


