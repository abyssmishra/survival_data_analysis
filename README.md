# survival_data_analysis
R codes for processing and analyzing survival data (longevity, desiccation resistance, starvation resistance, etc.)

Files:
1) _survial_data_processing.r_ 

Input: User-selected .xlsx file, with any number of worksheets. Each worksheet should have the first column as time (hours/days/etc.), followed by data in subsequent columns (number of deaths recorded against the corresponding time). The first row should have column names (headers).

Output: A .xlsx file with the same name as the input file, with a "processed" suffix. Contains the survival time data for each indivdual, with the same sheet names and data column names as the input file. The first column in each worksheet (corresponding to the "Time" column in input file) gets replaced with an "Individual#" column.
 
