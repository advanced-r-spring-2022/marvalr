library(testthat)
library(marvalr)

test_check("marvalr")

test_that("Users must input a character vector for arguments in get_creators", {
  expect_error(
    get_creators(),
    regexp = "Error: x must be a numeric vector.")
})
