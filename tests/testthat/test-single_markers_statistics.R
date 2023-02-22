test_that("s_m_s generates a list of 2", {
  expect_type(sms, "list")
  expect_length(sms, 2)
})

test_that("s_m_s first element is a tbl dataframe", {
  expect_s3_class(sms[[1]], c("grouped_df", "tbl_df", "tbl", "data.frame"))
})

test_that("s_m_s second element is a list of graphical objects", {
  expect_type(sms[[2]], "list")
  expect_s3_class(sms[[2]][[1]], c("gg", "ggplot"))
  expect_s3_class(sms[[2]][[2]], c("gg", "ggplot"))
  expect_s3_class(sms[[2]][[3]], c("gg", "ggplot"))
  expect_s3_class(sms[[2]][[4]], c("gg", "ggplot"))
  expect_s3_class(sms[[2]][[5]], c("gg", "ggplot"))
})
