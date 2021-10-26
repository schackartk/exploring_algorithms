#' perp_segment_coord
#' Calculate coordinates of segments perpendicular to regression line.
#'
#' @param x0 List of x values
#' @param y0 List of y values
#' @param int Regression line intercept
#' @param slp Regression line slope
#'
#' @return Coordinates
#' @export
#'
#' @examples
perp_segment_coord <- function(x0, y0, int, slp){
  x1 <- (x0 + slp*(y0 - int))/(1 + slp^2)
  y1 <- slp*x1 + int
  
  segments <- list(x0=x0, y0=y0, x1=x1, y1=y1)
}

#' plot_perp
#' Plot with ordinary least-squares regression and perpindicular segments
#'
#' @param df Data frame
#' @param x X-axis variable
#' @param y Y-axis variable
#'
#' @return Plot
#' @export
#'
#' @examples
plot_perp <- function(df, x, y){
  
  lm_model <- linear_reg() %>% 
    set_engine("lm") %>% 
    set_mode("regression")
  
  form <- formula(paste(eval(y),"~", eval(x)))
  
  lm_fit <- lm_model %>% 
    fit(form, data=train)
  
  intercept <- summary(lm_fit$fit)$coefficients["(Intercept)",1]
  slope <- summary(lm_fit$fit)$coefficients[x,1]
  
  segments <- perp_segment_coord(df[,x], df[,y], intercept, slope) %>% 
    as.data.frame()
  
  plot <- df %>% ggplot(aes_string(x=x, y=y)) +
    geom_segment(data=segments, 
                 aes(x=x0, y=y0, xend=x1, yend=y1), 
                 colour=get_hurwitz_colors("viking")) +
    geom_abline(slope=slope, intercept=intercept,
                color=get_hurwitz_colors("light_gray"),
                size=1) +
    geom_point(color=get_hurwitz_colors("red"))
  
  plot
}


#' reg_coord
#' Project data to ordinary least-squares regression line
#'
#' @param df Dataframe
#' @param x X-axis for lm()
#' @param y Y-axis for lm()
#'
#' @return Rotated df
#' @export
#'
#' @examples
reg_coord <- function(df, x, y){
  df[,x] <- df[,x] / sd(df[,x])
  df[,y] <- df[,y] / sd(df[,y])
  
  lm_model <- linear_reg() %>% 
    set_engine("lm") %>% 
    set_mode("regression")
  
  form <- formula(paste(eval(y),"~", eval(x)))
  
  lm_fit <- lm_model %>% 
    fit(form, data=df)
  
  intercept <- summary(lm_fit$fit)$coefficients["(Intercept)",1]
  slope <- summary(lm_fit$fit)$coefficients[x,1]
  
  segments <- perp_segment_coord(df[,x], df[,y], intercept, slope) %>% 
    as.data.frame()
  
  rot_df <- df
  
  rot_df <- rot_df %>% add_column(
    x = sqrt((segments$x1)^2 + (segments$y1 - intercept)^2),
    y = sqrt(
      (segments$x1 - segments$x0)^2 +
        (segments$y1 - segments$y0)^2))
  
  rot_df <- rot_df %>% mutate(x = case_when(
    segments$x1 < 0 ~ -x,
    segments$x1 >= 0 ~ x
  )) %>% 
    mutate(y = case_when(
      segments$y0 < segments$y1 ~ -y,
      segments$y0 >= segments$y1 ~ y
    ))
  
  rot_df
}

#' get_coef
#' Get coefficient from lm() fit
#'
#' @param ft Fit object from lm()
#' @param var Variable for coefficient
#'
#' @return Coefficient
#' @export
#'
#' @examples
get_coef <- function(ft, var="(Intercept)") {
  summary(ft$fit)$coefficients[var ,1]
}



#' get_rsq
#' Get R-Squared from an lm() fit
#'
#' @param ft Fit object from lm()
#' @param digits Digits for rounding
#' 
#' @return
#' @export
#'
#' @examples
get_rsq <- function(ft, digits=3) {
  r_squared <- round(summary(ft$fit)$r.squared, digits=digits)
  
  return(r_squared)
}