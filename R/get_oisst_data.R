#' Get oisst data
#'
#' Pulls data from NOAAs Optimum Interpolation Sea Surface Temperature (OISST) website and downloads to local machine
#' 
#' @param years Numeric vector. Years of data to download. Default = 2000. options: NULL (All data is downloaded)
#' @param outputStructure Character string. Determines how downloaded data will be structured. Default = NULL (All files downloaded to a single directory), options: "Year" (Data downloaded into Yearly folders),"Month" (Downloaded into Monthly Folders)
#' @param outputDir Character string. Full path to local machine where output files will be downloaded
#'
#'@return Nothing. Files downloaded
#'
#'@examples
#'\dontrun{
#'
#'Download years 2000, ..., 2010 into yearly folder within the "output" folder in current wd
#'get_oisst_data(years=2000:2010,outputStructure="year",outputDir=here::here("output"))
#'
#'Download years 2000, ..., 2005 into a single folder within the "output" folder in current wd
#'get_oisst_data(years=2000:2005,outputStructure=NULL,outputDir=here::here("output"))
#'
#'Download all data into monthly folder within the "output" folder in current wd
#'get_oisst_data(years=NULL,outputStructure="month",outputDir=here::here("output"))
#'}
#'
#'@export
#'


get_oisst_data <- function(years=2000,outputStructure=NULL,outputDir){

  # obtains file structure for years requested
  if (is.null(years)) { # entire data set
    fileStructure <- find_file_structure()
  } else {
    fileStructure <- find_file_structure(years)
  }

  # ouput folder is declared by user
  # This is created on users machine
  if(!dir.exists(outputDir)){
    dir.create(outputDir,recursive=TRUE)
  }
  # yearly or monthly folders created
  if (!is.null(outputStructure)) {
    if (tolower(outputStructure) == "year") {
      for (ayear in years) {
        if(!dir.exists(file.path(outputDir,ayear))){
          dir.create(file.path(outputDir,ayear),recursive=TRUE)
        } 
      }
    } else if (tolower(outputStructure) == "month") {
      for (im in 1:12) {
        if(!dir.exists(file.path(outputDir,sprintf("%02d",im)))){
          dir.create(file.path(outputDir,sprintf("%02d",im)),recursive=TRUE)
        } 
      }
    } else  {
      stop("outputStructure must either be NULL, Year, Month")
    }
  }

  #url where all data is stored
  dataPath <- "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr"

  message("This could take a while ...")
  message("Each Daily nc file is ~ 1.6 MB")
  for (afol in names(fileStructure)) {
    message(paste0("Processing download of daily files files for yyyymm = ", afol))
    
    if (!is.null(outputStructure)) {
      if (tolower(outputStructure) == "year") {
        # folder names are yyyymm. Split to obtain years ....
        folPath <- stringr::str_sub(afol,start = 1, end = 4)
      } else if (tolower(outputStructure) == "month") {
        # ... or months
        folPath <- stringr::str_sub(afol,start = 5, end = 6)
      }
    }
    
    # list of filenames from the current folder in the loop
    fileNames <- fileStructure[[afol]]
    
    for (afname in fileNames) {
      # path of file to download
       fpath <- file.path(dataPath,afol,afname)
       # path of where to save file. Dependent on input argument
       if (is.null(outputStructure)) {
         destfile <- file.path(outputDir,afname)
       } else { # use year or month 
         destfile <- file.path(outputDir,folPath,afname)
       }

       # get file, catch error for missing file
       result <- tryCatch(
         {
           downloader::download(fpath,destfile=destfile,quiet=TRUE)
           res <- TRUE
         },
         error = function(e){
           message(paste0("No data for ",afname))
           return(FALSE)
         } ,
         warning = function(w) return(FALSE)
       )
       if (!result) {
         next
       }
      
    }
    
  }

}


