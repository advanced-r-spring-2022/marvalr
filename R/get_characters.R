get_characters <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comicID = NULL, # default comicID should be NULL
                           eventID = NULL, # default eventID should be NULL
                           seriesID = NULL, # default seriesID should be NULL
                           storyID = NULL) { # default storyID should be NULL
  
  marvel_public_api_key <- Sys.getenv("MARVEL_PUBLIC_API_KEY") # get public key
  marvel_private_api_key <- Sys.getenv("MARVEL_PRIVATE_API_KEY") # get priv key
  
  # should only be enter one of c("comicID", "eventID", "seriesID", "storyID")
  # so number of nulls should be 3 (if 1 entered) or 4 (if none entered)
  stopifnot(sum(is.null(comicID),
                is.null(eventID),
                is.null(seriesID),
                is.null(storyID)) >= 3)
  
  # should be a whole number if entered
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