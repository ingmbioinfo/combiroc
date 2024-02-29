test_that("combiroc_select returns the correct number of markers", {
  selected_markers <- combiroc_select(syn, case_class = "case", n = 2)
  expect_equal(length(selected_markers), 2)
})

test_that("combiroc_select handles non-numeric n", {
  expect_error(combiroc_select(syn, case_class = "case", n = "two"))
})

test_that("combiroc_select handles invalid data input", {
  expect_error(combiroc_select("not_a_synframe", case_class = "case", n = 2))
})

test_that("combiroc_select correctly identifies markers", {
  # This test assumes you know which markers should be selected based on your synthetic data
  # For demonstration, let's pretend Marker3 and Marker2 are expected to be the top 2 markers
  selected_markers <- combiroc_select(syn, case_class = "case", n = 2)
  selected_markers <- selected_markers$best_markers
  expected_markers <- c("Marker3", "Marker2") # Adjust based on expected outcome
  expect_equal(sort(names(selected_markers)), sort(expected_markers))
})

test_that("combiroc_select returns named numeric vector with coefficients", {
  selected_markers <- combiroc_select(syn, case_class = "case", n = 2)
  selected_markers <- selected_markers$best_markers
  expect_true(is.numeric(selected_markers) && is.vector(selected_markers))
  expect_true(all(!is.na(names(selected_markers))))
})
