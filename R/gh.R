#' gh
#'
#' Delete all columns in data object (data.table, data.frame, or tibble) from data
#'
#' @param opt What result to return, one of outerHTML, innerHTML, href, text, tablelist, tabl, or other html attributes
#' @param remDr remote driver, i.e the one usually named remDr in examples
#' @param xpath xpath of elements to search for
#' @export
gh <- function(opt="outerHTML",obj="remDr", xpath="//*"){
  if(obj=="remDr"){
    remDr <- get("remDr")
    ps1 <- unlist(remDr$getPageSource())
  }else{
    objelem <- get(obj)
    ps1 <- unlist(objelem$getElementAttribute("outerHTML"))
  }
  rs1 <- read_html(ps1)
  rh1 <- html_nodes(rs1,xpath=xpath)
  dotab <- opt %in% c("tablelist","tabl")
  if(isTRUE(dotab)){
    rp1 <- read_html(ps1)
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
