#' @title Allows user to set public and private API keys
#'
#' @description Allows user to easily set their public and private API keys for the Marvel API. Function allows the user to either set these keys for the current R session (in which case this function will need to be used every session in which the user wants to use this package) or add these keys to their R environment (the .Renviron file) in which case they would not need to use this function more than once or in future R sessions. Adding these keys to the .Renviron file allows the user to use other functions in this package without having their API keys exposed anywhere in their code. If the user does not have a .Renviron file, then this function creates a .Renviron file for them. If the user does have the file, this function will add these keys to the file and make a backup of the original file.
#'
#' @param public_api_key The public API key for the Marvel API, formatted in quotes (""). You can obtain a key from https://developer.marvel.com/account.
#' @param private_api_key The private API key for the Marvel API, formatted in quotes (""). You can obtain a key from https://developer.marvel.com/account.
#' @param overwrite If TRUE, overwrite the existing MARVEL_PUBLIC_API_KEY and MARVEL_PRIVATE_API_KEY in your .Renviron file, if FALSE (default), do not.
#' @param install If TRUE, install the key in your .Renviron file to be used in future sessions, if FALSE (default), do not.
#'
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#'
#' @export
#'
#' @examples
#'
#'  \dontrun{
#' marvel_api_keys(public_api_key = "abcd1234",
#'                 private_api_key = "efgh5678",
#'                 overwrite = TRUE,
#'                 install = TRUE)
#'                 }
#'
#' @section References:
#' Used the {tidycensus} package, particularly the census_api_key() function, as a framework for creating this function.
marvel_api_keys <- function (public_api_key,
                             private_api_key,
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
        oldenv = utils::read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep("MARVEL_PUBLIC_API_KEY", # newenv table is oldenv table minus lines that include MARVEL_PUBLIC_API_KEY or MARVEL_PRIVATE_API_KEY
                               "MARVEL_PRIVATE_API_KEY",
                               oldenv), ]
        utils::write.table(newenv, renv, quote = FALSE, sep = "\n",
                    col.names = FALSE, row.names = FALSE)
      }
      else {
        tv <- readLines(renv)
        if (any(grepl("MARVEL_PUBLIC_API_KEY", tv)) & any(grepl("MARVEL_PRIVATE_API_KEY", tv))) {
          stop("A MARVEL_PUBLIC_API_KEY and a MARVEL_PRIVATE_API_KEY already exist. You can overwrite them with the argument overwrite=TRUE",
               call. = FALSE)
        } else if (any(grepl("MARVEL_PUBLIC_API_KEY", tv))) {
          stop("A MARVEL_PUBLIC_API_KEY already exists. You can overwrite it with the argument overwrite=TRUE",
               call. = FALSE)
        } else if (any(grepl("MARVEL_PRIVATE_API_KEY", tv))) {
          stop("A MARVEL_PRIVATE_API_KEY already exists. You can overwrite it with the argument overwrite=TRUE",
               call. = FALSE)
        }
      }
    }
    public_api_keyconcat <- paste0("MARVEL_PUBLIC_API_KEY='", public_api_key, "'")
    private_api_keyconcat <- paste0("MARVEL_PRIVATE_API_KEY='", private_api_key, "'")
    write(public_api_keyconcat, renv, sep = "\n", append = TRUE)
    write(private_api_keyconcat, renv, sep = "\n", append = TRUE)
    message("Your API keys have been stored in your .Renviron and can be accessed by Sys.getenv(\"MARVEL_PUBLIC_API_KEY\") and Sys.getenv(\"MARVEL_PRIVATE_API_KEY\"). \nTo use now, restart R or run `readRenviron(\"~/.Renviron\")`")
    return(public_api_key)
  }
  else {
    message("To install your API keys for use in future sessions, run this function with `install = TRUE`.")
    Sys.setenv(MARVEL_PUBLIC_API_KEY = public_api_key)
    Sys.setenv(MARVEL_PRIVATE_API_KEY = private_api_key)
  }
}
