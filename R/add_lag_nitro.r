add_lag_nitro = function(data) {
    data|>
    group_by(id) |>
      mutate(
        lag_nitro_pre = lag(nitro_pre),
        lag_mean_nitro_pre = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_nitro_pre, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_nitro_pre = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_nitro_pre, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_nitro_post = lag(nitro_post),
        lag_nitro_diff = lag_nitro_post - lag_nitro_pre,
        lag_mean_nitro_post = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_nitro_post, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_nitro_post = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_nitro_post, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mean_nitro_diff = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_nitro_diff, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_nitro_diff = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_nitro_diff, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_sbp_pre = lag(sbp_pre),
        lag_mean_sbp_pre = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_sbp_pre, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_sbp_pre = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_sbp_pre, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_sbp_post = lag(sbp_post),
        lag_mean_sbp_post = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_sbp_post, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_sbp_post = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_sbp_post, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_nitro_diff = lag_nitro_post - lag_nitro_pre,
        lag_sbp_diff = lag_sbp_post - lag_sbp_pre,
        lag_mean_sbp_diff = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(.x$lag_sbp_diff, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_sbp_diff = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(.x$lag_sbp_diff, na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mean_sbp_diff_abs = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mean(abs(.x$lag_sbp_diff), na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
        lag_mad_sbp_diff_abs = slider::slide_dbl(
          .x = cur_data(),
          .f = ~ mad(abs(.x$lag_sbp_diff), na.rm = TRUE),
          .before = Inf,
          .complete = T
        ),
      ) |>
      mutate(first_titration = row_number(n_nitro)) |>
      filter(first_titration != 1) |>
      ungroup()
}