CreateConvolutionalModel <- function(){
  model <- keras_model_sequential() 
  model %>%
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
  summary(model)
  #summary(application_resnet50())
  model %>% compile(
    loss = 'categorical_crossentropy',
    optimizer = optimizer_adam(),
    metrics = c('accuracy')
  )
  model
}
