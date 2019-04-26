# rcall uses tryCatch for for the same reason, it seems like it cannot 
# handle errors if the sourced programs use tryCatch as well. However, 
# updating the cide to use try() seems to solve the problem. 

githubunique = function(df) {
  
  warning("This might take a long time tp complete...")
  
  # required libraries
  library(jsonlite)
  
  # variables
  data = NULL
  
  for (i in 1:nrow(df)) {
    loop = 0
    address = df$address[i]
    URL = paste0("https://api.github.com/search/code?q=extension:pkg+repo:",
                 address)
    cat("\n")
    message(paste0(i,".  ", URL))
    json = NULL
    json = try(fromJSON(URL))
    
    # repeate a loop to examin the API 60 times
    # ---------------------------------------
    if (class(json)=="try-error") loop = 1
    else loop = 0
    
    
    N = 1
    while(loop == 1) {
      Sys.sleep(10)
      message("API error. wait a few seconds")
      if (N >= 60) {
        loop = 0
        message(paste(address, "seems to have a vital problem"))
      }
      
      json = try(fromJSON(URL))
      
      if (class(json)=="try-error") loop = 1
      else loop = 0
      
      N = N + 1
    } 
    
    if (class(json) == "list") {
      json = as.data.frame(json[['items']][c("name","path")])
      if (ncol(json) > 0) {
        json$address = address
      } else {
        json = data.frame(name=NA, path=NA, address=address)
      }
      print(json)
      data = rbind(data, json)
    }
    Sys.sleep(2)
  }
  return(data)
}


