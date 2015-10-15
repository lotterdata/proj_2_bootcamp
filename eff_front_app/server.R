source("helpers.R")
library(ggplot2)
library(scales)


shinyServer(function(input, output) {
  
  longOnlyFlag <- reactive({input$longonly})
  
  ShowLine <- reactive({input$showline})
  
  rfRate <- reactive({input$RF/100})
  
  targetVol <- reactive({input$targetVol/100})
  
  portfolio <- reactive({input$stockPicks})
  
  covMat <- reactive({assetCov(full.list,portfolio())})
  
  assetMns <- reactive({assetMean(full.list,portfolio())})
  
  riskyEF <- reactive({
              if(longOnlyFlag() & min(assetMns()) < 0)
                minmean <- 0
              else
                minmean <- min(assetMns())
              mult <- ifelse(longOnlyFlag(),1,2)
              mns <- seq(minmean,mult*max(assetMns()), by = 0.001)
              sds <- sapply(mns, function(x) mean.var.opt(assetMns(), covMat(),x,longOnlyFlag())[[2]]^0.5)
              data.frame(expRet = mns, Vol = sds, curve = "EF")
            })
  
  maxRF <- reactive({
                tang <- length(riskyEF()$Vol)
                x <- riskyEF()$Vol
                y <- riskyEF()$expRet
                slope <- (y[tang]-y[tang-1])/(x[tang]-x[tang-1])
                round(floor(400*(y[tang] - slope*x[tang]))/400,2)
              })
  
  
  tangentPt <- reactive({
                tang <- length(riskyEF()$Vol) - 1
                x <- riskyEF()$Vol
                y <- riskyEF()$expRet
                while((y[tang]-rfRate())/x[tang] > (y[tang+1]-y[tang-1])/(x[tang+1]-x[tang-1])){
                  tang <- tang - 1
                }
                tang <- tang + 1
                xcoord <- x[tang]
                ycoord <- y[tang]
                slope <- (ycoord-rfRate())/xcoord
                mix <- mean.var.opt(assetMns(), covMat(),ycoord,longOnlyFlag())[[1]]
                list(xcoord = xcoord, ycoord = ycoord, slope = slope, mix = mix)
            })
  
  optimalMix <- reactive({tangentPt()$mix})
  
  selectedNames <- reactive({dimnames(covMat())[[1]]})
  
  highlightDot <- reactive({data.frame(expRet = rfRate() + targetVol()*tangentPt()$slope,
                                       Vol = targetVol(),
                                       curve = "Optimal Portfolio")})
  
  totalEF <- reactive({
              slope <- tangentPt()$slope
              sds <- seq(0, 0.5, by = 0.01)
              mns <- sapply(sds, function(z) rfRate() + slope*z)
              data.frame(expRet = mns, Vol = sds, curve = "CAL")
            })
  
  riskyPct <- reactive({targetVol()/tangentPt()$xcoord})
  
  cashPct <- reactive({1-riskyPct()})
 
  portMix <- reactive({
    port <- data.frame(asset =selectedNames(), 
                       wt = riskyPct()*optimalMix(),
                       stringsAsFactors = FALSE)
    port <- rbind(port,c("Cash",cashPct()))
    port$pos <- port$wt >= 0
    port$wt <- as.numeric(port$wt)
    port
  })
   
  output$portfolio <- renderPlot({
                        if(longOnlyFlag())
                          lims <- c(0,1)
                        else
                          lims <- c(-2,2)
                        pp <- ggplot(data = portMix(), aes(x= asset,y=wt, fill = pos)) +
                          geom_bar(stat = "identity", position = "identity", color = "black", size = 0.7) + 
                          scale_x_discrete(name = "") +
                          scale_y_continuous(name = "Weight", labels = percent, limits = lims) +
                          scale_fill_manual(values = c("red","green"), guide = FALSE) +
                          theme_bw()
                        pp
                      })
  
  output$Eff.Front <- renderPlot({
                      if(ShowLine())
                        plot.data <- rbind(riskyEF(),totalEF())
                      else
                        plot.data <- riskyEF()
                      gp <- ggplot(data = plot.data, aes(x=expRet,y=Vol, color = curve))
                      gp <-   gp + geom_line() + 
                              scale_x_continuous(name = "Expected Return", labels = percent) + 
                              scale_y_continuous(name = "Annualized Vol", labels = percent) +
                                    coord_flip() + theme_bw()  
                      if(ShowLine())
                        gp <- gp + geom_point(y= highlightDot()$Vol,x=highlightDot()$expRet, size = 3)
                      gp
                      
#                       gp + geom_line() + 
#                         geom_point(y= highlightDot()$Vol,x=highlightDot()$expRet, size = 3) +
#                         scale_x_continuous(name = "Expected Return", labels = percent) + 
#                         scale_y_continuous(name = "Annualized Vol", labels = percent) +
#                            coord_flip() + theme_bw()
                    })
  
  output$rfSlider <- renderUI({
                      sliderInput("RF","Risk-free rate",
                                  value =4,min=0.25,max=100*maxRF(),step=0.25, 
                                  post = "%")
                      })
  
  output$Mix <- renderText(optimalMix())
  
  output$Names <- renderText(selectedNames())
  output$covariance <- renderTable({covMat()}, digits = 4)
  output$tangentMean <- renderText({tangentPt()$ycoord})
  output$tangentVol <- renderText({tangentPt()$xcoord})
  output$assetMeans <- renderText({assetMns()})
  output$cash <- renderText({cashPct()})
})

