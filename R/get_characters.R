#' @title Fetches a dataframe of Marvel characters from the Marvel API.
#' 
#' @description Fetches a dataframe of Marvel characters from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel characters alphabetically. However, user can use different arguments in the function to find characters from different comics, events, stories, or series, or other arguments such as what the character's name starts with or how many results to offset by. 
#' 
#' @param limit An integer. Limit the result set to the specified number of resources (max 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param comic A character vector. A Marvel comic issue, collection, graphic novel, or digital comic
#' @param event A character vector. A big, universe-changing storyline
#' @param series A character vector. Sequentially numbered list of comics with the same title and volume
#' 
#' @return A dataframe of up to 100 characters containing their ID, name, description, time last modified, resource URI, and nested lists of thumbnails, comics, series, stories, events, and urls.
#' 
#' @author Bethany Leap, Daniel Bernal Panqueva, Dashiell Nusbaum, Ian M Davis
#' 
#' @export get_characters
#' 
#' @examples
#' 
#' get_characters(limit = 5)
#' 
#' get_characters(event = "Civil War")
#' 


get_characters <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comic = NULL, # default comicID should be NULL
                           event = NULL, # default eventID should be NULL
                           series = NULL # default seriesID should be NULL
                           ) {
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get priv key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 2 (if 1 entered) or 3 (if none entered)

  if(sum(is.null(comic),
         is.null(event),
         is.null(series)) <2) {
    stop("Please choose to enter an argument for only one of comic, event, or series.")
  }
  
  # entries for arguments should be characters/strings
  
  if(!is.null(comic) & !is.character(comic)) {
    stop("Comic must be entered as string/characters. Ex. \"Carnage #2\"")
  }
  
  if(!is.null(event) & !is.character(event)) {
    stop("Event must be entered as string/characters. Ex. \"Civil War\"")
  }
  
  if(!is.null(series) & !is.character(series)) {
    stop("Series must be entered as string/characters. Ex. \"Eternals\"")
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
  
  if (is.null(comic) == FALSE) { # if user enters comicID
    comicID = comics_id$id[comics_id$title == comic]
    characters_base_url <- paste0(base_url, "comics/", comicID, "/characters")
  } else if (is.null(event) == FALSE) { # if user enters eventID
    eventID = events_id$id[events_id$title == event]
    characters_base_url <- paste0(base_url, "events/", eventID, "/characters")
  } else if (is.null(series) == FALSE) { # if user enters seriesID
    seriesID = series_id$id[series_id$title == series]
    characters_base_url <- paste0(base_url, "series/", seriesID, "/characters")
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