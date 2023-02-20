library(DT)

highlight_DT <- function(Xd, Xh, table_caption = NULL, highlight_colour = "#ffc266"){

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

  datatable(
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
    formatStyle(
      columns = 1:ncol_display,
      valueColumns = (ncol_display + 1):ncol(X),
      backgroundColor = styleEqual(c(0,1), styles))

}


# Xd = data.frame(
#   V1 = c(5, -31, -2),
#   V2 = c(-5, -7, 2),
#   V3 = c(4, -10, 22))
#
# Xh <- as.data.frame(Xd < 1)
