source("Parameters.R")
source("Model.R")
library(keras)
library(foreach)
library(abind)
library(data.table)

trainX <- array(0, dim=c(0,T_X, N_x))
trainY <- array("", dim=c(0,1))
testX <- array(0, dim=c(0,T_X, N_x))
testY <- array("", dim=c(0,1))

foreach(file=Filter(function(x) file_test("-f", x), list.files(DataFolderName, full.names = TRUE)))%do%{
  dataset <-readRDS(file)
    trainX <- abind(trainX, dataset[[1]], along=1)
    trainY <- abind(trainY, dataset[[2]], along=1)
    testX <- abind(testX, dataset[[3]], along=1)
    testY <- abind(testY, dataset[[4]],along=1)
  }

x_train <- array_reshape(trainX, c(nrow(trainX), T_X, N_x))
x_test <- array_reshape(testX, c(nrow(testX), T_X, N_x))

uni <- unique(trainY[,])
symbol2Index <- data.table(k = uni, v = rleid(uni)-1, key="k")

y_train <- to_categorical(symbol2Index[trainY[,]]$v, N_y)
y_test <- to_categorical(symbol2Index[testY[,]]$v, N_y)

##########

#model <- CreateConvolutionalModel()
load_model_hdf5("currentModel")

history <- model %>% fit(
  x_train, y_train, 
  epochs = 500, batch_size = 128, 
  validation_split = 0
)
save_model_hdf5(model, "currentModel")
plot(history)

model %>% evaluate(x_test, y_test)
setkey(symbol2Index, "v")
table( testY[,], symbol2Index[J(model %>% predict_classes(x_test)), k] )
