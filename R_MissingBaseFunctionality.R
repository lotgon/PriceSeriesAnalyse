GetconsequentlyPairs<- function(x){
  n <- length(x)
  if( n < 2 )
    return(list())
  mapply(c, x[1:(n-1)], x[2:n], SIMPLIFY = F)
}
  
