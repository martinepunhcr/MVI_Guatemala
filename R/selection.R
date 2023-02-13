# Functions for code modules

get_indicator_flags <- function(coin, dset){

  stopifnot(is.coin(coin))

  # get stats
  df_stats <- get_stats(coin, dset = dset,
                        t_skew = 2, t_kurt = 3.5,
                        t_avail = 0.66,
                        t_zero = 0.66,
                        t_unq = 0.5,
                        out2 = "df")

  df_disp <- df_stats[c("iCode", "Frc.Avail", "Frc.Same")]

  df_disp$SkewKurt <- paste0(signif(df_stats$Skew, 3)," / ", signif(df_stats$Kurt, 3))

  # we find which iCodes are flagged for which things
  # prep a df
  df_flag <- data.frame(iCode = df_disp$iCode)

  # in the following TRUE means it is flagged as having a problem
  df_flag$Frc.Avail <- df_stats$Flag.Avail == "LOW"
  df_flag$Frc.Same <- df_stats$Frc.Same > 0.5
  df_flag$SkewKurt <- df_stats$Flag.SkewKurt == "OUT"

  df_collinear <- get_corr_flags(coin, dset = dset, cor_thresh = 0.9, thresh_type = "high",
                              grouplev = 2, cortype = "spearman", use_directions = TRUE)
  df_flag$Collinear <- df_flag$iCode %in% c(df_collinear$Ind1, df_collinear$Ind2)

  df_negcorr <- get_corr_flags(coin, dset = dset, cor_thresh = -0.4, thresh_type = "low",
                               grouplev = 2, cortype = "spearman", use_directions = TRUE)
  df_flag$NegCorr <- df_flag$iCode %in% c(df_negcorr$Ind1, df_negcorr$Ind2)

  # # Total number of flags
  # df_flag$FlagCount <- rowSums(df_flag[-1])
  # filter
  df_flag <- df_flag[rowSums(df_flag[-1]) > 0 ,]

  # assemble a big table for viewing (to probably adjust yet)
  df_disp <- df_disp[match(df_flag$iCode, df_disp$iCode), ]

  # add correlation entries
  pairs_colin <- gather_correlations(df_collinear)
  df_disp$Collinear <- pairs_colin[match(df_disp$iCode, names(pairs_colin))]
  pairs_neg <- gather_correlations(df_negcorr)
  df_disp$NegCorr <- pairs_neg[match(df_disp$iCode, names(pairs_neg))]

  list(df_disp = df_disp,
       df_flag = df_flag)
}

gather_correlations <- function(X){

  Xpairs <- data.frame(v1 = c(X$Ind1, X$Ind2),
                       v2 = c(X$Ind2, X$Ind1))

  Xpairs <- Xpairs[order(Xpairs$v1, Xpairs$v2), ]

  tapply(Xpairs$v2, Xpairs$v1, paste0, collapse = ", ")

}
