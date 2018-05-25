library(caret)
library(abind)

GenerateSymbolNames <- function (count){
  allSymbols <- ttConf.Symbol()
  symbolNames <- head(allSymbols[marginCurrency=="USD"|profitCurrency=="USD"][grepl( "^.{6}$", name), name], count)
}

GenerateDataset <- function(data, T_x, N_x, stride){
  # data  - data.frame of data
  # T_x     - number of X input steps (for sequential model)
  # stride - stride for timeslices
  # result - array of dimentsion (m, T_x, n_x)
  timeSlices <- createTimeSlices(seq_len(nrow(data)), 
                                 initialWindow = T_x, horizon = 0, fixedWindow = T, skip=stride)
  result <- array(0, dim=c(length(timeSlices$train), T_x, length(data)))
  
  for(i in seq_along(timeSlices$train)){
    indices <- timeSlices$train[[i]]
    result[i,,] <- as.matrix(data[indices,])
  }
  
  result
}
  
PreProcessAndTransformToInputNN <- function( rawData, N_x, T_x, y, TrainTestPartition, InputDataStride){
  #rawData  - data.table with raw data and N_x columns
  # N_x     - number of elements in X tensors
  # T_X     - number of X time
  # y       - outcome 
  # TrainTestPartition  - rules how to partition train/test sets
  # InputDataStride     - stride for TimeSeries
  
  preData <- rawData[,log(.SD), by=.I]
  preData<-preData[,.SD[2:.N] - .SD[1:(.N-1)], by=.I]
  mean_Preprocessing <- mean(as.matrix(preData))
  sd_Preprocessing <- sd(as.matrix(preData))
  preData <- preData[,(.SD-mean_Preprocessing)/sd_Preprocessing, by=.I]
  
  trainX <- array(0, dim=c(0,T_X, N_x))
  trainY <- array(y, dim=c(0,1))
  testX <- array(0, dim=c(0,T_X, N_x))
  testY <- array(y, dim=c(0,1))
  
  isTrainExample <- TRUE
  for( pair in GetconsequentlyPairs(trunc(TrainTestPartition*nrow(preData)))){
    x <- GenerateDataset(preData[pair[[1]]:pair[[2]]], T_X, N_x, InputDataStride)
    if ( isTrainExample){
      trainX <- abind(trainX, x, along=1)
      trainY <- abind(trainY, array(y, dim=c(dim(x)[[1]], 1)), along=1)
    }else{
      testX <- abind(testX, x, along=1)
      testY <- abind(testY, array(y, dim=c(dim(x)[[1]], 1)),along=1)
    }
    
    isTrainExample <- !isTrainExample
  }
  
  list(trainX, trainY, testX, testY)
}