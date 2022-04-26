#' @title Create main source for character queries 
#' 
#' @param id The unique character ID 
#' 
#' @param 
#' @author Bethany Leap



characters <- tibble::tibble()

for (i in seq(0,1600,100)) {
  char_json <- marvel_api(path = "/v1/public/characters", 
                           pub_key = keyring::key_get("marvel_public"), 
                           priv_key = keyring::key_get("marvel_private"), 
                           limit = 100, 
                           offset = i)
  data <- tibble::tibble(char_json) |> 
    dplyr::slice(7) |> 
    tidyr::unnest(col = char_json) |> 
    dplyr::slice(5) |> 
    tidyr::unnest(col = char_json) |> 
    tidyr::unnest_wider(col = char_json)
  
  characters <- rbind(characters, data)
}

# begin tidying the data frame for inclusion in 

characters |> 
# remove thumbnail because not important
  dplyr::select(-c(thumbnail, resourceURI, urls)) |> 
  tidyr::unnest_wider(col = "comics") |> 
  dplyr::rename(n_comics = available) |> 
  dplyr::select(-collectionURI) |>    
  tidyr::unnest_longer(items) |>
  tidyr::unnest_wider(items, names_sep = "_") |>
  dplyr::mutate(comic_id = basename(items_resourceURI), 
                comic_id = as.numeric(comic_id)) |>
  dplyr::select(-c(items_resourceURI, description, modified, returned)) -> chars

chars |>
  dplyr::rename(char_name = name) |> 
  tidyr::unnest_wider(series) |> 
  tidyr::unnest_wider(stories, names_sep = "_") |> 
  tidyr::unnest_wider(events, names_sep = "_") |>
  dplyr::select(-c(tidyselect::contains("collectionURI"), tidyselect::contains("returned"))) 

test |> 
  tidyr::unnest_longer(series_items) |> 
  tidyr::unnest_wider(series_items, names_sep = "_") |>
  dplyr::mutate(series_id = basename(series_items_resourceURI), 
                series_id = as.numeric(series_id)) |> 
  dplyr::rename(series_name = series_items_name) |>
  dplyr::select(-c(series_items_resourceURI)) |> 
  tidyr::unnest_longer(stories_items) |> 
  tidyr::unnest_wider(stories_items, names_sep = "_") |>
  dplyr::mutate(stories_id = basename(stories_items_resourceURI), 
                stories_id = as.numeric(stories_id)) 

