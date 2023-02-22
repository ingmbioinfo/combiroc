test_that("ranked_combs generates a list of length 2", {
  expect_type(rmks, "list")
  expect_length(rmks, 2)
})

test_that("bubble_chard objects is a ggplot objects", {
  expect_s3_class(rmks$bubble_chart, c("gg", "ggplot"))
})

test_that("table objects is a data frame of lenght 7", {
  expect_s3_class(rmks$table, "data.frame")
  expect_length(rmks$table, 7)
})
