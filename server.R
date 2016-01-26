library(RPostgreSQL)
# Define a server for the Shiny app
shinyServer(function(input, output) {

  # Filter data based on selections
  output$table <- renderDataTable({
    # Construct the fetching query
    where <- " WHERE pval IS NOT null "
    if (nchar(input$gene_name) > 0){
      kk <- strsplit(gsub("[^[:alnum:] ]", "", input$gene_name), " +")[[1]]
      kk <- paste(kk, collapse = '')
      where <- paste0(where, " AND gene_name LIKE '%", kk, "%'")
    }
    if (input$tissue != "All") {
      where <- paste0(where, " AND tissue = '", input$tissue, "'")
    }
    if (input$pheno != "All") {
      where <- paste0(where, " AND pheno = '", input$pheno, "'")
    }
    t = 0.05
    if (input$threshold > 0) {
      t = input$threshold
    }
    where <- paste0(where, " AND pval < ", t)

    query <- paste0("SELECT gene_name, zscore, pval, pheno, tissue, pred_perf_R2, n, model_n, gene FROM metaxcanresults ", where);
    query <- paste0(query, " ORDER BY pval");
    l = 100
    if (input$limit > 1) {
      l = input$limit
    }
    query <- paste0(query, " LIMIT ", l);
    query <- paste0(query, ";")

    #Modify the following line to point to a different data set, if you want. Or just replace the db file with an appropriate one.
    drv <- dbDriver("PostgreSQL")
    db <- dbConnect(drv, host='p', port='5432', dbname='metaxcan',
                 user='p', password='p')
    data <- dbGetQuery(db, query)
    dbDisconnect(db)

    data
  })
})

