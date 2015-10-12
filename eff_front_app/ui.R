shinyUI(fluidPage(
  titlePanel("Modern Portfolio Theory Demo"),
  sidebarLayout(
    sidebarPanel(
      helpText(h2("Asset Information")),
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
                         selected = c('PFE','GS','TWX','HD')),
      numericInput("RF","Risk-free rate",value = 0.05,min=0.0025,max=0.15,step=0.0025),
      submitButton("Submit")), 
    mainPanel(h1("Efficient Frontier", align = "center"),
              #tableOutput("covMat"),
              #textOutput("minmean"),
              #textOutput("maxmean"),
              #textOutput("echoRF"),
              plotOutput("Eff.Front")
              ) 
  )
))