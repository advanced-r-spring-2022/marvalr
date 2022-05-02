#' @title Get tibble of stories information from Marvel API
#' 
#' @description Get tibble containing information related to stories through the Marvel API based on user input criteria.
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (defaulted to 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param comic A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.
#' @param creator A character vector. A person or entity that makes comics.
#' @param events A character vector. A big, universe-changing story line.
#' @param character A character vector. Full name of the Marvel character.
#' @param series A character vector. Sequentially numbered list of comics with the same title and volume.
#' 
#' 
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_stories
#' 
#' @examples 
#' get_stories()
#' 
#' get_stories(comic = "A-Force (2015) #2")
#' 
#' get_stories(creator = "Andres Coelho")
#' 
#' get_stories(character = "Invisible Woman")
#' 




get_stories <- function(limit = 100, # default limit should be 100
                       offset = 0, # how many results to offset by
                       comic = NULL, # default comicID should be NULL
                       creator = NULL, # default creatorID should be NULL
                       events = NULL, # default eventsID should be NULL
                       character = NULL, # default characterID should be NULL 
                       series = NULL) { # default seriesID should be NULL
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get private key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 4 (if 1 entered) or 5 (if none entered)
  
  if(sum(is.null(comic),
         is.null(creator),
         is.null(events),
         is.null(character),
         is.null(series)) < 4) {
    stop("Please choose to enter an argument for only one of comic, creator, events, character, or series.")
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
  
  if(!is.null(series) & !is.character(series)) {
    stop("Series must be entered as string/characters.")
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
    stories_base_url <- paste0(base_url, "comics/", comicsID, "/stories")
    
  } else if (!is.null(creator)) { # if user enters creator
    
    creatorID = creators_id$id[creators_id$fullName == creator]
    stories_base_url <- paste0(base_url, "creators/", creatorID, "/stories")
    
  } else if (!is.null(events)) { # if user enters events
    
    eventsID = events_id$id[events_id$title == events]
    stories_base_url  <- paste0(base_url, "events/", eventsID, "/stories")
    
  } else if (!is.null(character)) { # if user enters character
    
    characterID = character_ids$id[character_ids$name == character]
    stories_base_url  <- paste0(base_url, "characters/", characterID, "/stories")
    
  } else if (!is.null(series)) { # if user enters series
    
    seriesID = series_id$id[series_id$title == series]
    stories_base_url  <- paste0(base_url, "series/", seriesID, "/stories")
    
  } else { # if user doesn't enter any ids
    
    stories_base_url <- paste0(base_url, "stories")
  }
  
  httr::modify_url(url = stories_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    stories_url
  
  GET_stories <- httr::GET(stories_url) # GET the url
  stopifnot(httr::status_code(GET_stories) == 200) # stop if error code
  
  # turn into a tidy data frame
  content_stories <- httr::content(GET_stories) # retrieve contents of request
  tibble_stories <- tibble::tibble(content_stories) # turn into tibble
  unnest1_stories <- tidyr::unnest(data = tibble_stories[7,1],
                                  cols = content_stories) # unnest
  unnest2_stories <- tidyr::unnest(unnest1_stories[5,1],
                                  cols = content_stories) # unnest
  unnest3_stories <- tidyr::unnest_wider(data = unnest2_stories,
                                        col = content_stories) # gets df
  
  return(unnest3_stories) # return data frame to user
}