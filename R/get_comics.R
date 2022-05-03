#' @title Get tibble of comics information from Marvel API
#' 
#' @description Get tibble containing information related to comics through the Marvel API based on user input criteria.
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (defaulted to 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param creator A character vector. A person or entity that make comics.
#' @param event A character vector. A big, universe-changing storyline
#' @param series A character vector. Sequentially numbered list of comics with the same title and volume
#' 
#' 
#' 
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_comics
#' 
#' @examples 
#' 
#' get_comics(limit = 50,
#'                 offset = 0,
#'                 series = "Eternals (1976 - 1978)")
#'                 
#'                 
#' get_comics(event = "Civil War") 


get_comics <- function(limit = 100, # default limit should be 100
                         offset = 0, # how many results to offset by
                         creator = NULL, # default comicID should be NULL
                         event = NULL, # default eventID should be NULL
                         series = NULL # default seriesID should be NULL
                         ) { 
  
  
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get priv key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 2 (if 1 entered) or 3 (if none entered)
  
  if(sum(is.null(creator),
         is.null(event),
         is.null(series)) < 2) {
    stop("Please choose to enter an argument for only one of comic, event, or series.")
  }
  
  # entries for arguments should be characters/strings
  
  if(!is.null(creator) & !is.character(creator)) {
    stop("Creator must be entered as string/characters. Ex. \"Jeff Youngquist\"")
  }
  
  if(!is.null(event) & !is.character(event)) {
    stop("Comic must be entered as string/characters. Ex. \"Civil War\"")
  }
  
  if(!is.null(series) & !is.character(series)) {
    stop("Comic must be entered as string/characters. Ex. \"Eternals\"")
  }
  
  
  
  # timestamp, hash, and url
  ts <- round(as.numeric(Sys.time())*1000) 
  to_hash <- sprintf("%s%s%s",
                     ts,
                     marvel_private_api_key,
                     marvel_public_api_key)
  hash <- digest::digest(to_hash, "md5", FALSE)
  
  base_url <- "https://gateway.marvel.com/v1/public/" # base url
  
  if (!is.null(creator)) { # if user enters creator, pull creatorID
    creatorID = creators_id$id[creators_id$fullName == creator]
    comics_base_url <- paste0(base_url, "creators/", creatorID, "/comics")
    
  } else if (!is.null(event)) { # if user enters event, pull eventID
    
    eventID = events_id$id[events_id$title == event]
    comics_base_url <- paste0(base_url, "events/", eventID, "/comics")
    
  } else if (!is.null(series)) { # if user enters series, pull seriesID
    
    seriesID = series_id$id[series_id$title == series]
    comics_base_url  <- paste0(base_url, "series/", seriesID, "/comics")
    
  } else { # if user doesnt enter any ids
    
    comics_base_url <- paste0(base_url, "comics")
  }
  
  httr::modify_url(url = comics_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    comics_url
  
  GET_comics <- httr::GET(comics_url) # GET the url
  stopifnot(httr::status_code(GET_comics) == 200) # stop if error code
  # turn into a tidy dataframe
  content_comics <- httr::content(GET_comics) # retrieve contents of req
  tibble_comics <- tibble::tibble(content_comics) # turn into tibble
  unnest1_comics <- tidyr::unnest(data = tibble_comics[7,1],
                                    cols = content_comics) # unnest
  unnest2_comics <- tidyr::unnest(unnest1_comics[5,1],
                                    cols = content_comics) # unnest
  unnest3_comics <- tidyr::unnest_wider(data = unnest2_comics,
                                          col = content_comics) # gets df
  
  return(unnest3_comics) # return dataframe to user
  
}