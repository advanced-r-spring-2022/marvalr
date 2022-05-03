# marvalr

### Authors
- **Bethany Leap**
- **Dashiell Nusbaum**
- **Ian Davis**
- **Daniel Bernal**

## Introduction
The `marvalr` package comprises a collection of tools to interact and extract structured data from the [Marvel API](https://developer.marvel.com/). It provides a variety of options to obtain data for comics, comic series, comic stories, comic events and crossovers, creators, and characters. This package is intended for users that have familiarity with APIs and are interested in exploring the endpoints that the [Marvel API](https://developer.marvel.com/) offers.


## Functions

### `marvel_api_keys()`
Allows user to easily set their public and private API keys for the Marvel API. Function allows the user to either set these keys for the current R session (in which case this function will need to be used every session in which the user wants to use this package) or add these keys to their R environment (the .Renviron file) in which case they would not need to use this function more than once or in future R sessions. Adding these keys to the .Renviron file allows the user to use other functions in this package without having their API keys exposed anywhere in their code. If the user does not have a .Renviron file, then this function creates a .Renviron file for them. If the user does have the file, this function will add these keys to the file and make a backup of the original file.\
Note: Users are required to obtain both API keys from the [Marvel API Developer Website](https://developer.marvel.com/) first.

#### Inputs
1. **public_api_key**: The public API key for the Marvel API, formatted in quotes ("").

2. **private_api_key**: The private API key for the Marvel API, formatted in quotes ("").

3. **overwrite**: If is set to TRUE, it will overwrite the existing MARVEL_PUBLIC_API_KEY and MARVEL_PRIVATE_API_KEY in your .Renviron file. If it is set to FALSE (default), it will not overwrite existing keys.

4. **install**: If it is set to TRUE, it will install the key in your .Renviron file to be used in future sessions. If it is set to FALSE (default), it will not be installed.

##### Example

``` r
marvel_api_keys(public_api_key = "abcd1234",
                 private_api_key = "efgh5678",
                 overwrite = TRUE,
                 install = TRUE)
```

### `get_character()`
Fetches a data frame of Marvel characters from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel characters alphabetically. However, user can use different arguments in the function to find characters from different comics, events, stories, or series. 

#### Inputs
Note: Users should only enter one input for comic, event, series, or story. If no input is entered, it will return the first 100 Marvel characters alphabetically.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **comic**: A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.

4. **event**: A character vector. A big, universe-changing story line.

5. **series**: A character vector. Sequentially numbered list of comics with the same title and volume.


##### Examples

``` r
get_characters(limit = 5)
```
``` r
get_characters(event = "Civil War")
```
### `get_comics()`
Fetches a data frame of Marvel comics from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel comics. However, user can use different arguments in the function to find comics from different creators, events, or series. 

#### Inputs
Note: Users should only enter one input for creator, event, or series. If no input is entered, it will return the first 100 Marvel comics.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **creator**: A character vector. A person or entity that make comics.

4. **event**: A character vector. A big, universe-changing story line.

5. **series**: A character vector. Sequentially numbered list of comics with the same title and volume.


##### Examples

``` r
get_comics(creator = "Mary H.K. Choi")
```
``` r
get_comics(event = "Civil War")
```
### `get_creators()`
Fetches a data frame of Marvel creators from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel creators. However, user can use different arguments in the function to find creators from different comics, events, or series. 

#### Inputs
Note: Users should only enter one input for comic, event, or series. If no input is entered, it will return the first 100 Marvel creators.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **comic**: A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.

4. **event**: A character vector. A big, universe-changing story line.

5. **series**: A character vector. Sequentially numbered list of comics with the same title and volume.


##### Examples

``` r
get_creators(limit = 50,
                 offset = 0,
                 comic = "X-Men (1991) #23")
```
``` r
get_creators(event = "Civil War")
```
### `get_events()`
Fetches a data frame of Marvel events from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel events. However, user can use different arguments in the function to find creators from different comics, creators, series, or character. 

#### Inputs
Note: Users should only enter one input for comic, creators, series, or character. If no input is entered, it will return the first 100 Marvel events.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **comic**: A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.

4. **creator**: A character vector. A person or entity that makes comics.

5. **series**: A character vector. Sequentially numbered list of comics with the same title and volume.

6. **character**: A character vector. Full name of the Marvel character.


##### Examples

``` r
get_events(limit = 10)
```
``` r
get_events(creator = "Brian Michael Bendis")
```
### `get_series()`
Fetches a data frame of Marvel series from the Marvel API using different user-set parameters. By default, the function will return the first 100 Marvel series. However, user can use different arguments in the function to find series from different comics, creators, events, or character. 

#### Inputs
Note: Users should only enter one input for comic, creators, events, or character. If no input is entered, it will return the first 100 Marvel series.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **comic**: A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.

4. **creator**: A character vector. A person or entity that makes comics.

5. **events**: A character vector. A big, universe-changing story line.

6. **character**: A character vector. Full name of the Marvel character.


##### Examples

``` r
get_series(events = "Age of Ultron")
```
``` r
get_series(character = "Vision")
```

### `get_stories()`
Fetches a data frame of Marvel stories from the Marvel API using different user-set parameters. By default, the function will return the existing Marvel stories. However, user can use different arguments in the function to find stories from different comics, creators, events, character, or series. 

#### Inputs
Note: Users should only enter one input for comic, creators, events, character, or series. If no input is entered, it will return all the existing Marvel stories.

1. **limit**: An integer. Limit the result set to the specified number of resources (max 100).

2. **offset**: An integer. Skip the specified number of resources in the result set.

3. **comic**: A character vector. A Marvel comic issue, collection, graphic novel, or digital comic.

4. **creator**: A character vector. A person or entity that makes comics.

5. **events**: A character vector. A big, universe-changing story line.

6. **character**: A character vector. Full name of the Marvel character.

7. **series**: A character vector. Sequentially numbered list of comics with the same title and volume.


##### Examples

``` r
get_stories()
```
``` r
get_stories(character = "Invisible Woman")
```
