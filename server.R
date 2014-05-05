install_load <- function (package1, ...) {
  # convert arguments to vector
  packages <- c(package1, ...)
  
  for(package in packages){
    
    # if packages exists, load into environment
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package)) 
    
    # if package does not exist, download, and then load
    else {
      install.packages(package)
      do.call('library', list(package))
    }
    
  }
  
}

# load packages
install_load('shiny', 'rCharts', 'dplyr',
             'gdata', 'scales',
             'XLConnect', 'reshape2')

shinyServer(function(input, output, session) {
  
  fakeData <- 
    structure(list(partner = structure(c(2L, 2L, 3L, 3L, 1L, 1L, 
                                         4L, 4L), .Label = c("addthis", "bluekai", "exelate", "neustar"
                                         ), class = "factor"), category = structure(c(2L, 2L, 2L, 2L, 
                                                                                      1L, 1L, 1L, 1L), .Label = c("age", "gender"), class = "factor"), 
                   demo = structure(c(1L, 4L, 1L, 4L, 3L, 2L, 3L, 2L), .Label = c("men", 
                                                                                  "over18", "under18", "women"), class = "factor"), converters = c(58L, 
                                                                                                                                                   42L, 53L, 47L, 80L, 20L, 70L, 30L)), .Names = c("partner", 
                                                                                                                                                                                                   "category", "demo", "converters"), class = "data.frame", row.names = c(NA, 
                                                                                                                                                                                                                                                                          -8L))
  
  observe({
    
    fd <- fakeData %.% 
      filter(category == input$category)
    
    updateSelectInput(session, 'partner', choices = fd$partner)
    
  })
  
  output$indexChart <- renderChart({
    
    fd2 <- fakeData %.% 
      filter(category == input$category,
             partner == input$partner) %.%
      mutate(mean_converters = mean(converters),
             converter_index = (converters/mean_converters)*100) %.%
      select(demo, converter_index)
    
    indexChart <- Highcharts$new()
    indexChart$chart(type = 'bar',
                     inverted = T,
                     margin = list(left = 100))
    indexChart$plotOptions(series = list(threshold = 100))
    indexChart$xAxis(categories = as.character(fd2$demo),
                     title = list(text = 'Age'))
    indexChart$addParams(dom = 'indexChart')
    indexChart$data(fd2)
    return(indexChart)
  
  })

  output$theData <- renderTable({
    
    fakeData %.% 
      filter(category == input$category,
             partner == input$partner) %.%
      mutate(converter_index = converters/mean(converters)*100)
    
  })
  
})