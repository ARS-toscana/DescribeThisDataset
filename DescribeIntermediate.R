

DescribeThisDataset <- function(Dataset,
                                Individual=T,
                                ColumnN=NULL,
                                HeadOfDataset=TRUE,
                                StructureOfDataset=TRUE,
                                NameOutputFile="Dataset",
                                Cols=list(),
                                ColsFormat=list(),
                                DetailInformation=TRUE,
                                PathOutputFolder,
                                output_file){
                                       
render("DescribeThisDataset.Rmd",           
       output_dir=PathOutputFolder,
       output_file=NameOutputFile, 
       params=list(Dataset=Cars_Data,
                   Individual=T,
                   ColumnN=NULL,
                   HeadOfDataset=TRUE,
                   StructureOfDataset=TRUE,
                   NameOfDataset=NameOutputFile,
                   Cols=list(),
                   ColsFormat=list(),
                   DetailInformation=TRUE))
}
