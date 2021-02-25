# DescribeThisDataset

## Specifications of DescribeThisDataset

-	#### Context

When there are some errors in the script, you may want to look at the content of the datasets produced. This function can look into datasets already produced and give  an idea of the content in sense of structure, missing data, format of variables, distribution of numeric variables, ecc. The output of the function is an HTML file, saved in folder create by function, that describes all you need to know to figure out problems in the datasets. 

-	#### Purpose: 

  Produce an HTLM file which deeply describe the content of dataset


-	#### Structure of input data

   A dataset in .csv or .RData format.


-	 #### Main parameters:

      -	NameDataset (str): name of dateset to be described
      -	Individual (bool, default='TRUE'): TRUE if the dataset contains one row per unit of observation 
      -	ColumnN (string): if Individual is FALSE, this is the name of the column that contains the weight of the row 
      -	Cols (str, default='ALL'): columns in the dataset to be described
      -	ColsNumeric (list of strings, optional): columns to be considered as numeric
      -	ColsCategorical (list of strings, optional): columns to be considered as categrical
      -	ColsBinary (list of strings, optional): columns to be considered as binary
      -	ColsDates (list of strings, optional): columns to be considered as dates
      -	ColsBool (list of strings, optional): columns to be considered as boolean
      -	HeadOfDataset (bool, default='FALSE'): If this is TRUE, the first 5 rows of the dataset are printed in the HTML output file
      -	PathOutputFolder (str):  name of output folder in which the HTLM file is saved
      -	NameOutputFile(str, default=’Description_of_NameDataset’):  name of HTML file

-	#### Structure of output data

An HTML file.

- #### Action
     - Check that the assumptions of the parameters are correct (eg that all required parameters are included, that their assignment is coherent, etc), otherwise throw a error
     - Extract formats of variables contined  (str(dataset))
     - If HeadOfDataset ==TRUE, print head
     - For each type of variables process different outputs:
		 - For numeric variables: boxplot, distribution statistics (mean, mode, …), missing values, histogram 
		 - For categorical variables: compute n, percent for each modes, compute n of missing values, graph 
		 - For dummy variables: compute n, percent for both mode, compute n of missing values, check name of the modes          
     - Put together all the outputs in a HTML file
     - Write this HTML file as NameOutputFile in NameOutputFolder
    
