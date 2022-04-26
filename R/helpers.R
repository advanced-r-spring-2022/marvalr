#' @title Access the base point for the Marvel API
#' 
#' @description This is the base function for accessing the Marvel API base point. It is the foundation of all functions in the package.
#' 
#' @param path the end point
#' 
#' @author Bethany Leap
#' 
#' 
#' @noRd # make this internal function

marvel_api <- function(path, public_key, private_key) {
  
  # stop if no key
  if (is.null(public_key) | is.null(private_key)){
    stop("Please provide public AND private API keys to access the Marvel API.")
  }
  
  url <- modify_url("https://gateway.marvel.com/", path = path, 
                    query = list(apikey = public_key, 
                                 ts = Sys.time(), 
                                 hash = digest::digest(paste(ts, private_key, public_key), algo = "md5")))
  GET(url)
}


