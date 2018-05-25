# PriceSeriesAnalyse
This project try to classify symbol name based on 24*60 M1 Bid/Ask bars. There are several models. The first one is NaiveModel 1D convolutional Filters, the second one will is sequential model based on LSTM (in progress). If the second model succeeds, embedding layer should be added to avoid retraining for each new symbol.
#Naive Model
    layer_conv_1d(128, 3, padding = "same", activation = "relu", strides = 2, input_shape = c(T_X, N_x)) %>%
    layer_max_pooling_1d(strides = 2) %>%
    layer_dropout(0.1) %>% 
    layer_conv_1d(256, 3, padding = "valid", activation = "relu", strides = 3, kernel_regularizer = regularizer_l2(0.001)) %>%
    layer_max_pooling_1d(strides = 3) %>%
    layer_dropout(0.2) %>% 
    layer_conv_1d(256, 3, padding = "valid", activation = "relu", strides = 4, kernel_regularizer = regularizer_l2(0.001)) %>%
    layer_flatten() %>%
    layer_dropout(0.2) %>% 
    layer_dense(units = 128, activation = 'relu', kernel_regularizer = regularizer_l2(0.001)) %>% 
    layer_dropout(rate = 0.3) %>% 
    layer_dense(units = 32, activation = 'relu') %>%
    layer_dropout(rate = 0.4) %>%
    layer_dense(units = N_y, activation = 'softmax')
    
    Confusion Matrix:
            AUDUSD EURUSD GBPUSD NZDUSD USDJPY XAGUSD XAUUSD XNGUSD
  AUDUSD    195    210     95     45     55    111     31      2
  EURUSD    129    251    189     26     36     73     38      2
  GBPUSD    134    169    266     41     36     47     51      0
  NZDUSD    197    217    118     51     42     96     23      0
  USDJPY    131    214    211     33     43     77     34      1
  XAGUSD     99     89     12     35     36    382     40      3
  XAUUSD    127    181    207     44     45     37     56      3
  XNGUSD     39      2      5     21      7     57    109    276
    
