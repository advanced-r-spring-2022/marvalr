#' @title Get tibble of creators information from Marvel API
#' 
#' @description Get tibble containing information related to creators through the Marvel API based on user input criteria.
#' 
#' @param limit The requested result limit defaulted to 100
#' @param offset The requested number of skipped results of the call.
#' @param comic A Marvel comic issue, collection, graphic novel, or digital comic
#' @param event A big, universe-changing storyline
#' @param series Sequentially numbered list of comics with the same title and volume
#' @param story Indivisible components of comics
#' 
#' 
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_creators
#' 
#' @examples 
#' get_creators(limit = 50,
#'                 offset = 0,
#'                 comic = TRUE,
#'                 install = TRUE)
#' 
.

get_creators <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comicID = NULL, # default comicID should be NULL
                           eventID = NULL, # default eventID should be NULL
                           seriesID = NULL, # default seriesID should be NULL
                           storyID = NULL) { # default storyID should be NULL
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get priv key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 3 (if 1 entered) or 4 (if none entered)
  
  if(sum(is.null(comicID),
         is.null(eventID),
         is.null(seriesID),
         is.null(storyID)) <3) {
    stop("Please choose to enter an argument for only one of comic, event, series, or story.")
  }
  
  # should be a whole number if entered
  
  if(sum(is.null(comicID),
         is.null(eventID),
         is.null(seriesID),
         is.null(storyID)) <3) {
    stop("Please choose to enter an argument for only one of comic, event, series, or story.")
  }
  
  stopifnot((is.null(comicID)) | (is.numeric(comicID) & comicID %% 1 == 0))
  stopifnot((is.null(eventID)) | (is.numeric(eventID) & eventID %% 1 == 0))
  stopifnot((is.null(seriesID)) | (is.numeric(seriesID) & seriesID %% 1 == 0))
  stopifnot((is.null(storyID)) | (is.numeric(storyID) & storyID %% 1 == 0))
  
  # timestamp, hash, and url
  ts <- round(as.numeric(Sys.time())*1000) 
  to_hash <- sprintf("%s%s%s",
                     ts,
                     marvel_private_api_key,
                     marvel_public_api_key)
  hash <- digest::digest(to_hash, "md5", FALSE)
  
  base_url <- "https://gateway.marvel.com/v1/public/" # base url
  
  if (!is.null(comicID)) { # if user enters comicID
    creators_base_url <- paste0(base_url, "comics/", comicID, "/creators")
  } else if (!is.null(eventID)) { # if user enters eventID
    characters_base_url <- paste0(base_url, "events/", eventID, "/creators")
  } else if (!is.null(seriesID)) { # if user enters seriesID
    characters_base_url <- paste0(base_url, "series/", seriesID, "/creators")
  } else if (!is.null(storyID)) { # if user enters storyID
    characters_base_url <- paste0(base_url, "stories/", storyID, "/creators")
  } else { # if user doesnt enter any ids
    creators_base_url <- paste0(base_url, "creators")
  }
  
  httr::modify_url(url = creators_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    creators_url
  
  GET_creators <- httr::GET(creators_url) # GET the url
  stopifnot(httr::status_code(GET_creators) == 200) # stop if error code
  # turn into a tidy dataframe
  content_creators <- httr::content(GET_creators) # retrieve contents of req
  tibble_creators <- tibble::tibble(content_creators) # turn into tibble
  unnest1_creators <- tidyr::unnest(data = tibble_creators[7,1],
                                      cols = content_creators) # unnest
  unnest2_creators <- tidyr::unnest(unnest1_creators[5,1],
                                      cols = content_creators) # unnest
  unnest3_creators <- tidyr::unnest_wider(data = unnest2_creators,
                                            col = content_creators) # gets df
  
  return(unnest3_creators) # return dataframe to user
  
}