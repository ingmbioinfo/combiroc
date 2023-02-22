test_that("An unclassified dataframe is read", {
  expect_s3_class(unc_data, "data.frame")
})

test_that("the name of second column is enforced to Class", {
  expect_type(unc_data[,1], "character")
})
