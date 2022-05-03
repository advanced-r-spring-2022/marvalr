test_that("Users must input a numeric vector for x in convert area", {
  expect_error(conv_area(
    x = c("liverpool", "reds"), 
    from = "sq mi", 
    to = "sq yd"),
    regexp = "Error: x must be a numeric vector.")
})