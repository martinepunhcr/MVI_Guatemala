# WARNING - Generated by {fusen} from /dev/severity_index.Rmd: do not edit by hand

#' Highlight Data Table
#' 
#' Generic function for creating an interactive table with input df `Xd`, and
#' with cells highlighted by an equivalently sized logical df `Xh`.
#' This is used for displaying the output of `f_analyse_indicators()`.
#' 
#' @return A DT object
#' 
#' @export
#' @examples
#' #f_highlight_DT()
f_highlight_DT <- function(Xd, 
                           Xh, 
                           table_caption = NULL, 
                           highlight_colour = "#ffc266"){

  stopifnot(identical(dim(Xd), dim(Xh)))

  ncol_display <- ncol(Xd)

  Xh_numeric <- lapply(Xh, function(x){
    if(is.logical(x)){
      as.numeric(x)
    } else {
      x
    }
  }) |> as.data.frame()

  X <- cbind(Xd, Xh_numeric)

  styles <- c("white", highlight_colour)

  DT::datatable(
    X,
    rownames = FALSE,
    caption = table_caption,
    options = list(
      columnDefs = list(
        list(
          visible=FALSE,
          targets=ncol_display:(ncol(X)-1)
        )
      )
    )
  ) |>
    DT::formatStyle(
      columns = 1:ncol_display,
      valueColumns = (ncol_display + 1):ncol(X),
      backgroundColor = DT::styleEqual(c(0,1), styles))
    
}
