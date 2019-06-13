# survival_data_analysis
R codes for processing and analyzing survival data (longevity, desiccation resistance, starvation resistance, etc.)

Files:
1) _survial_data_processing.r_ 

Input: (see sample_1.xlsx)
User-selected .xlsx file, with any number of worksheets. Each worksheet should have the first column as time (hours/days/etc.), followed by data in subsequent columns (cumulative number of deaths recorded against the corresponding time). The first row should have column names (headers). 

Output: (see sample_1_processed.xlsx)
A .xlsx file with the same name as the input file + "processed" suffix. Contains the survival duration data for each indivdual, with the same sheet names and data column names as the input file. The first column in each worksheet (corresponding to the "Time" column in input file) gets replaced with an "Individual#" column.
 

2) _survial_data_forANOVA.r_ 

Input: (see sample_1_processed.xlsx, the output of _survival_data_processing.r)
User-selected .xlsx file, with any number of worksheets. Each worksheet should have the first column as Individual#, followed by data in subsequent columns (survival duration). The first row should have column names (headers). 

Output: (see sample_1_processed_forANOVA.xlsx)
A .xlsx file with the same name as the input file + "forANOVA" suffix. Arranges the survival duration data into two columns, with the same sheet names and data column names as the input file. The first column in each worksheet has the name of the treatments (data column names in the input file), and the second column has the corresponding survival data.
