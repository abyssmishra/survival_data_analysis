##Code for processing survival data (desiccation, starvation, longevity, etc.)
##(with number of deaths recorded against time)

#installs the pacman package if not already installed, and then loads it
if (!require('pacman')) install.packages('pacman'); library(pacman)
#p_load checks, installs, and loads the specified packages
pacman::p_load(openxlsx,tools)

#prompt for the input excel file with raw data
#(format: 1st row=headers, 1st column=time, 2nd column onwards=data)
i_filename <- file.choose()

###########################################################################
#obtaining the directory address from the input file path
#a_directory <- dirname(i_filename)
#setwd(a_directory)  #set the input file directory as the working directory
#(alternatively, folder.choose can be used to get a user-specified address)
#current active code just uses the address of the input file
###########################################################################

#stores names of the worksheets from the input excel file
sheets <- openxlsx::getSheetNames(i_filename)

#list containing all the input data worksheets as individual dataframes
i_SheetList <- lapply(sheets, openxlsx::read.xlsx, xlsxFile = i_filename)
names(i_SheetList) <- sheets

#initializing the output excel workbook
o_wb <- openxlsx::createWorkbook()

#accessing each input data worksheet (as df) sequentially
for (w_sheet in sheets) {
  
  #active input data worksheet (df)
  i_sheet <- i_SheetList[[w_sheet]]
  
  #accessing the column with input time data (in hours)
  time_col <- i_sheet[1]
  
  #############################################################
  #create output dataframe for the current input data worksheet
  #o_df <- paste0("_", w_sheet, "_")
  #assign(o_df, EMPTY OUTPUT DATAFRAME)
  #get(o_df)
  #############################################################
  
  #highest number of individuals per column from the active input data worksheet (df)
  n_ind <- max(i_sheet[-1],na.rm = TRUE)    #(na.rm disregards NA values)
  
  #creating an output worksheet corresponding to (& named after) the active input sheet
  openxlsx::addWorksheet(o_wb, w_sheet)
  
  #create output dataframe for filling the output datasheet
  o_df <- data.frame(matrix(ncol = ncol(i_sheet), nrow = n_ind))
  
  #assigning column names for output df
  #same as the input sheet, except first one ('time'), which is replaced with 'Individual#'
  colnames(o_df) <- c("Individual#", colnames(i_sheet[-1]))
  
  #filling the first column of output df with individuals numbered from 1:highest number
  o_df["Individual#"] <- 1:n_ind
  
  #accessing each data column (except 'time') in the input active datasheet (df) sequentially
  for (trt in colnames(i_sheet[-1])) {
    
    #active data column (trt) in the active input worksheet (df)
    a_trt <- i_sheet[trt]
    
    #initializing output vector for the active input data column (trt)
    o_vector <- vector()

    #locating the (first occurrence of) complete death in the active input data column 
    last_death <- max(a_trt, na.rm = TRUE)
    #(na.rm disregards the NA values)
    
    #iterate through the data points until last_death in active input data column (trt)
    for (i in 1:(which(a_trt == last_death)[1]-1)) {  
      
      #check for number of new deaths between successive data points
      if (a_trt[i+1,] != a_trt[i,]) {
        n_deaths <- a_trt[i+1,] - a_trt[i,]
        
        #noting down the time of death for all the new deaths observed in this iteration
        for (j in 1:n_deaths) {
          o_vector <- c(o_vector, time_col[i+1,])
        }
      }
    }
    #filling in data from the completed output vector into the active output df
    o_df[,trt][1:length(o_vector)] <- o_vector
  }
  #writing the completed output df into the corresponding worksheet of the output excel file
  openxlsx::writeData(o_wb, w_sheet, o_df)
}

#output filename, based on the input file address and name
o_filename <- paste0(tools::file_path_sans_ext(i_filename), "_processed.xlsx")

#saving the output excel file
openxlsx::saveWorkbook(o_wb, file = o_filename, overwrite = TRUE)