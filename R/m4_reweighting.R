# MODULE 4: Reweighting

# Required packages -------------------------------------------------------

library(COINr)

# Functions ---------------------------------------------------------------

# Function that takes some new weights and regenerates the coin.
#
# The weights `w` can either be a named list with names as iCodes and values
# the new weights, OR as a data frame with columns "iCode" and "Weight" with
# codes and corresponding weights.
# In both cases a subset of weight-code pairs can be specified.
# E.g. `list("Salud" = 0.5, Amenazas = 0.8)`.
#
# OR set w = "equal" for equal weights everywhere, or w = "original" to use the
# weights that were input with the input data.
#
# Remember that weights are relative within aggregation groups.
#
# Outputs a coin.
#
f_change_weights <- function(coin, w){

  stopifnot(is.coin(coin))

  # Get weights that were last used to aggregate ----

  # special case: reset or make equal
  if(is.character(w)){

    stopifnot(length(w) == 1)

    if(w == "equal"){
      w_new <- f_get_equal_weights(coin)
    } else if (w == "original"){
      w_new <- coin$Meta$Weights$Original
    }

    coin$Log$Aggregate$w <- w_new
    return(Regen(coin, from = "Aggregate"))
  }

  w_new <- f_get_last_weights(coin)

  # Alter weights based on input type ----

  if(is.data.frame(w)){

    stopifnot(all(c("iCode", "Weight") %in% names(w)),
              all(w$iCode %in% w_new$iCode),
              is.numeric(w$Weight))

    # subst new weights in
    w_new$Weight[match(w$iCode, w_new$iCode)] <- w$Weight

  } else if (is.list(w)){

    stopifnot(all(names(w) %in% w_new$iCode),
              all(sapply(w, is.numeric)),
              all(lengths(w) == 1))

    # subst new weights in
    w_new$Weight[match(names(w), w_new$iCode)] <- as.numeric(w)

  }

  # Regen with new weights ----

  coin$Log$Aggregate$w <- w_new

  Regen(coin, from = "Aggregate")


}


# returns a data frame of equal weights
f_get_equal_weights <- function(coin){

  w <- coin$Meta$Weights$Original
  stopifnot(!is.null(w))

  w$Weight <- 1

  w
}

# Returns the last set of weights used when aggregating the index.
f_get_last_weights <- function(coin){

  w_log <- coin$Log$Aggregate$w

  if(is.null(w_log)){

    w_new <- coin$Meta$Weights$Original

  } else if (is.character(w_log)){

    w_new <- coin$Meta$Weights[[w_log]]

  } else if (is.data.frame(w_log)){

    w_new <- w_log
  } else {
    abort("Weights not recognised at coin$Log$Aggregate$w")
  }

  stopifnot(is.data.frame(w_new))

  w_new

}
