ui <- fluidPage(
    
    mainPanel(
      fluidRow(actionButton("correct", "Import"),actionButton("upload", "Upload")),
      bsModal("dump","Please upload your causal file","correct",uiOutput("uploadFile"),uiOutput("uploadedCategory"))
    )
)
server <- function(input,output,session){
  options(shiny.maxRequestSize=30*1024^2)
  Names <- reactiveVal(NULL)
  # reactive values for each RDS
  c1 <- reactiveVal(setosa)
  c2 <- reactiveVal(versicolor)

  rds_updator <- function(rds,update){
    switch(rds,
           "Iris-setosa" = c1(update),
           "Iris-versicolor" = c2(update)
    )
  }
  rds_writer <- function(rds){
    switch (rds,
            "Iris-setosa" = saveRDS(isolate(c1()),"rds/setosa.rds"),
            "Iris-versicolor" = saveRDS(isolate(c2()),"rds/versicolor.rds")
    )
  }
  observe({
    x <- c("Setosa","Versicolor")[which(sapply(list(c1(),c2()),function(x) ifelse(sum(dim(x)==c(0,0)),F,T)))]
    print(x)
    Names(x)
  })
  output$uploadFile <- renderUI({
    fileInput('file1', 'Choose xlsx file',
              accept = c(".xlsx"))
  })
  observeEvent(input$file1,{
    req(input$file1)
    inFile <- input$file1
    temp <- read_excel(inFile$datapath, 1)
    class <- unique(temp$Class)
    temp <- split(temp,temp$Class)
    for(i in class){
      rds_updator(i,temp[[i]])
      rds_writer(i)
    }
  })
  output$uploadedCategory <- renderUI({
    checkboxGroupInput(
      "id1",
      "Uploaded Causals For Categories",
      choices = c("Setosa","Versicolor"),
      selected = Names()
    )
  })
  observeEvent(input$upload,{
    if(length(Names())==2){
      saveRDS(NULL,"rds/setosa.rds")
      saveRDS(NULL,"rds/versicolor.rds")
    }else{
      showModal(
        modalDialog("All the causals are not available")
      )
    }
  })
}

shinyApp(ui,server)