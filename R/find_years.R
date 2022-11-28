#' Finds the years in which data are available
#'
#' Scans the oisst website for a list of years for which there are data
#'
#'@return vector of years
#'
#'
#'@export
#'


find_years <- function(){

  #url where all data is stored
  dataPath <- "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/"

  # grab xml and scan it
  webPageNode <- xml2::read_html(dataPath)
  webPage <- xml2::xml_text(webPageNode)
  webPage <- strsplit(webPage,"\\s+")
  # pick out file names
  
  index <- sapply(webPage[[1]],grepl,pattern="\\/")
  files <- webPage[[1]][index]
  # now split file names (folder and date) to get folder names
  numberBackSlash <- stringr::str_count(files,"\\/")
  files <- files[numberBackSlash==1]
  folders <- simplify2array(strsplit(files,"\\/"))[1,]
  # trim whitespace
  folders <- stringr::str_trim(folders)
  # folder names are yyyymm. Split to obtain years
  years <- stringr::str_sub(folders,start = 1, end = 4)
  
  return(unique(years))
  
}


