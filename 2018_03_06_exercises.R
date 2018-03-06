library(ggplot2)
library(dplyr)
library(purrr)

set.seed(3212016)
d = data.frame(x = 1:120) %>%
  mutate(y = sin(2*pi*x/120) + runif(length(x),-1,1))
l = loess(y ~ x, data=d)
d = d %>% mutate(
  pred_y = predict(l),
  pred_y_se = predict(l,se=TRUE)$se.fit
) %>% mutate(
  pred_low  = pred_y - 1.96 * pred_y_se,
  pred_high = pred_y + 1.96 * pred_y_se
)

n_rep = 500
d_xy = select(d, x, y)

system.time({
  res = map(1:n_rep, function(i) {
    d_xy %>% 
      select(x,y) %>% 
      sample_n(nrow(d), replace=TRUE) %>%
      loess(y ~ x, data=.) %>%
      predict(newdata=d) %>%
      setNames(NULL)
  }) %>% do.call(cbind, .)
})

system.time({
  res = parallel::mclapply(
    1:n_rep, 
    function(i) {
      d_xy %>% 
        select(x,y) %>% 
        sample_n(nrow(d), replace=TRUE) %>%
        loess(y ~ x, data=.) %>%
        predict(newdata=d) %>%
        setNames(NULL)
    },
    mc.cores = 8) %>% 
    do.call(cbind, .)
})


d = d %>% mutate(
  bs_low = apply(res,1,quantile,probs=c(0.025), na.rm=TRUE),
  bs_high  = apply(res,1,quantile,probs=c(0.975), na.rm=TRUE)
)

ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(aes(ymin=pred_low, ymax=pred_high), fill="red", alpha=0.25) +
  geom_ribbon(aes(ymin=bs_low, ymax=bs_high), fill="blue", alpha=0.25) +
  geom_line(aes(y=pred_y)) +
  theme_bw()
