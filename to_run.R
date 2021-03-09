rm(list=ls())

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

source(paste0(thisdir,"/DescribeThisDataset.R"))

#Example

data(mtcars)
Dataset=data.table(mtcars)
Dataset$am=ifelse(Dataset$am==1, "one", "zero")
Dataset$vs=ifelse(Dataset$vs==1, TRUE, FALSE)

# Call 

DescribeThisDataset(Dataset=Dataset,
                    Individual=T,
                    HeadOfDataset=TRUE,
                    StructureOfDataset=TRUE,
                    PathOutputFolder=paste0(thisdir,"/g_describeHTML/"),
                    NameOutputFile="all"
)

DescribeThisDataset(Dataset=Dataset,
                    Individual=T,
                    Cols=list("cyl", "hp"),
                    HeadOfDataset=TRUE,
                    StructureOfDataset=TRUE,
                    PathOutputFolder=paste0(thisdir,"/g_describeHTML/"),
                    NameOutputFile="selected_vars"
)

DescribeThisDataset(Dataset=Dataset,
                    Individual=T,
                    Cols=list("cyl", "hp"),
                    ColsFormat=list("categorical", "continuous"),

)
