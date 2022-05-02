#' @title Get tibble of series information from Marvel API
#' 
#' @description Get tibble containing information related to series through the Marvel API based on user input criteria.
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (defaulted to 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param comic A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.
#' @param creator A character vector. A person or entity that makes comics.
#' @param events A character vector. A big, universe-changing storyline
#' @param character A character vector. Full name of the Marvel character.
#' @param story A character vector. Indivisible components of comics.
#' 
#' 
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_series
#' 
#' @examples 
#' get_series()




get_series <- function(limit = 100, # default limit should be 100
                       offset = 0, # how many results to offset by
                       comic = NULL, # default comicID should be NULL
                       creator = NULL, # default creatorID should be NULL
                       events = NULL, # default eventsID should be NULL
                       character = NULL, # default characterID should be NULL 
                       story = NULL) { # default storyID should be NULL
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get private key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 4 (if 1 entered) or 5 (if none entered)
  
  if(sum(is.null(comic),
         is.null(creator),
         is.null(events),
         is.null(character),
         is.null(story)) < 4) {
    stop("Please choose to enter an argument for only one of comic, creator, events, character, or story.")
  }
  
  # entries for arguments should be characters/strings
  
  if(!is.null(comic) & !is.character(comic)) {
    stop("Comic must be entered as string/characters. Ex. \"Age of Ultron (2013) #1\"")
  }
  
  if(!is.null(creator) & !is.character(creator)) {
    stop("Creator must be entered as string/characters. Ex. \"Brian Michael Bendis\"")
  }
  
  if(!is.null(events) & !is.character(events)) {
    stop("Events must be entered as string/characters. Ex. \"Armor Wars\"")
  }
  
  if(!is.null(character) & !is.character(character)) {
    stop("Character must be entered as string/characters. Ex. \"Black Widow\"")
  }
  
  if(!is.null(story) & !is.character(story)) {
    stop("StoryID must be entered as string/characters.")
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
    series_base_url <- paste0(base_url, "comics/", comicsID, "/series")
    
  } else if (!is.null(creator)) { # if user enters creator
    
    creatorID = creators_id$id[creators_id$fullName == creator]
    series_base_url <- paste0(base_url, "creators/", creatorID, "/series")
    
  } else if (!is.null(events)) { # if user enters events
    
    eventsID = events_id$id[events_id$title == events]
    series_base_url  <- paste0(base_url, "events/", eventsID, "/series")
    
  } else if (!is.null(character)) { # if user enters character
    
    characterID = character_ids$id[character_ids$name == character]
    series_base_url  <- paste0(base_url, "characters/", characterID, "/series")
    
  } else if (!is.null(story)) { # if user enters storyID
    
    series_base_url <- paste0(base_url, "stories/", story, "/series")
    
  } else { # if user doesn't enter any ids
    
    series_base_url <- paste0(base_url, "series")
  }
  
  httr::modify_url(url = series_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    series_url
  
  GET_series <- httr::GET(series_url) # GET the url
  stopifnot(httr::status_code(GET_series) == 200) # stop if error code
  
  # turn into a tidy data frame
  content_series <- httr::content(GET_series) # retrieve contents of request
  tibble_series <- tibble::tibble(content_series) # turn into tibble
  unnest1_series <- tidyr::unnest(data = tibble_series[7,1],
                                  cols = content_series) # unnest
  unnest2_series <- tidyr::unnest(unnest1_series[5,1],
                                  cols = content_series) # unnest
  unnest3_series <- tidyr::unnest_wider(data = unnest2_series,
                                        col = content_series) # gets df
  
  return(unnest3_series) # return data frame to user
}