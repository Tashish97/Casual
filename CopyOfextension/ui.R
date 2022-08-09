ui <- fluidPage(
  mainPanel(
    fluidRow(actionButton("correct", "Import"),actionButton("upload", "Upload")),
    bsModal("as1","Please upload your causal file","correct",uiOutput("uploadFile"),uiOutput("uploadedCategory")),
    #bsModal("as2","Verify the user")
  )
)