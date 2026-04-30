library(yaml)
library(dplyr)
library(tidyr)
library(purrr)

# to be filled in
errors <- list()

# get the species files
species <- list.files("species", pattern = "qmd", full.names = TRUE)

# a function to turn one species file into a tibble
make_sp_code_data <- function(one_file) {
  one_sp <- split_to_tbl(one_file)
  
  sp_yaml <- one_sp |> filter(type == "yaml") |>
    unnest(params) |>
    pull(params)
  
  sp_yaml$alternate_codes <- 
    ifelse(length(sp_yaml$alternate_codes)==0,
           "",
           sp_yaml$alternate_codes)
  
  
  with(
    sp_yaml,
    tibble(
      species = species,
      accepted_code = accepted_code,
      diminutive = diminutive,
      alternate_codes = list(alternate_codes),
      alternate_diminutives = list(alternate_diminutives)
    )
  )
}

# map to loop over all of the files
sp_code_dat <- map(species, make_sp_code_data) |>
  list_rbind()

# check for conflicts in accepted codes
accepted_conflict <- 
  sp_code_dat |>
  group_by(accepted_code) |>
  mutate(len = n()) |>
  ungroup() |>
  filter(len > 1) |>
  select(species, accepted_code) |>
  arrange(accepted_code)

# if there exists a conflict file from the last check
# remove it
if(exists("data/accepted_conflict.csv")){
  file.remove("data/accepted_conflict.csv")
}

# if we have a conflict, fill it in
if(nrow(accepted_conflict) > 0) {
  errors$conflict_between_accepted_codes <- "Yes"
  write_csv(accepted_conflict, "data/accepted_conflict.csv")
}else{
  errors$conflict_between_accepted_codes <- "No"
}

# check for conflicts in diminutive codes

# check for conflicts between accepted codes and old alt codes

# check for conflicts between diminutive codes and old alt diminutive codes

# OK, what errors did we have?
errors