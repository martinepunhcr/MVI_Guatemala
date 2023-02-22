# UTILS

source_modules <- function(){

  mod_paths <- c("m1_data_input.R", "m2_analysis_selection.R", "m3_construction.R",
                 "m4_reweighting.R", "m5_export.R")

  mod_paths <- paste0("./R/", mod_paths)

  junk <- lapply(mod_paths, source, echo = FALSE)

}

# quick simulation of building a coin, to be used with testing export
f_simulate_build <- function(){

  coin <- f_data_input("./data_input/data_module-input.xlsx")

  coin <- f_analyse_indicators(coin)

  coin <- f_remove_indicators(coin, c("S.G.3", "A.M.1"))

  coin <- f_build_index(coin)

  coin <- f_change_weights(coin, w = list(Amenazas = 2, Cap_Resp = 0.5))

  coin

}
