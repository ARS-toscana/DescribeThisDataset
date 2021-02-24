rm(list=ls())

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

source(paste0(thisdir,"/DescribeThisDataset.R"))
# TEst run function:

DescribeThisDataset(PathDataset=paste0(thisdir,"/input"),
                    NameDataset="mtcars",
                    ExtensionDataset=".csv",
                    Individual=T,
                    Cols,
                    HeadOfDataset=TRUE,
                    PathOutputFolder=paste0(thisdir,"/g_describeHTML/"),
                    NameOutputFile="first_mtcars"
)
