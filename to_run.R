rm(list=ls())
library(rmarkdown)
library(data.table)
library(lubridate)
#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

source(paste0(thisdir,"/DescribeThisDataset.R"))

# Directories
PathOutputFolder=paste0(thisdir,"/g_describeHTML")
suppressWarnings(if (!file.exists(PathOutputFolder)) dir.create(file.path( PathOutputFolder)))





#Example Cars
data(mtcars)
Cars_Data=data.table(mtcars)
Cars_Data$am=ifelse(Cars_Data$am==1, "one", "zero")
Cars_Data$vs=ifelse(Cars_Data$vs==1, TRUE, FALSE)
Cars_Data[1, "am"]=NA

#Example Vaccines
DF_vaccines<-fread(paste0(thisdir,"/input/VACCINES.csv"))
DF_vaccines$vx_dose=ifelse(!(DF_vaccines$vx_dose==1 |DF_vaccines$vx_dose==2), 1, DF_vaccines$vx_dose)
DF_vaccines[20:50,"vx_dose"]=NA
DF_vaccines$vx_record_date<-ymd(DF_vaccines$vx_record_date)


# Call
render("DescribeThisDataset.Rmd",           
       output_dir=PathOutputFolder,
       output_file="Cars_Dataset_Description", 
       params=list(Dataset=Cars_Data,
                   Individual=T,
                   ColumnN=NULL,
                   HeadOfDataset=TRUE,
                   StructureOfDataset=TRUE,
                   NameOfDataset="Cars Dataset",
                   Cols=list(),
                   ColsFormat=list(),
                   DetailInformation=TRUE)
)  


# Call
render("DescribeThisDataset.Rmd",           
       output_dir=PathOutputFolder,
       output_file="Vaccines_Dataset_Description", 
       params=list(Dataset=DF_vaccines,
                   Individual=T,
                   ColumnN=NULL,
                   HeadOfDataset=TRUE,
                   StructureOfDataset=TRUE,
                   NameOfDataset="Vaccines Dataset",
                   Cols=list("vx_record_date", "vx_atc","vx_dose", "vx_manufacturer"),
                   ColsFormat=list("date", "categorical", "binary", "categorical"),
                   DetailInformation=TRUE)
)               


