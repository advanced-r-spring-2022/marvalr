
#get_creators
test_that("Users must input a character vector for arguments in get_creators", {
  expect_error(
    get_creators(comic = 10),  
    regexp = "Comic must be entered as string/characters. Ex. \"Carnage #2\"")
  expect_error(
    get_creators(event = 10),  
    regexp = "Event must be entered as string/characters. Ex. \"Civil War\"")
  expect_error(
    get_creators(series = 10),  
    regexp = "Series must be entered as string/characters. Ex. \"Eternals\"")
})


test_that("Users can only choose one argument", {
  expect_error(
    get_creators(series = "Civil War", comic = "Carnage #2"),  
    regexp = "Please choose to enter an argument for only one of comic, event, or series.")
})

test_that("Output should be a list", {
  expect_type(get_creators(limit = 1), "list")
})



#get_comics
test_that("Users must input a character vector for arguments in get_comics", {
  expect_error(
    get_comics(creator = 10),  
    regexp = "Creator must be entered as string/characters. Ex. \"Jeff Youngquist\"")
  expect_error(
    get_comics(event = 10),  
    regexp = "Event must be entered as string/characters. Ex. \"Civil War\"")
  expect_error(
    get_comics(series = 10),  
    regexp = "Creator must be entered as string/characters. Ex. \"Eternals\"")
})


test_that("Users can only choose one argument", {
  expect_error(
    get_comics(series = "Civil War", creator = "Mary H.K. Choi"),  
    regexp = "Please choose to enter an argument for only one of comic, event, or series.")
})

test_that("Output should be a list", {
  expect_type(get_creators(limit = 1), "list")
})



