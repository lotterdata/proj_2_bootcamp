library(dplyr)

# getSymbols('PNC')
# pnc_ret <- periodReturn(PNC, period = 'weekly')
# pnc.df <- data.frame(pnc_ret)
# pnc.df$date <- row.names(pnc.df)
# 
# getSymbols('GS')
# gs_ret <- periodReturn(GS, period = 'weekly')
# gs.df <- data.frame(gs_ret)
# gs.df$date <- row.names(gs.df)

# 
# ticker <- 'GS'
# getSymbols(ticker)
# return.vector <- periodReturn(get(ticker), period = 'weekly')
# 
# getReturns <- function(ticker){
#   getSymbols(ticker)
#   temp.returns <- periodReturn(get(ticker), period = 'weekly')
#   temp.df <- data.frame(temp.returns)
#   temp.df$date <- row.names(temp.df)
#   temp.df$ticker <- ticker
#   return(temp.df)
# }
# 
# portfolioReturns <- function(tickers){
#   dfs <- lapply(tickers, getReturns)
#   stacked <- NULL
#   for(i in 1:length(dfs))
#     stacked <- rbind(stacked,dfs[[i]])
#   return(spread(stacked,ticker, weekly.returns))
# }
# 


library(dplyr)
library(quantmod)
library(tidyr)

getReturns <- function(ticker){
  getSymbols(ticker)
  temp.returns <- periodReturn(get(ticker), period = 'weekly')
  temp.df <- data.frame(temp.returns)
  temp.df$date <- row.names(temp.df)
  temp.df$ticker <- ticker
  return(temp.df)
}

portfolioReturns <- function(tickers){
  dfs <- lapply(tickers, getReturns)
  stacked <- NULL
  for(i in 1:length(dfs))
    stacked <- rbind(stacked,dfs[[i]])
  return(stacked)
}

assetMeanCov <- function(stacked, tickers){
  if(is.null(stacked))
    return(NULL)
  else {
    selected <- stacked[sapply(stacked$ticker, function(x) (x %in% tickers)),] %>%
      spread(.,ticker,weekly.returns)
    meanVector <- colMeans(selected)
    covMat <- cov(selected[,-1])
    return(covMat) 
  }
  
}









