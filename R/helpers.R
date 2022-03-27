#' @title Save a Marvel API key to the \code{.Renviron} for future use. 
#' 
#' @description This function allows the user to save their Marvel API key securely in their 
#' \code{.Renviron} file. Only run this in the console, do not save in your script. 
#' 
#' @param key A string containing the 
#' 
#' @author Bethany Leap
#' 

marvel_api_key <- function(key, overwrite = FALSE, create = FALSE) {
  # checks here
  # code here
  # see {tidycensus} helpers.R documentation for further direction
}


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

marvel_api <- function(path) {
  url <- modify_url("https://gateway.marvel.com/", path = path)
  GET(url)
}


