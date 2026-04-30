#' ------------------------
#' Generate a data CSV for all species
#' ------------------------

library(yaml)
library(dplyr)
library(tidyr)
library(purrr)
library(lightparser)

# get the species files
species <- list.files("species", pattern = "qmd", full.names = TRUE)

# we might need to make some list elements NA if they are empty
make_list_na <- function(x){
  if(length(x)==0) return("")
  return(x)
}

# a function to turn one species file into a tibble
make_sp_data <- function(one_file) {
  one_sp <- split_to_tbl(one_file)
  
  sp_yaml <- one_sp |> filter(type == "yaml") |>
    unnest(params) |>
    pull(params)
  
  pivot_wider(stack(sp_yaml), 
              names_from = "ind", 
              values_from = "values",
              values_fn = \(x){paste0(x, collapse = ";")}) |>
    select(-image)
  
}

# let it rip and write out a csv
map(species, make_sp_data) |>
  list_rbind() |>
  write_csv("data/allspecies.csv")
