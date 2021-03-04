#' DescribeThisDataset
#'
#'
#'
#'
#'
#' @param Dataset (data.table/data.frame) a dataset to be described.
#' @param individual (boolean, default=TRUE). If TRUE, the dataset is at individual level, otherwise it is an aggregate dataset.
#' @param Cols (list, default=ALL) list of names of the columns to be described. 
#' @param HeadOfDataset (boolean, default=TRUE) caption of head of datasets (first 5 rows of dataset)
#' @param NameOutputFolder (str, default=’g_describeHTML‘) name of output folder in which HTLM file is saved.
#' @param NameOutputFile (str, default=’Description_of_NameDataset’)  name of HTML file.



DescribeThisDataset<-function(Dataset,
                              Individual,
                              #Cols=list(),
                              HeadOfDataset=TRUE,
                              PathOutputFolder,
                              NameOutputFile=""
                              ){
  
  
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
  
  ## Name output
  if(NameOutputFile==""){
    NameOutputFile=paste0("Description_of_",deparse(substitute(Dataset)))
  }
  
  ## Directory
  diroutput<-paste0(PathOutputFolder,"/",NameOutputFile,".html")
  
  ## Create folders
  suppressWarnings(if (!file.exists(PathOutputFolder)) dir.create(file.path( PathOutputFolder)))
  
  ## title of the html file (title) and list of object to be printed (description)
  title <- h2(deparse(substitute(Dataset)))
  description <- list()
  
  ## Head
  if(HeadOfDataset==TRUE){
    description <- list(description, p("Head of the dataset:"), tableHTML(head(Dataset)), p(""))
  }
  
  ## Structure
  structure<-as.matrix(capture.output(str(Dataset)))
  description <- list(description, p("Structure of the dataset:"), tableHTML(structure), p(""))
  
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
  
  ## Variable
  
  #l<-names(Dataset)
  
  for(i in names(Dataset)){
    
    if(df_output[1,i]<=10){
      
      p=ggplot(Dataset, aes_string(x=i))+
        geom_bar()
      
      plot<-ggplotly(p)
      description <- list(description, p(paste0("Bar graph of ",i, ":")), plot, p(""))
    }
    if(df_output[1,i]>10 & df_output[1,i]<=50){
      
      p=ggplot(Dataset, aes_string(x=i))+
        geom_histogram()
      
      plot<-ggplotly(p)
      description <- list(description, p(paste0("Histogram of ",i, ":")), plot, p(""))
    }
    if(df_output[1,i]>50){
      
      p=ggplot(Dataset, aes_string(x=i))+
        geom_density()
      
      plot<-ggplotly(p)
      description <- list(description, p(paste0("Density of ",i, ":")), plot, p(""))
    }
    
  }
  
  ##### saving the html file
  save_html(list(title, description), diroutput)
}