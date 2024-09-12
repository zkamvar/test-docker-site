#' @export
build <- function(path) {
  rmarkdown::render_site(path, encoding = "UTF-8")
}
