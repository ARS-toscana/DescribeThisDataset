#' DescribeThisDataset
#'
#'
#'
#'
#'
#' @param Dataset (data.table/data.frame) a dataset to be described.
#' @param Individual (boolean, default=TRUE). If TRUE, the dataset is at individual level, otherwise it is an aggregate dataset.
#' @param ColumnN (string): if individual is FALSE, this is the name of the column that contains the weight of the row
#' @param Cols (list, default=ALL) list of names of the columns to be described.
#' @param ColsFormat (list, default=list()) list of the format of the columns to be described. 
#' @param HeadOfDataset (boolean, default=FALSE) caption of head of datasets (first 5 rows of dataset)
#' @param DetailInformation (boolean, default=FALSE) add also figure in the output
#' @param StructureOfDataset (boolean, default=TRUE) if TRUE returns the output of the "struct" function
#' @param PathOutputFolder (str, default= paste0(thisdir,"/g_describeHTML")) name of output folder in which HTLM file is saved.
#' @param NameOutputFile (str, default=’Description_of_NameDataset’)  name of HTML file.



DescribeThisDataset<-function(Dataset,
                              Individual=TRUE,
                              #ColumnN,
                              Cols= NULL,
                              ColsFormat= NULL,
                              HeadOfDataset=FALSE,
                              DetailInformation=TRUE,
                              StructureOfDataset=TRUE,
                              PathOutputFolder="",
                              NameOutputFile=""){ 
  
  
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
  
  ## Datatable
  if(!is.data.table(Dataset)){
    Dataset=data.table(Dataset)
  }
  
  
  ## Name output
  if(NameOutputFile==""){
    NameOutputFile=paste0("Description_of_",deparse(substitute(Dataset)))
  }
  
  ## Directory
  if(PathOutputFolder==""){
    thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
    thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
    PathOutputFolder=paste0(thisdir,"/g_describeHTML")
  }
  diroutput<-paste0(PathOutputFolder,"/",NameOutputFile,".html")
  
  ## Create folders
  suppressWarnings(if (!file.exists(PathOutputFolder)) dir.create(file.path( PathOutputFolder)))
  
  ## title of the html file (title) and list of object to be printed (description)
  title <- h1(deparse(substitute(Dataset)))
  description <- list()
  
  ## Dimension of the dataset
  Database_dim<-dim(Dataset)
  n_of_observations<-Database_dim[1]
  n_of_variables<-Database_dim[2]
  description <- list(description, p(paste0("The database is composed by ",n_of_observations,
                                            " observations of ", n_of_variables, " variables.")), p(""))
  
  ## Head
  if(HeadOfDataset==TRUE){
    t=tableHTML(head(Dataset), widths = rep(70, n_of_variables+1))
    t=add_css_row(t, css = list('background-color', '#f2f2f2'), rows = odd(1:7))
    description <- list(description, h4("Head of the dataset:"), t, p(""))
  }
  
  ## Structure
  if(StructureOfDataset==TRUE){
    structure<-as.matrix(capture.output(str(Dataset)))
    structure=as.matrix(structure[2:(nrow(structure)-1),])
    t=tableHTML(structure)
    t=add_css_row(t, css = list('background-color', '#f2f2f2'), rows = odd(1:(n_of_variables+1)))
    description <- list(description, h4("Structure of the dataset:"), t, p(""))
  }
  
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
  
  t=tableHTML(df_output, widths = rep(70, n_of_variables+1))
  t=add_css_row(t, css = list('background-color', '#f2f2f2'), rows = odd(1:5))
  description <- list(description, h4("Missing and Unique values:"), t, p(""))
  
  
  #############################################################################
  #############################   Boolean   ###################################  
  ############################################################################# 
  
  specified_vars = !is.null(Cols)
  specified_format = !is.null(ColsFormat)
  
  a= !Individual
  
  b= Individual & !specified_vars & DetailInformation
  c= Individual & specified_vars & !specified_format & DetailInformation
  d= Individual & specified_vars & specified_format & DetailInformation
  
  e= Individual & !specified_vars & !DetailInformation
  f= Individual & specified_vars & !specified_format & !DetailInformation
  g= Individual & specified_vars & specified_format & !DetailInformation
  
  
  # Non-Individual
  if(a){
    
  }
  
  # Individual / Non-specified Vars / Detailed Information
  if(b){
    for(i in names(Dataset)){
      
      if(df_output["unique_count",i]<=10){
        
        p=ggplot(Dataset, aes_string(x=i))+
          geom_bar()
        
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Bar graph of ",i, ":")), plot, p(""))
      }
      if(df_output["unique_count",i]>10 & df_output["unique_count",i]<=50){
        
        p=ggplot(Dataset, aes_string(x=i))+
          geom_histogram()
        
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Histogram of ",i, ":")), plot, p(""))
      }
      if(df_output["unique_count",i]>50){
        
        p=ggplot(Dataset, aes_string(x=i))+
          geom_density()
        
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Density of ",i, ":")), plot, p(""))
      }
    }
  }  
  
  # Individual / Specified Vars / Non-specified Format / Detailed Information
  if(c){
    for(i in Cols){
      if(df_output["unique_count",i]<=10){
        p=ggplot(Dataset, aes_string(x=i))+
          geom_bar()
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Bar graph of ",i, ":")), plot, p(""))
      }
      
      if(df_output["unique_count",i]>10 & df_output["unique_count",i]<=50){
        p=ggplot(Dataset, aes_string(x=i))+
          geom_histogram()
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Histogram of ",i, ":")), plot, p(""))
      }
      
      if(df_output["unique_count",i]>50){
        p=ggplot(Dataset, aes_string(x=i))+
          geom_density()
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Density of ",i, ":")), plot, p(""))
      } 
    }
  }
  
  # Individual / Specified Vars / Specified Format / Detailed Information
  if(d){
    form_iteration=1
    for(i in Cols){
      ## To be check if the format is correct in the vars
      if(ColsFormat[form_iteration]=="binary"){
        p=ggplot(Dataset, aes_string(x=i))+
          geom_bar()
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Bar graph of ",i, " defined as binary:")), plot, p(""))
      }
      
      if(ColsFormat[form_iteration]=="categorical"){
        p=ggplot(Dataset, aes_string(x=i))+
          geom_bar()
        plot<-ggplotly(p)
        description <- list(description, h4(paste0("Bar graph of ",i, " defined as categorical:")), plot, p(""))
      }
      
      if(ColsFormat[form_iteration]=="continuous"){
        p1=ggplot(Dataset, aes_string(x=i))+
          geom_histogram()
        plot1<-ggplotly(p1)
        p2=ggplot(Dataset, aes_string(y=i))+
          geom_boxplot()
        plot2<-ggplotly(p2)
        plot<-subplot(p1, p2)
        description <- list(description, h4(paste0("Histogram and Box Plot of ",i, " defined as continuous:")), plot, p(""))
      }
    }
    form_iteration=form_iteration+1
  }  
  
  # Individual / Non-specified Vars / Non-Detailed Information
  if(e){
    
  }  
  
  # Individual / Specified Vars / Non-specified Format / Non-Detailed Information
  if(f){
    
  } 
  
  # Individual / Specified Vars / Specified Format / Non-Detailed Information
  if(g){
    
  } 
  

  ##### saving the html file
  save_html(list(title, description), diroutput)
}