library(dplyr)
library(quantmod)
library(tidyr)
library(quadprog)

full.list <- readRDS("full_list.rds")

getReturns <- function(ticker){
  getSymbols(ticker)
  temp.returns <- periodReturn(get(ticker), period = 'monthly')
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

assetCov <- function(stacked, tickers){
  if(is.null(stacked))
    return(NULL)
  else {
    selected <- stacked[sapply(stacked$ticker, function(x) x %in% tickers),] %>%
                spread(.,ticker,monthly.returns)
    covMat <- 12*cov(selected[,-1], use = "complete.obs")
    return(covMat) 
  }
}

assetMean <- function(stacked, tickers){
  if(is.null(stacked))
    return(NULL)
  else {
    selected <- stacked[sapply(stacked$ticker, function(x) x %in% tickers),] %>%
      spread(.,ticker,monthly.returns)
    meanVector <- colMeans(selected[,-1])
    return(12*array(meanVector))
  }
}

mean.var.opt <- function(means, covMat, target, longOnly = FALSE){
  Dmat <- 2*covMat
  dvec <- matrix(0,nrow(covMat),1)
  Amat <- cbind(rep(1,nrow(covMat)),means)
  bvec <- matrix(c(1,target),1,2)
  if(longOnly){
    Amat <- cbind(Amat,diag(nrow(covMat)))
    bvec <- cbind(bvec, matrix(0,1,nrow(covMat)))
  }
  return(solve.QP(Dmat,dvec,Amat, bvec = bvec,meq=2))
}