# view is a wrapper function for print(x, "view"). Allows supports "browser" or "pander" as well.
view <- function(x, method = "viewer", silent = FALSE, footer = FALSE, 
                 file = "", append = FALSE, report.title = NA, ...) {
  
  if ("summarytools" %in% class(x))
    print.summarytools(x, method = method, silent = silent, footer = footer, 
                       file = file, append = append, report.title = report.title, ...)
  
  else if ("by" %in% class(x) && attr(x[[1]], "st.type") %in% c("freq", "descr")) {
    len <- length(x)
    if (method %in% c("viewer", "browser", "html_file")) {
      file <- ifelse(file == "", paste0(tempfile(),".html"), file)
      print.summarytools(x[[1]], method = method, silent = silent,
                         footer = FALSE, file = file, append = FALSE, 
                         report.title = report.title, group.only = FALSE, ...)
      for (i in 2:len) {
        print.summarytools(x[[i]], method = method, silent = silent, 
                           footer = ifelse(i == len, footer, FALSE), 
                           file = file, append = TRUE, group.only = TRUE, ...)
      }
    } 
    
    else if (method == "pander") {
      print.summarytools(x[[1]], method = "pander", silent = silent, 
                         report.title = report.title,
                         file = file, append = FALSE, group.only = FALSE, ...)
      for (i in 2:len) {
        print.summarytools(x[[i]], method = "pander", silent = silent,
                           file = file, append = ifelse(file == "", FALSE, TRUE), 
                           report.title = NA, group.only = TRUE, ...)
      }
    }
  }
  else message(paste("x must either be a summarytools object created with freq(), descr(),",
                     "ctable(), or a list of freq() / descr() objects created using by().",
                     "Support for by() used with ctable() is due for a later release."))
}