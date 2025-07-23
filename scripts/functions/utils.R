# utils.R

create.dir <- function(path) {
  if (!dir.exists(path)) {dir.create(path, recursive = T)}
}
