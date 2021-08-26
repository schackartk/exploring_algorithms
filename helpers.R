perp_segment_coord <- function(x0, y0, int, slp){
  x1 <- (x0 + slp*(y0 - int))/(1 + slp^2)
  y1 <- slp*x1 + int
  
  segments <- list(x0=x0, y0=y0, x1=x1, y1=y1)
}

plot_perp <- function(df){
  
  lm_model <- linear_reg() %>% 
    set_engine("lm") %>% 
    set_mode("regression")
  
  lm_fit <- lm_model %>% 
    fit(hp ~ wt, data=df)
  
  intercept <- summary(lm_fit$fit)$coefficients["(Intercept)",1]
  slope <- summary(lm_fit$fit)$coefficients["wt",1]
  
  segments <- perp_segment_coord(df$wt, df$hp, intercept, slope) %>% 
    as.data.frame()
  
  plot <- df %>% ggplot(aes(x=wt, y=hp)) +
    geom_segment(data=segments, 
                 aes(x=x0, y=y0, xend=x1, yend=y1), 
                 colour=get_hurwitz_colors("viking")) +
    geom_abline(slope=slope, intercept=intercept,
                color=get_hurwitz_colors("light_gray"),
                size=1) +
    geom_point(color=get_hurwitz_colors("red"))
  
  plot
}