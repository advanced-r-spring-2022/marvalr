#' @title Fetches a dataframe of Marvel characters from the Marvel API.
#' 
#' @description Fetches a dataframe of Marvel characters from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel characters alphabetically. However, user can use different arguments in the function to find characters from different comics, events, stories, or series, or other arguments such as what the character's name starts with or how many results to offset by. 
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (max 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param nameStartsWith A character. Return characters with names that begin with the specified string (e.g. Sp).
#' @param comic An integer. The comic ID (e.g., 101094).
#' @param event An integer. The event ID (e.g., 305).
#' @param series An integer. The series ID (e.g., 25990).
#' @param story An integer. The story ID (e.g., 223124).
#' 
#' @return A dataframe of up to 100 characters containing their ID, name, description, time last modified, resource URI, and nested lists of thumbnails, comics, series, stories, events, and urls.
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @examples
#' 


get_characters <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comic = NULL, # default comicID should be NULL
                           event = NULL, # default eventID should be NULL
                           series = NULL, # default seriesID should be NULL
                           story = NULL) { # default storyID should be NULL
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get priv key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 3 (if 1 entered) or 4 (if none entered)

  if(sum(is.null(comic),
         is.null(event),
         is.null(series),
         is.null(story)) <3) {
    stop("Please choose to enter an argument for only one of comic, event, series, or story.")
  }
  
  # entries for arguments should be characters/strings
  
  if(!is.null(comic) & !is.character(comic)) {
    stop("Comic must be entered as string/characters. Ex. \"Carnage #2\"")
  }
  
  if(!is.null(event) & !is.character(event)) {
    stop("Comic must be entered as string/characters. Ex. \"Civil War\"")
  }
  
  if(!is.null(series) & !is.character(series)) {
    stop("Comic must be entered as string/characters. Ex. \"Eternals\"")
  }
  
  if(!is.null(story) & !is.character(story)) {
    stop("Comic must be entered as string/characters.") # still need example, not sure what a story?
  }
  
  # get ids from character/string entries
  # filter to be the row where title == user entry, select the id column
  if(!is.null(comic)) { # if comic isnt NULL
    comicID <- comics_id[comics_id$title == comic, "id"] 
  } else if(!is.null(event)) {
    eventID <- events_id[events_id$title == event, "id"]
  } else if(!is.null(series)) {
    seriesID <- series_id[series_id$title == series, "id"]
  }
  
  # timestamp, hash, and url
  ts <- round(as.numeric(Sys.time())*1000) 
  to_hash <- sprintf("%s%s%s",
                     ts,
                     marvel_private_api_key,
                     marvel_public_api_key)
  hash <- digest::digest(to_hash, "md5", FALSE)
  
  base_url <- "https://gateway.marvel.com/v1/public/" # base url
  
  if (is.null(comicID) == FALSE) { # if user enters comicID
    characters_base_url <- paste0(base_url, "comics/", comicID, "/characters")
  } else if (is.null(eventID) == FALSE) { # if user enters eventID
    characters_base_url <- paste0(base_url, "events/", eventID, "/characters")
  } else if (is.null(seriesID) == FALSE) { # if user enters seriesID
    characters_base_url <- paste0(base_url, "series/", seriesID, "/characters")
  } else if (is.null(storyID) == FALSE) { # if user enters storyID
    characters_base_url <- paste0(base_url, "stories/", storyID, "/characters")
  } else { # if user doesnt enter any ids
    characters_base_url <- paste0(base_url, "characters")
  }
  
  httr::modify_url(url = characters_base_url, # take base url
                   query = list(limit = limit,
                                offset = offset,
                                ts = ts, # timestamp
                                hash = hash, # hash
                                apikey = marvel_public_api_key)) -> # public api key
    characters_url
  
  GET_characters <- httr::GET(characters_url) # GET the url
  stopifnot(httr::status_code(GET_characters) == 200) # stop if error code
  # turn into a tidy dataframe
  content_characters <- httr::content(GET_characters) # retrieve contents of req
  tibble_characters <- tibble::tibble(content_characters) # turn into tibble
  unnest1_characters <- tidyr::unnest(data = tibble_characters[7,1],
                                      cols = content_characters) # unnest
  unnest2_characters <- tidyr::unnest(unnest1_characters[5,1],
                                      cols = content_characters) # unnest
  unnest3_characters <- tidyr::unnest_wider(data = unnest2_characters,
                                            col = content_characters) # gets df
  
  return(unnest3_characters) # return dataframe to user
}