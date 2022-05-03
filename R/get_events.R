#' @title Get tibble of events information from Marvel API
#' 
#' @description Get tibble containing information related to events through the Marvel API based on user input criteria.
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (defaulted to 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param comic A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.
#' @param creator A character vector. A person or entity that makes comics.
#' @param series A character vector. Sequentially numbered list of comics with the same title and volume.
#' @param character A character vector. Full name of the Marvel character.
#' 
#' 
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_events
#' 
#' @examples 
#' get_events()
#'                 
#' get_events(creator = "Brian Michael Bendis")
#' 
#' get_events(character = "Black Widow")
#' 
#' 



get_events <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comic = NULL, # default comicID should be NULL
                           creator = NULL, # default creatorID should be NULL
                           series = NULL, # default seriesID should be NULL
                           character = NULL # default characterID should be NULL 
                           ) { 
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get private key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 2 (if 1 entered) or 3 (if none entered)
  
  if(sum(is.null(comic),
         is.null(creator),
         is.null(series),
         is.null(character)) < 3) {
    stop("Please choose to enter an argument for only one of comic, creator, series, or character.")
  }
  
  # entries for arguments should be characters/strings
  
  if(!is.null(comic) & !is.character(comic)) {
    stop("Comic must be entered as string/characters. Ex. \"Age of Ultron (2013) #1\"")
  }
  
  if(!is.null(creator) & !is.character(creator)) {
    stop("Creator must be entered as string/characters. Ex. \"Brian Michael Bendis\"")
  }
  
  if(!is.null(series) & !is.character(series)) {
    stop("Series must be entered as string/characters. Ex. \"All-New X-Men (2015 - 2017)\"")
  }
  
  if(!is.null(character) & !is.character(character)) {
    stop("Character must be entered as string/characters. Ex. \"Black Widow\"")
  }
  
  
  
  # timestamp, hash, and url
  ts <- round(as.numeric(Sys.time())*1000) 
  to_hash <- sprintf("%s%s%s",
                     ts,
                     marvel_private_api_key,
                     marvel_public_api_key)
  hash <- digest::digest(to_hash, "md5", FALSE)
  
  base_url <- "https://gateway.marvel.com/v1/public/" # base url
  
  if (!is.null(comic)) { # if user enters comics
    comicsID = comics_id$id[comics_id$title == comic]
    events_base_url <- paste0(base_url, "comics/", comicsID, "/events")
    
  } else if (!is.null(creator)) { # if user enters creator
    
    creatorID = creators_id$id[creators_id$fullName == creator]
    events_base_url <- paste0(base_url, "creators/", creatorID, "/events")
    
  } else if (!is.null(series)) { # if user enters series
    
    seriesID = series_id$id[series_id$title == series]
    events_base_url  <- paste0(base_url, "series/", seriesID, "/events")
    
  } else if (!is.null(character)) { # if user enters character
    
    characterID = character_ids$id[character_ids$name == character]
    events_base_url  <- paste0(base_url, "characters/", characterID, "/events")
    
  } else { # if user doesn't enter any ids
    
    events_base_url <- paste0(base_url, "events")
  }
  
  httr::modify_url(url = events_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    events_url
  
  GET_events <- httr::GET(events_url) # GET the url
  stopifnot(httr::status_code(GET_events) == 200) # stop if error code
  
  # turn into a tidy data frame
  content_events <- httr::content(GET_events) # retrieve contents of request
  tibble_events <- tibble::tibble(content_events) # turn into tibble
  unnest1_events <- tidyr::unnest(data = tibble_events[7,1],
                                      cols = content_events) # unnest
  unnest2_events <- tidyr::unnest(unnest1_events[5,1],
                                      cols = content_events) # unnest
  unnest3_events <- tidyr::unnest_wider(data = unnest2_events,
                                            col = content_events) # gets df
  
  return(unnest3_events) # return data frame to user
}