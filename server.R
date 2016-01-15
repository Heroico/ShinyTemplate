library(RSQLite)
# Define a server for the Shiny app
shinyServer(function(input, output) {

  # Filter data based on selections
  output$table <- renderDataTable({
    # Construct the fetching query
    where <- " WHERE pval IS NOT null "
    if (nchar(input$gene_name) > 0){
      where <- paste0(where, " AND instr(gene_name, '", input$gene_name, "')")
    }
    if (input$tissue != "All") {
      where <- paste0(where, " AND tissue = '", input$tissue, "'")
    }
    t = 0.05
    if (input$threshold > 0) {
      t = input$threshold
    }
    where <- paste0(where, " AND pval < ", t)

    query <- paste0("SELECT gene_name, zscore, pval, tissue, pred_perf_R2, n, model_n, gene FROM results ", where);
    query <- paste0(query, " ORDER BY pval");
    l = 100
    if (input$limit > 1) {
      l = input$limit
    }
    query <- paste0(query, " LIMIT ", l);
    query <- paste0(query, ";")

    #Modify the following line to point to a different data set, if you want. Or just replace the db file with an appropriate one.
    db <- dbConnect(SQLite(), "data/allresultsn.db")
    data <- dbGetQuery(db, query)
    dbDisconnect(db)

    data
  })
})

