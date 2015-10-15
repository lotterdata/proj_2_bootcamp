shinyUI(fluidPage(
  titlePanel("Modern Portfolio Theory Demo"),
  sidebarLayout(
    sidebarPanel(
#       helpText(h2("Disclaimer")),
#       helpText("This demo is intended for educational purposes. 
#                It should not be taken as investment advice."),
#       checkboxInput("disclaimer","I understand."),
      
      helpText(h2("Options")),
      checkboxInput("longonly", "Long Only"),
      checkboxInput("showline", "Show Capital Allocation Line", value = TRUE),
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
                         selected = c('PNC','DIS','DISCA')),
      uiOutput("rfSlider"),
      sliderInput("targetVol","Volatility Target",
                  value = 15,min=0,max=50,step=0.5, 
                  post = "%")
      ), 
    
    mainPanel(
              #condition = "input.disclaimer",
              h1("Efficient Frontier", align = "center"),
              plotOutput("Eff.Front"),
#               h1("Optimal Risky Asset Mix", align = "center"),
#               textOutput("Names"),
#               textOutput("Mix"),
#               tableOutput("covariance"),
#               textOutput("tangentMean"),
#               textOutput("tangentVol"),
#               textOutput("assetMeans"),
#               textOutput("cash"),
              h1("Optimal Portfolio", align = "center"),
              plotOutput("portfolio")
              )
#     conditionalPanel(
#       condition = "input.disclaimer",
#       h1("Efficient Frontier", align = "center"),
#       plotOutput("Eff.Front")
#     )#,   
#     conditionalPanel(
#       condition = "input.disclaimer",
#       h1("Optimal Risky Asset Mix", align = "center"),
#       textOutput("Names"),
#       textOutput("Mix")
#     )
  )
))