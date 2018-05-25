source("Parameters.R")

library(rFdk)
library(foreach)
library(caret)
library(Hmisc)
source("R_MissingBaseFunctionality.R")
#ttConnect()

if(!dir.exists(outputFolderName))
  dir.create(outputFolderName)

symbolNames <- GenerateSymbolNames(N_sym)

foreach(symName=symbolNames)%do%{ #symName = "XAGUSD"
  cat("Processing ",symName)
  rawData <- ttFeed.BarHistory(symName, "BidAsk", startTime = startTime, endTime = endTime)
  if( nrow(rawData) < 1000){
    cat("There are not enough data")  
    return(NULL)
  }
  rawData <- rawData[complete.cases(rawData)]
  rawData <- rawData[order(askFrom)]
  rawData[, `:=`(c("bidVolume", "bidFrom", "bidTo", "askFrom", "askTo", "askVolume"), NULL)]
  
  NN_datasets <- PreProcessAndTransformToInputNN( rawData, N_x, T_x, symName, TrainTestPartition, InputDataStride)

  saveRDS(NN_datasets, file.path(outputFolderName, symName))
  gc()
}

distrName <- "rnorm"
cat("Processing ", distrName)
rawData <- as.data.table(abs(matrix(rnorm(InputDataStride*3000*N_x), ncol = N_x)))
NN_datasets <- PreProcessAndTransformToInputNN( rawData, N_x, T_x, distrName, TrainTestPartition, InputDataStride)
saveRDS(NN_datasets, file.path(DataFolderName, distrName))

distrName <- "rexp"
cat("Processing ", distrName)
rawData <- as.data.table(abs(matrix(rexp(InputDataStride*3000*N_x), ncol = N_x)))
NN_datasets <- PreProcessAndTransformToInputNN( rawData, N_x, T_x, distrName, TrainTestPartition, InputDataStride)
saveRDS(NN_datasets, file.path(DataFolderName, distrName))

