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

source("DescribeThisDataset.R")

# DescribeThisDataset(Dataset=Cars_Data,
#                     Individual=T,
#                     ColumnN=NULL,
#                     #HeadOfDataset=FALSE,
#                     #StructureOfDataset=FALSE,
#                     NameOutputFile="Cars_continuous",
#                     Cols=list("hp"),
#                     ColsFormat=list("continuous"),
#                     DetailInformation=TRUE,
#                     PathOutputFolder=PathOutputFolder)

DescribeThisDataset(Dataset=DF_vaccines,
                    Individual=T,
                    ColumnN=NULL,
                    HeadOfDataset=FALSE,
                    StructureOfDataset=FALSE,
                    NameOutputFile="Vaccine_Dataset",
                    Cols=list("vx_admin_date", "vx_dose", "vx_atc", "vx_lot_num"),
                    ColsFormat=list("date", "binary", "categorical", "categorical"),
                    DateFormat_ymd=TRUE,
                    DetailInformation=TRUE)
