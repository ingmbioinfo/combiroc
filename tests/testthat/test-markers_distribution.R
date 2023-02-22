test_that("markers_ditribution generates a list of length 5", {
  expect_type(distr, "list")
  expect_length(distr, 5)
})

test_that("graphical objects are ggplot objects", {
  expect_s3_class(distr$Boxplot, c("gg", "ggplot"))
  expect_s3_class(distr$Density_plot, c("gg", "ggplot"))
  expect_s3_class(distr$ROC, c("gg", "ggplot"))
})

test_that("table objects are data frames", {
  expect_s3_class(distr$Coord, "data.frame")
  expect_s3_class(distr$Density_summary, "data.frame")
})





