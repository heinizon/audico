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

shinyUI(pageWithSidebar(
  
  # app title
  headerPanel(list(tags$style("body {background-color: snow;}"),
                   'Audience Composition')
              ),
    
  # goal input
  sidebarPanel(
    wellPanel(
      selectInput("category", "Category", 
                  c(Age = 'age', 
                    Gender = 'gender'))
      ),
    wellPanel(
      selectInput('partner', 'Partner:', 'Partner')
    )

  ),
  
  
  mainPanel(
    tabsetPanel(
      
        tabPanel('Age', 
                 showOutput("indexChart", "Highcharts"),
                 HTML('<br> <center>'),
                 #tableOutput('theData'),
                 HTML('</center')),
    
        tabPanel('Gender', 
                 #showOutput("indexChart", "Highcharts"),
                 HTML('<br> <center>'),
                 tableOutput('theData'),
                 HTML('</center'))
           
    )
  )
))

