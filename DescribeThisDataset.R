#' DescribeThisDataset
#'
#'
#'
#'
#'
#' @param PathDataset (str) a path that specifies the location/directory of the folder in which dataset of interest is.
#' @param NameDataset (str) name of dateset to be describe. 
#' @param ExtensionDataset (str) could be .RData, .csv
#' @param individual (boolean, default=TRUE). If TRUE, the dataset is at individual level, otherwise it is an aggregate dataset.
#' @param Cols (list, default=ALL) list of names of the columns to be described. 
#' @param HeadOfDataset (boolean, default=TRUE) caption of head of datasets (first 5 rows of dataset)
#' @param NameOutputFolder (str, default=’g_describeHTML‘) name of output folder in which HTLM file is saved.
#' @param NameOutputFile (str, default=’Description_of_NameDataset’)  name of HTML file.



DescribeThisDataset<-function(PathDataset,
                              NameDataset,
                              ExtensionDataset,
                              Individual,
                              Cols=TRUE,
                              HeadOfDataset=TRUE,
                              PathOutputFolder=paste0(PathDataset,"/g_describeHTML"),
                              NameOutputFile=NameDataset){
  
  
  if (!require("htmltools")) install.packages("htmltools")
  library(htmltools)
  if (!require("tableHTML")) install.packages("tableHTML")
  library(tableHTML)
  if (!require("ggplot2")) install.packages("ggplot2") 
  library(ggplot2)
  if (!require("plotly")) install.packages("plotly")
  library(plotly)
  if (!require("rstudioapi")) install.packages("rstudioapi")
  library(rstudioapi)
  if (!require("data.table")) install.packages("data.table")
  library(data.table)
  
  dirinput<- paste0(PathDataset,"/",NameDataset,ExtensionDataset)
  diroutput<-paste0(PathOutputFolder,"/",NameOutputFile,".html")
  
  if(ExtensionDataset==".csv"){
    Dataset<-fread(dirinput)
  }else{
    if(ExtensionDataset==".RData"){
      Dataset<-load(dirinput)
    }
  }
  
  ## Create folders
  suppressWarnings(if (!file.exists(PathOutputFolder)) dir.create(file.path( PathOutputFolder)))
  
  ## title of the html file (title) and list of object to be printed (description)
  title <- h2(NameDataset)
  description <- list()
  
  ## Head
  if(HeadOfDataset==TRUE){
    description <- list(description, p("Head of the dataset:"), tableHTML(head(Dataset)), p(""))
  }
  
  ## Dimension of the dataset
  Database_dim<-dim(Dataset)
  n_of_observations<-Database_dim[1]
  n_of_variables<-Database_dim[2]
  
  description <- list(description, p(paste0("The database is composed by ",n_of_observations,
                                            " observations of ", n_of_variables, " variables.")), p(""))
  
  ## Table Output
  df_output<- data.frame(matrix(ncol = n_of_variables, nrow = 2))
  colnames(df_output)<-names(Dataset)
  rownames(df_output)<-c("unique_count", "missing_count")
  
  for( i in names(Dataset)){
    df_output[1,i]=length(unique(Dataset[,get(i)]))
    df_output[2,i]=sum(is.na(Dataset[,get(i)]))
  }
  
  description <- list(description, p("Summary:"), tableHTML(df_output), p(""))
  
  ##### saving the html file
  save_html(list(title, description), diroutput)
}