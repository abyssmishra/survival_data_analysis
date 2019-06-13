##Code for arranging processed survival data (survival time recorded for each individual) 
##into format for ANOVA 

#installs the pacman package if not already installed, and then loads it
if (!require('pacman')) install.packages('pacman'); library(pacman)
#p_load checks, installs, and loads the specified packages
pacman::p_load(openxlsx,tools)

#prompt for the input excel file with raw data
#(format: 1st row=headers, 1st column=Individual#, 2nd column onwards=data)
i_filename <- file.choose()
#the output excel file from "survival_data_processing.r" can be used

#stores names of the worksheets from the input excel file
sheets <- openxlsx::getSheetNames(i_filename)

#list containing all the input data worksheets as individual dataframes
i_SheetList <- lapply(sheets, openxlsx::read.xlsx, xlsxFile = i_filename)
names(i_SheetList) <- sheets

#initializing the output excel workbook
o_wb <- openxlsx::createWorkbook()

#accessing each input data worksheet (as df) sequentially
for (w_sheet in sheets) {
  
  #active input data worksheet (df), ignoring the first column (Individual#)
  i_sheet <- i_SheetList[[w_sheet]][-1]
  
  #creating an output worksheet corresponding to (& named after) the active input sheet
  openxlsx::addWorksheet(o_wb, w_sheet)
  
  #create output dataframe for filling the output datasheet
  o_df <- data.frame(matrix(ncol = 2, nrow = sum(!is.na(i_sheet))))
  
  #assigning column names for output df
  colnames(o_df) <- c("Treatment", "Survival duration")
  
  o_trt_vector <- vector()
  
  #accessing each data (trt) column in the input active datasheet (df) sequentially
  for (trt in colnames(i_sheet)) {
    
    #active data column (trt) in the active input worksheet (df)
    a_trt <- i_sheet[trt]
    #number of non-NA datapoints in the active input data column (trt)
    n_data <- sum(!is.na(a_trt))
    #populating the names
    o_trt_vector <- c(o_trt_vector, rep(trt, n_data))
    
  }
  #populating the output dataframe
  o_df[,1][1:length(o_trt_vector)] <- o_trt_vector
  
  #concatenating all the data (columnwise) into a vector (minus the NA values)
  o_data_vector <- na.omit(as.vector(as.matrix(i_sheet)))
  o_df[,2][1:length(o_data_vector)] <- o_data_vector
  
  #writing the completed output df into the corresponding worksheet of the output excel file
  openxlsx::writeData(o_wb, w_sheet, o_df)
}

#output filename, based on the input file address and name
o_filename <- paste0(tools::file_path_sans_ext(i_filename), "_forANOVA.xlsx")

#saving the output excel file
openxlsx::saveWorkbook(o_wb, file = o_filename, overwrite = TRUE)