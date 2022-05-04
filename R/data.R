utils::globalVariables(c("series_id", "comics_id", "creators_id", "character_ids", "events_id"))

#' @title Find unique ID for all series in the Marvel Universe.
#'
#' @description Contains the unique id and title for every Marvel series which
#' can be called using the Marvel API.
#'
#' @format a \code{tibble} containing 9,309 observations of two columns:
#' \describe{
#'  \item{id}{A numeric vector containing the unique identifier associated with
#'  each Marvel series}
#'  \item{title}{A character vector containing the title of each Marvel series}
#'}
#' @source Data provided by Marvel. Copyright 2014 Marvel.
"series_id"

#' @title Get unique ID for all Marvel Comics.
#'
#' @description Contains the unique ID and title of all comics which can be
#' accessed using the Marvel API.
#'
#' @format a \code{tibble} containing 49,361 observations of 2 columns:
#' \describe{
#'  \item{id}{A numeric vector containing the unique identifier associated with
#'  each comic}
#'  \item{title}{A character vector containing the title of each Marvel comic}
#'}
#'
#' @source Data provided by Marvel. Copyright 2014 Marvel.
#'
"comics_id"

#' @title Find unique ID of all creators in the Marvel Universe.
#'
#' @description Contains the unique id and name for every Marvel creator whose
#' information can be accessed using the Marvel API.
#'
#' @format A \code{tibble} containing 1,561 observations of two columns:
#' \describe{
#'  \item{id}{A numeric vector containing the unique identifier associated with
#'  each creator}
#'  \item{fullName}{A character vector containing the name of each Marvel creator}
#' }
#' @source Data provided by Marvel. Copyright 2014 Marvel.
"creators_id"

#' @title Find unique ID for all characters in the Marvel Universe.
#'
#' @description Contains the unique id and name for every Marvel character which
#' can be called using the Marvel API.
#'
#' @format A \code{tibble} containing 1,561 observations of two columns:
#' \describe{
#'  \item{id}{A numeric vector containing the unique identifier associated with
#'  each character}
#'  \item{name}{A character vector containing the name of each Marvel character}
#' }
#'
#' @source Data provided by Marvel. Copyright 2014 Marvel.
"character_ids"

#' @title Find unique ID for all important events in the Marvel Universe.
#'
#' @description Contains the id, title, and description for every event which
#' can be called using the Marvel API.
#'
#' @source Data provided by Marvel. Copyright 2014 Marvel.
#'
#' @format A \code{tibble} with 74 observations and 3 columns:
#' \describe{
#'   \item{id}{A numeric vector containing the unique identifier associated with
#'   each event}
#'   \item{title}{A character vector indicating the title of the important event}
#'   \item{description}{A character vector containing a detailed description of
#'   each event}
#'   }
"events_id"
