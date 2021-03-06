context("type_topic_reweighting")

data("sotu50")
beta <- 0.1
ttm <- type_topic_matrix(sotu50)


test_that(desc="base functions are correct",{
  K <- length(unique(sotu50$topic))
  V <- length(levels(sotu50$type))
  N <- nrow(sotu50)
  N_k <- dplyr::summarise(dplyr::group_by(sotu50, topic), n = n())
  N_w <- dplyr::summarise(dplyr::group_by(sotu50, type), n = n())

  expect_equal(sum(p_wk(ttm, beta = 0)$p), 1)
  expect_silent(ps <- p_wk(ttm, beta))
  mass <- (N + V * K * beta)
  expect_equal(sum(ps$p) + ((V * K - nrow(ps)) * beta) / mass, 1)

  expect_equal(sum(p_w_given_k(ttm, beta = 0)$p), K)
  expect_silent(ps <- p_w_given_k(ttm, beta))
  p_k <- dplyr::left_join(dplyr::summarise(dplyr::group_by(ps, topic), p = sum(p), non_zero = n()), N_k, by = "topic")
  p_k <- dplyr::mutate(p_k, p_zero = (V - non_zero) * beta / (n + V * beta), mass = NULL, n = NULL, non_zero = NULL)
  expect_equal(p_k$p + p_k$p_zero, rep(1, K))

  expect_equal(sum(p_k_given_w(ttm, beta = 0)$p), length(levels(sotu50$type)))
  ps <- p_k_given_w(ttm, beta)
  p_w_test <- dplyr::left_join(dplyr::summarise(dplyr::group_by(ps, type), p = sum(p), non_zero = n()), N_w, by = "type")
  p_w_test <- dplyr::mutate(p_w_test,  p_zero = (K - non_zero) * beta / (n + K * beta), n = NULL, non_zero = NULL)
  expect_equal(p_w_test$p + p_w_test$p_zero, rep(1, V))

  expect_equal(sum(p_w(ttm, beta = 0)$p), 1)
  expect_equal(sum(p_w(ttm, beta)$p), 1)

  expect_equal(sum(p_k(ttm, beta = 0)$p), 1)
  expect_equal(sum(p_k(ttm, beta)$p), 1)

})

test_that(desc="reweighting methods / api",{

  j <- 5
  K <- length(unique(sotu50$topic))
  
  expect_silent(tp1 <- top_terms(ttm, "type_probability", j))
  expect_silent(tp2 <- top_terms(sotu50, "type_probability", j))
  expect_identical(tp1, tp2)
  expect_equal(nrow(tp1), j * K)
  expect_equal(ncol(tp1), 3)

  expect_silent(tp <- top_terms(ttm, "topic_probability", j))
  expect_equal(nrow(tp), j * K)
  expect_equal(ncol(tp), 3)

  expect_silent(tp <- top_terms(ttm, "n_wk", j))
  expect_equal(nrow(tp), j * K)
  expect_equal(ncol(tp), 3)
  

  expect_silent(tp <- top_terms(ttm, "relevance", j, lambda = 0.5))
  expect_message(tp <- top_terms(ttm, "relevance", j), regexp = "0\\.6")
  expect_equal(nrow(tp), j * K)
  expect_equal(ncol(tp), 3)

  expect_error(tp <- top_terms(ttm, "term_score", j))
  expect_silent(tp <- top_terms(ttm, "term_score", j, beta))
  expect_equal(nrow(tp), j * K)
  expect_equal(ncol(tp), 3)

})


test_that(desc="adding extra variables do not fail / api",{
  
  j <- 5
  K <- length(unique(sotu50$topic))
  ttm2 <- ttm
  ttm2$extra_var <- 1
  
  expect_silent(tp1 <- top_terms(ttm, "type_probability", j))
  expect_silent(tp2 <- top_terms(ttm2, "type_probability", j))
  expect_identical(tp1, tp2)
  
})


test_that(desc="Warn. for duplicates",{
  skip_on_travis()
  j <- 5
  K <- length(unique(sotu50$topic))
  tp <- top_terms(ttm, "n_wk", 100000)
  tpr <- top_terms(ttm, "type_probability", 100000)
  topr <- top_terms(ttm, "topic_probability", 100000, beta = 0.01)
  

  extra_row <- ttm[72,]
  extra_row_plus <- extra_row
  extra_row_plus$n <- extra_row_plus$n + 3L
  
  ttm2 <- dplyr::bind_rows(ttm,extra_row)
  ttm3 <- dplyr::bind_rows(ttm,extra_row_plus)
  
  expect_warning(tp1 <- top_terms(ttm2, "type_probability", j))
  expect_warning(tp1 <- top_terms(ttm3, "type_probability", j))

  # Check that no aggregation is done  
  ttm4 <- ttm
  ttm4$type[ttm4$type == "senate"] <- "fellow-citizens"
  
  expect_warning(tp1 <- top_terms(ttm4, "n_wk", 100000))
  tp <- tp[tp$type %in% c("fellow-citizens", "senate"),]
  tp1 <- tp1[tp1$type %in% c("fellow-citizens", "senate"),]
  expect_identical(tp[order(tp$n_wk),c("topic", "n_wk")],tp1[order(tp1$n_wk),c("topic", "n_wk")])

  expect_warning(tpr1 <- top_terms(ttm4, "type_probability", 100000))
  tpr <- tpr[tpr$type %in% c("fellow-citizens", "senate"),]
  tpr1 <- tpr1[tpr1$type %in% c("fellow-citizens", "senate"),]
  expect_identical(tpr[order(tpr$type_probability),c("topic", "type_probability")],tpr1[order(tpr1$type_probability),c("topic", "type_probability")])
  
  # Factor id should be used, not factor levels for aggregation. 
  # But also warn when duplicates
  expect_warning(topr1 <- top_terms(ttm4, "topic_probability", 100000, beta = 0.01))
  topr <- topr[topr$type %in% c("fellow-citizens", "senate"),]
  topr1 <- topr1[topr1$type %in% c("fellow-citizens", "senate"),]
  expect_identical(topr[order(topr$topic_probability),c("topic", "topic_probability")],topr1[order(topr1$topic_probability),c("topic", "topic_probability")])

})

