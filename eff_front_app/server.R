source("helpers.R")
library(dplyr)
library(quantmod)
library(tidyr)
library(xtable)
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  output$covMat <- renderTable({assetCov(full.list,input$stockPicks)})
  output$Means <- renderTable({assetMean(full.list,input$stockPicks)})
  output$Eff.Front <- renderPlot({
                      mns <- seq(0.0, 0.60, by = 0.001)
                      assetMns <- assetMean(full.list,input$stockPicks)
                      mns <- seq(min(assetMns), 2*max(assetMns), by = 0.001)
                      Dmat <- assetCov(full.list,input$stockPicks)
                      sds <- sapply(mns, function(x) mean.var.opt(assetMns, Dmat,x,FALSE)[[2]]^0.5)
                      #plot(sds, mns, type="l")
                      tang <- length(sds) - 1
                      while((mns[tang]-input$RF)/sds[tang] > 
                            (mns[tang+1]-mns[tang-1])/(sds[tang+1]-sds[tang-1])){
                        tang <- tang - 1
                      }
                      slope <- (mns[tang]-input$RF)/sds[tang]
                      #abline(a=input$RF,b=(mns[tang]-input$RF)/(sds[tang]))
                      x.plot = seq(0,0.5,by = 0.01)
                      y.plot = sapply(x.plot, function(x) input$RF + slope*x)
                      #plot(x.plot,y.plot,type = "l")
                      plot.data <- data.frame(sds = sds, mns = mns, curve = 'EF')
                      plot.data <- rbind(plot.data,
                                         data.frame(sds = x.plot, mns = y.plot, curve = 'tan'))
                      gp <- ggplot(data = plot.data, aes(x=mns,y=sds, color = curve))
                      gp + geom_line() + 
                        scale_x_continuous(name = "Expected Return", labels = percent) + 
                        scale_y_continuous(name = "Annualized Vol", labels = percent) +
                           coord_flip() + theme_minimal()
                    })
  output$minmean <- renderText({min(assetMean(full.list,input$stockPicks))})
  output$maxmean <- renderText({max(assetMean(full.list,input$stockPicks))})
  output$echoRF <- renderText({input$RF})
})

