# helper functions etc

library(dplyr)

tidy_treatment_details <- function(X){

  X <- dplyr::rename(
    X,
    "Pass_0" = "check_SkewKurt0.Pass",
    "Skew_0" = "check_SkewKurt0.Skew",
    "Kurt_0" = "check_SkewKurt0.Kurt",
    "Pass_1" = "check_SkewKurt1.Pass",
    "Skew_1" = "check_SkewKurt1.Skew",
    "Kurt_1" = "check_SkewKurt1.Kurt"
  )

  # General column for declaring the data treatment performed.
  # Declare number of Winsorised points.
  X$Treatment <- ifelse(X$Pass_0, "-", paste0("Win: ", X$winsorise.nwin))

  # Fill in the blanks for pass, skew and kurt ----

  # If indicator passed at 0, it must have passed at 1
  X$Pass_1 <- X$Pass_1 | X$Pass_0

  # Bring over skew and kurtosis values from 0 to 1
  #  for indicators that passed at 0
  X$Skew_1[X$Pass_0] <- X$Skew_0[X$Pass_0]
  X$Kurt_1[X$Pass_0] <- X$Kurt_0[X$Pass_0]


  # If the log transformation is invoked anywhere ----
  # We have to make some further adjustments

  if (!is.null(X$check_SkewKurt2.Pass)) {

    # record instances of Log transformation
    X$Treatment <- ifelse(X$Pass_1, X$Treatment, "Log")

    # Bring any skew, kurt and pass from 2 to 1
    X$Skew_1[!X$Pass_1] <- X$check_SkewKurt2.Skew[!X$Pass_1]
    X$Kurt_1[!X$Pass_1] <- X$check_SkewKurt2.Kurt[!X$Pass_1]

    X$Pass_1 <- X$Pass_1 | X$check_SkewKurt2.Pass

  }

  #----

  X <- X[c("iCode", "Pass_0", "Skew_0", "Kurt_0", "Treatment", "Pass_1", "Skew_1", "Kurt_1")]

  # round to 2 decimal places
  COINr::round_df(X, 2)

}
