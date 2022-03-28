#' @title Get the Marvel creators
#' 
#' @description This function accesses the Marvel API, gets the list of creators, and returns them in a tidy dataframe. Alternatively, give a string name and return all information about that creator in a tidy format.
#' 
#' @param public_key A string pointing to your public Marvel API key
#' 
#' @param private_key A string pointing to your private Marvel API key
#' 
#' 

get_creators <- function(public_key = NULL, private_key = NULL, name = NULL) {
  
  # objects that do not change
  base <- "http://gateway.marvel.com/"
  endpoint <- "v1/public/creators"
  ts <- gsub(" ", "", gsub("-", "", gsub(":", "", Sys.time()))) # to prevent break in ts 
  hash <- digest::digest(paste0(ts, private_key, public_key), algo = "md5", serialize = FALSE) # SERIALIZE MUST BE FALSE TO CONNECT
  
  if (is.null(name)) {
    url <- httr::modify_url(url = base, path = endpoint, query = list(ts = ts, 
                                                                      apikey = public_key, 
                                                                      hash = hash))
  }
  
  resp <- httr::GET(url)
  
  # add in stops for bad codes
  
  
  #error code to stop if json is not returned. Will break once parsed if it isn't JSON
  
  if (http_type(resp) != "application/json") { 
     stop("API did not return json", call. = FALSE)
   }
  
   if (status_code(resp) == 401) {
     stop("Error 401: Invalid credentials. Please check your API keys.")
   }
  
   parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  
  return(parsed)
   
   # great, it's worked so far!
}
