

DescribeThisDataset <- function(Dataset,
                                Individual=T,
                                ColumnN=NULL,
                                HeadOfDataset=FALSE,
                                StructureOfDataset=FALSE,
                                NameOutputFile="Dataset",
                                Cols=list(),
                                ColsFormat=list(),
                                DetailInformation=TRUE,
                                PathOutputFolder){
  
  
  
  
# library
if (!require("ggplot2")) install.packages("ggplot2") 
library(ggplot2)
if (!require("data.table")) install.packages("data.table")
library(data.table)


## check that Cols and ColsFormat is a list 
if (!inherits(Cols, "list")){  
  stop("parameter Cols must be a list")
}

if (!inherits(ColsFormat, "list")){  
  stop("parameter ColsFormat must be a list")
}

## check if Cols and ColsFormat have the same length
if (length(Cols)!=length(ColsFormat)){  
  stop("parameter Cols must have the same length as ColsFormat")
}
## Datatable
if(!is.data.table(Dataset)){
  Dataset=data.table(Dataset)
}

## Dimension of the dataset
Database_dim<-dim(Dataset)
n_of_observations<-Database_dim[1]
n_of_variables<-Database_dim[2]

## Table Output
row_of_df_output=4
df_output<- data.frame(matrix(ncol = n_of_variables, nrow = row_of_df_output))
colnames(df_output)<-names(Dataset)
rownames(df_output)<-c("missing_count", "missing_percent", "unique_count", "unique_rate")

for( i in names(Dataset)){
  df_output[1,i]=sum(is.na(Dataset[,get(i)]))
  df_output[2,i]=round((sum(is.na(Dataset[,get(i)]))/n_of_observations)*100, 2)
  df_output[3,i]=length(unique(Dataset[,get(i)]))
  df_output[4,i]=round(length(unique(Dataset[,get(i)]))/n_of_observations, 2)
}

## check if the format is correct
for(i in names(Dataset)){}
  
  
render("DescribeThisDataset.Rmd",           
       output_dir=PathOutputFolder,
       output_file=NameOutputFile, 
       params=list(Dataset=Dataset,
                   Individual=Individual,
                   ColumnN=ColumnN,
                   HeadOfDataset=HeadOfDataset,
                   StructureOfDataset=StructureOfDataset,
                   NameOfDataset=NameOutputFile,
                   Cols= Cols,
                   ColsFormat=ColsFormat,
                   DetailInformation=DetailInformation,
                   df_output=df_output))
}
