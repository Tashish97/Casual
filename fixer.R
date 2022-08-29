library(shiny)
library(rhandsontable)

ui <- fluidPage(
  rHandsontableOutput("table"),
  rHandsontableOutput("hottable"),
  actionButton("replace","Replace")
)

server <- function(input, output, session) {
  xData <- reactiveVal(data.frame (
    Replace = c(""),
    With = c("")
  ))
  yData <- reactiveVal(
    # data.frame (
    #   Replace = c("Ashish","Toppo"),
    #   With = c("ashish","toppo")
    # )
    iris
  )
  observeEvent(input$replace,{
    x <- hot_to_r(input$hottable)
    replaceWord <- x$Replace
    replace_ <- x$With
    fixDF <- isolate(yData())
    # if(!(""|" "|"  " %in% replaceWord)){
    #   for (i in 1:length(replace_)) {
    #     #x <- x %>%mutate(across(.cols = everything(),~str_replace( ., "setosa", "S" )) )
    #     fixDF <- fixDF %>% mutate(across(.cols = everything(),~str_replace( ., replaceWord[i], replace_[i])) )
    #     print(paste(replaceWord[i],replace_[i]))
    #   }
    # }else{
    #   print("boof")
    # }
    for (i in 1:length(replace_)) {
      #x <- x %>%mutate(across(.cols = everything(),~str_replace( ., "setosa", "S" )) )
      fixDF <- fixDF %>% mutate(across(.cols = everything(),~str_replace( ., replaceWord[i], replace_[i])) )
      print(paste(replaceWord[i],replace_[i]))
    }
    yData(fixDF)
  })
  
  output$hottable <- renderRHandsontable({
    rhandsontable(xData())
  })
  output$table <- renderRHandsontable({
    rhandsontable(yData())
  })
}

shinyApp(ui, server)
# x <- iris[1:10,]
# x <- x %>%
#   mutate( across(
#     .cols = everything(),
#     ~str_replace( ., "setosa", "S" )
#   ) )
