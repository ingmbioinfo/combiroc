test_that("show_markers generates a dataframe of length 2", {
  expect_s3_class(sh_mk, "data.frame")
  expect_length(sh_mk, 2)
})
