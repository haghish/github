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
    json = tryCatch(
      {
        fromJSON(URL)
      },
      error=function(cond) {
        message(cond)
        cat("\n")
        return(NULL)
      }
    )
    
    # repeate a loop to examin the API 60 times
    # ---------------------------------------
    if (is.null(json)) loop = 1
    else loop = 0

    
    N = 1
    while(loop == 1) {
      Sys.sleep(10)
      warning("API error. wait a few seconds")
      if (N >= 60) {
        loop = 0
        print(paste(address, "seems to have a vital problem"))
      }
      
      json = tryCatch(
        {
          fromJSON(URL)
        },
        error=function(cond) {
          message(cond)
          cat("\n")
          return(NULL)
        }
      )
      if (is.null(json)) loop = 1
      else loop = 0
      
      N = N + 1
    } 
    
    if (!is.null(json)) {
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


