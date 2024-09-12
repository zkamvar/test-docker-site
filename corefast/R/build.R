#' @export
build <- function() {
  rmarkdown::render_site(encoding = "UTF-8")
}
