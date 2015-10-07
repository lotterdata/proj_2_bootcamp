shinyUI(fluidPage(
  titlePanel("Modern Portfolio Theory Demo"),
  sidebarLayout(
    sidebarPanel(
      helpText(h2("Asset Information")),
      checkboxGroupInput("stockPicks",
                         label = h3("Choose your stocks"),
                          choices = list("Pfizer" = "PFZ",
                                         "Google" = "GOOG"))), ## SideBar panel title
    mainPanel(h1("Efficient Frontier", align = "center")) ## Main panel title
  )
))