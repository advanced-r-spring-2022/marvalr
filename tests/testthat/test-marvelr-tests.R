test_that("Users must input a character vector for arguments in get_creators", {
  expect_error(
    get_creators(comic = 10),  regexp = "Comic must be entered as string/characters. Ex. \"Carnage #2\"")
})