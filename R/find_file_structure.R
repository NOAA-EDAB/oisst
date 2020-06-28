#' Finds the file Structure of website
#' 
#'Find all subfolders containing data and lists the names of the files within each subfolder
#'
#' @param years numeric vector. List of years in which to obtain file structure for. Default = NULL (find structure for all data)
#'
#'@return list of folders with filenames as contents
#'
#'@examples
#'\dontrun{
#'To find the structure for years 2000, ..., 2010
#'fileStr <- find_file_structure(years = 2000:2010)
#'
#'To find the structure for all data present
#'fileStr <- find_file_structure()

#'}
#'
#'@export


find_file_structure <- function(years=NULL){
  years <- as.character(years)
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
  folders <- as.vector(simplify2array(strsplit(files,"\\/"))[1,])

  # spick out the folder based on the years required
  if (is.null(years)){
    # do nothing
  } else {
    newFolder <- NULL
    for (ayear in years) {
      yf <- stringr::str_match(folders,ayear)
      newFolder <- c(newFolder,folders[!is.na(yf)])
    }
    folders <- newFolder
  }
  

  # loop over each folder and get filenames of contents
  fileStructure <- list()
  for (afol in folders) {
    message(paste0("Processing webpage for yyyymm = ", afol))
    monthDataPath <- paste0(dataPath,afol)
    
    webPageNode <- xml2::read_html(monthDataPath)
    webPage <- xml2::xml_text(webPageNode)
    webPage <- strsplit(webPage,"\\s+")
    # pick out file names
    index <- sapply(webPage[[1]],grepl,pattern="\\.nc")
    files <- webPage[[1]][index]
    files <- strsplit(files,"\\.nc")
    files <- simplify2array(files)[1,]
    files <- paste0(files,".nc")
    fileStructure[[afol]] <- files
  }
  
  return(fileStructure)
  
}


