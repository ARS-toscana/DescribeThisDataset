rm(list=ls())

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

source(paste0(thisdir,"/DescribeThisDataset.R"))

#Example

data(mtcars)
Dataset=data.table(mtcars)

# Call 

DescribeThisDataset(Dataset=Dataset,
                    Individual=T,
                    #Cols=list(),
                    HeadOfDataset=TRUE,
                    PathOutputFolder=paste0(thisdir,"/g_describeHTML/"),
                    NameOutputFile=""
)
