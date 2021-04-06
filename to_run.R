rm(list=ls())
library(rmarkdown)
library(data.table)

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

source(paste0(thisdir,"/DescribeThisDataset.R"))

#Example
data(mtcars)
Cars_Data=data.table(mtcars)
Cars_Data$am=ifelse(Dataset$am==1, "one", "zero")
Cars_Data$vs=ifelse(Dataset$vs==1, TRUE, FALSE)


# Directories
PathOutputFolder=paste0(thisdir,"/g_describeHTML")
suppressWarnings(if (!file.exists(PathOutputFolder)) dir.create(file.path( PathOutputFolder)))

# Call
render("DescribeThisDataset.Rmd",           
       output_dir=PathOutputFolder,
       output_file="Dataset_description", 
       params=list(Dataset=Cars_Data,
                   Individual=T,
                   HeadOfDataset=TRUE,
                   StructureOfDataset=TRUE,
                   NameOfDataset="Cars Data",
                   Cols=list(),
                   ColsFormat=list())
)               


