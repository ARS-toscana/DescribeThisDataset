

DescribeThisDataset <- function(Dataset,
                                Individual=T,
                                ColumnN=NULL,
                                HeadOfDataset=FALSE,
                                StructureOfDataset=FALSE,
                                NameOutputFile="Dataset",
                                Cols=list(),
                                ColsFormat=list(),
                                DateFormat="",
                                DetailInformation=TRUE,
                                PathOutputFolder){
                                       
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
                   DateFormat="",
                   DetailInformation=DetailInformation))
}
