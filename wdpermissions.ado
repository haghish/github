program define wdpermissions
  capture quietly tempname myfile
  capture quietly file open `myfile' using githubpackagetestingwdpermissions, write replace
  if _rc != 0 {
    di as err "Writing permission is not granted for the current working directory" _n
    error 1
  } 
  else {
    global wdpermissions 1
    capture quietly file close `myfile'
    capture quietly rm githubpackagetestingwdpermissions
  }
end
