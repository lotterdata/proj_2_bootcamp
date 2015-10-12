library(quadprog)

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

# Dmat <- matrix(0,3,3)
# diag(Dmat) <- 2*c(1,2,3)
Dmat <- matrix(c(0.11,0.02,0.02,0.02,0.05,0.02,0.02,0.02,0.03),3,3)

test1 <- mean.var.opt(c(0.15,0.1,0.05), Dmat, 0.1,TRUE)
test2 <- mean.var.opt(c(0.15,0.1,0.05), Dmat, 0.1,FALSE)


mns <- seq(0.05, 0.15, by = 0.001)
sds <- sapply(mns, function(x) mean.var.opt(c(0.15,0.1,0.05), Dmat,x,TRUE)[[2]]^0.5)

plot(sds, mns, type="l")


mns <- seq(0.05, 0.15, by = 0.001)
assetMns <- assetMean(full.list,c('GS','HD'))
Dmat <- assetCov(full.list,c('GS','HD'))
sds <- sapply(mns, function(x) mean.var.opt(c(0.05,0.05), Dmat,x,FALSE)[[2]]^0.5)
plot(sds, mns, type="l")
