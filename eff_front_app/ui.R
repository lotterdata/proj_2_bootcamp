shinyUI(fluidPage(
  titlePanel("Modern Portfolio Theory Demo"),
  sidebarLayout(
    sidebarPanel(
      helpText(h2("Options")),
      checkboxInput("hideline", "Hide Capital Allocation Line"),
      checkboxInput("longonly", "Long Only"),
      checkboxGroupInput("stockPicks",
                         label = h3("Choose your stocks"),
                         choices = list("Pfizer" = "PFE",
                                        "Novartis" = "NVS",
                                        "Merck" = "MRK",
                                        "Eli Lilly" = "LLY",
                                        "Goldman Sachs" = "GS",
                                        "JP Morgan Chase" = "JPM",
                                        "Morgan Stanley" = "MS",
                                        "PNC Bank" = "PNC",
                                        "Time Warner" = "TWX",
                                        "Comcast" = "CMCSA",
                                        "Disney" = "DIS",
                                        "Discovery Communications" = "DISCA",
                                        "Wal-Mart" = "WMT",
                                        "Target" = "TGT",
                                        "Home Depot" = "HD",
                                        "Costco" = "COST"),
                         selected = c('PNC','DIS','HD','COST')),
      sliderInput("targetVol","Volatility Target",
                  value = 15,min=0,max=50,step=0.5, 
                  post = "%"),
      uiOutput("rfSlider")
      ), 
    
    mainPanel(
                h1("Efficient Frontier", align = "center"),
                plotOutput("Eff.Front"),
                conditionalPanel("!input.hideline",
                                  h1("Optimal Portfolio", align = "center"),
                                  plotOutput("portfolio") 
                                )
              )
    )
  )
)