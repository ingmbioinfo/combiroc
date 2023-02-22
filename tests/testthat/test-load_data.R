test_that("A dataframe is read", {
  expect_s3_class(data, "data.frame")
})

test_that("the name of second column is enforced to Class", {
  expect_setequal(colnames(data)[2], "Class")
})
