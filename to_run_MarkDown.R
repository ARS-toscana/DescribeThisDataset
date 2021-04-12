rm(list=ls())
if(!require(rmarkdown)){install.packages("rmarkdown")}
library(rmarkdown)


if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

inp=paste0(thisdir, "/DescribeThisDataset_MarkDown.Rmd")



data(mtcars)
Dataset=mtcars

render(inp)
