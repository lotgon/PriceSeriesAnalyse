N_sym <- 20
startTime = ISOdatetime(2017, 1, 1, 0, 0, 0, "UTC")
endTime = ISOdatetime(2018, 1, 1, 0, 0, 0, "UTC")
TrainTestPartition <- c(0, 0.2, 0.25, 0.45, 0.50, 0.70, 0.75, 0.95, 1)
T_X <- 1000
InputDataStride <- 100
DataFolderName <- file.path(rprojroot::find_rstudio_root_file(),"inputData")
N_x <- 8
N_y <- 8