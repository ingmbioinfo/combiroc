test_that("combi_long returns a tibble", {
  expect_s3_class(data_long, c("tbl_df", "tbl", "data.frame"))
})
