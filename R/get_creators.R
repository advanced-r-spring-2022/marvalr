#' @title Get tibble of creators information from Marvel API
#'
#' @description Get tibble containing information related to creators through the Marvel API based on user input criteria.
#'
#' @param limit An integer. Limit the result set to the specified number of resources (defaulted to 100).
#' @param offset An integer. Skip the specified number of resources in the result set.
#' @param comic A character vector. A Marvel comic issue, collection, graphic novel, or digital comic
#' @param event A character vector. A big, universe-changing storyline
#' @param series A character vector. Sequentially numbered list of comics with the same title and volume
#'
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
#'                 comic = "X-Men (1991) #23")
#'
#'
#' get_creators(event = "Civil War")
get_creators <- function(limit = 100, # default limit should be 100
                           offset = 0, # how many results to offset by
                           comic = NULL, # default comicID should be NULL
                           event = NULL, # default eventID should be NULL
                           series = NULL) { # default seriesID should be NULL
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




  # timestamp, hash, and url
  ts <- round(as.numeric(Sys.time())*1000)
  to_hash <- sprintf("%s%s%s",
                     ts,
                     marvel_private_api_key,
                     marvel_public_api_key)
  hash <- digest::digest(to_hash, "md5", FALSE)

  base_url <- "https://gateway.marvel.com/v1/public/" # base url

  if (!is.null(comic)) { # if user enters comicID
    comicID = comics_id$id[comics_id$title == comic]
    creators_base_url <- paste0(base_url, "comics/", comicID, "/creators")

  } else if (!is.null(event)) { # if user enters eventID
    eventID = events_id$id[events_id$title == event]
    creators_base_url <- paste0(base_url, "events/", eventID, "/creators")

  } else if (!is.null(series)) { # if user enters seriesID
    seriesID = series_id$id[series_id$title == series]
    creators_base_url  <- paste0(base_url, "series/", seriesID, "/creators")

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
  if (httr::status_code(GET_creators) != 200) {
    stop(paste0("\n", httr::http_status(GET_creators)$message))
  }
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
