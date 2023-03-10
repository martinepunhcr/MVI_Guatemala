# WARNING - Generated by {fusen} from /dev/severity_index.Rmd: do not edit by hand

#' Display indicator analysis
#' 
#' Displays the analysis performed by [f_analyse_indicators()] in an interactive
#' table using the DT package.
#' 
#' @param coin The coin.
#'              
#' @param  filter_to_flagged Logical: if `TRUE` filters to only show indicators with
#' at least one flag.
#' 
#' @importFrom COINr is.coin
#' @importFrom rlang abort
#' 
#' @return An interactive table (DT object).
#' 
#' @export
#' @examples
#' MVI <- f_data_input(file_path = system.file("data_input/data_module-input.xlsx",
#'                                             package = "BuildIndex") )
#' 
#' MVI <- f_analyse_indicators(MVI)
#' 
#' f_display_indicator_analysis(MVI)
f_display_indicator_analysis <- function(coin, filter_to_flagged = TRUE){

  stopifnot(COINr::is.coin(coin))

  Xd <- coin$Analysis$Raw$FlaggedStats
  Xh <- coin$Analysis$Raw$Flags

  if(is.null(Xd) || is.null(Xh)){
    rlang::abort("Indicator analysis not found in coin. Run f_analyse_indicators() first.")
  }

  if(filter_to_flagged){

    # only include rows with at least one flag
    include_rows <- rowSums( Xh[!(names(Xh) %in% c("iCode", "Status"))] ) > 0

    Xd <- Xd[include_rows, ]
    Xh <- Xh[include_rows, ]

  }

  f_highlight_DT(Xd, Xh)
    
}
