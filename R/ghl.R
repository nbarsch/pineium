#' ghl
#'
#' Return specified data from a page source
#'
#' @param opt What result to return, one of outerHTML, innerHTML, href, text, tablelist, tabl, or other html attributes
#' @param ps page source of page to parse
#' @param xpath xpath of elements to search for
#' @export
ghl <- function(opt="outerHTML",ps, xpath="//*"){
  library(xml2)
  library(rvest)
  rs1 <- read_html(ps)
  rh1 <- html_nodes(rs1,xpath=xpath)
  dotab <- opt %in% c("tablelist","tabl")
  if(isTRUE(dotab)){
    rp1 <- read_html(ps)
    ra1 <- html_table(rp1)
  }else{
    if(opt=="outerHTML"){
      ra1 <- as.character(rh1)
    }else{
      if(opt!="text"){
        ra1 <- html_attr(rh1,opt)
      }else{
        ra1 <- html_text(rh1)
      }
    }
  }
  return(ra1)
}
