#' @title Allows user to set public and private API keys
#' 
#' @description Add public and private API keys to the user's R environment if necessary, otherwise no change is needed
#' 
#' @details 
#' 
#' @param
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export
#' 
#' @examples 
#' 
#' @section References:
#' Uses the {tidycensus} package, particularly the census_api_key() function, as guidance for creating this function

marvel_api_keys <- function (public_api_key,
                             overwrite = FALSE,
                             install = FALSE) {
  if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if (file.exists(renv)) {
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if (!file.exists(renv)) {
      file.create(renv)
    }
    else {
      if (isTRUE(overwrite)) {
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv = read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep("MARVEL_PUBLIC_API_KEY", 
                               oldenv), ]
        write.table(newenv, renv, quote = FALSE, sep = "\n", 
                    col.names = FALSE, row.names = FALSE)
      }
      else {
        tv <- readLines(renv)
        if (any(grepl("MARVEL_PUBLIC_API_KEY", tv))) {
          stop("A MARVEL_PUBLIC_API_KEY already exists. You can overwrite it with the argument overwrite=TRUE", 
               call. = FALSE)
        }
      }
    }
    public_api_keyconcat <- paste0("MARVEL_PUBLIC_API_KEY='", public_api_key, "'")
    write(public_api_keyconcat, renv, sep = "\n", append = TRUE)
    message("Your API key has been stored in your .Renviron and can be accessed by Sys.getenv(\"MARVEL_PUBLIC_API_KEY\"). \nTo use now, restart R or run `readRenviron(\"~/.Renviron\")`")
    return(public_api_key)
  }
  else {
    message("To install your API key for use in future sessions, run this function with `install = TRUE`.")
    Sys.setenv(MARVEL_PUBLIC_API_KEY = public_api_key)
  }
}