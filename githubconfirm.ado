
program githubconfirm, rclass

	syntax anything
	tempfile api 
	
	capture quietly copy "https://raw.githubusercontent.com/`anything'/master/stata.toc" `api', replace
	if _rc == 0 {
		return local installable 1
		di as txt `"{bf:{browse "http://github.com/`anything'":`anything'}} is installable"'
	}
	else {
		return local installable 0
		di as err `"{bf:{browse "http://github.com/`anything'":`anything'}} is not installable"'
	}
	
end

