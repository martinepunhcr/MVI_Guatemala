# WARNING - Generated by {fusen} from /dev/severity_index.Rmd: do not edit by hand

#' Benefit of doubt aggregation
#' 
#' As used in compind package. This is a wrapper which also returns `x` if `x`
#' only has one column (to avoid errors in Compind).
#' 
#' @param x A numeric vector
#' 
#' @export
#' @examples
#' #
a_bod <- function(x){
  if(ncol(x) == 1){
    return(x[[1]])
  }
  suppressMessages(Compind::ci_bod(x)$ci_bod_est)
}
