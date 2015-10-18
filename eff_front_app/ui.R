shinyUI(fluidPage(
  titlePanel("Modern Portfolio Theory Demo"),
  
  fluidRow(column(2,helpText(h3("Options")))),
  
  fluidRow(
    column(2,
           checkboxInput("hideline", "Hide Capital Allocation Line"),
           checkboxInput("longonly", "Long Only")
    ) 
  ),
  
  fluidRow(column(2,helpText(h3("Assets")))),
  
  fluidRow(
    column(2,
    checkboxGroupInput(
      "pharma",
      label = "Pharmaceuticals",
      choices = list(
                    "Pfizer" = "PFE",
                    "Novartis" = "NVS",
                    "Merck" = "MRK",
                    "Eli Lilly" = "LLY"
                )
      )
    ),
    
    column(2,
           checkboxGroupInput(
             "finance",
             label = "Financials",
             choices = list(
               "Goldman Sachs" = "GS",
               "JP Morgan Chase" = "JPM",
               "Morgan Stanley" = "MS",
               "PNC Bank" = "PNC"
             ),
             selected = 'PNC'
           )
    ),
    
    column(2,
           checkboxGroupInput(
             "media",
             label = "Media",
             choices = list(
               "Time Warner" = "TWX",
               "Comcast" = "CMCSA",
               "Disney" = "DIS",
               "Discovery Communications" = "DISCA"
             ),
             selected = 'DIS'
           )
    ),
    
    column(2,
           checkboxGroupInput(
             "retail",
             label = "Retail",
             choices = list(
               "Wal-Mart" = "WMT",
               "Target" = "TGT",
               "Home Depot" = "HD",
               "Costco" = "COST"),
             selected = c('HD','COST')
             )
           ),
    column(2, actionButton("submit", "Calculate Efficient Frontier"))
    ),
  h4("Efficient Frontier", align = "center"),
  plotOutput("Eff.Front"),
  
  conditionalPanel("!input.hideline",
                    h4("Optimal Portfolio", align = "center"),
                                    plotOutput("portfolio") 
                  ),
  

  
  fluidRow(
    column(4,
           sliderInput("targetVol","Volatility Target",
                       value = 15,min=0,max=50,step=0.5, 
                       post = "%")
           ),
    column(4, uiOutput("rfSlider"))
    
  ),
 
  h4("Tangent Portfolo Volatily:"),
  
  textOutput("tangvol") 
  
 )
)
