source("helpers.R")

#caches stuff for UI. We'll need a reset of the server when new data gets into the database
update_ui_cook()

# Define a server for the Shiny app
shinyServer(function(input, output) {
  # Filter data based on selections
  output$table <- renderDataTable({
    # Construct the fetching query
    where <- " WHERE m.pval IS NOT null "
    if (nchar(input$gene_name) > 0){
      kk <- strsplit(gsub("[^[:alnum:] ]", "", input$gene_name), " +")[[1]]
      kk <- paste(kk, collapse = '')
      where <- paste0(where, " AND m.gene_name LIKE '%", kk, "%'")
    }
    if (input$tissue != "All") {
      where <- paste0(where, " AND t.tag = '", input$tissue, "'")
    }
    if (input$pheno != "All") {
      where <- paste0(where, " AND p.tag = '", input$pheno, "'")
    }
    t = 0.05
    if (input$threshold > 0) {
      t = input$threshold
    }
    where <- paste0(where, " AND pval < ", t)

    query <- paste0(
    "SELECT ",
    "m.gene_name,",
    " m.zscore,",
    " m.pval,",
    " p.tag,",
    " t.tag,",
    " m.pred_perf_R2,",
    " m.n,",
    " m.model_n",
    " FROM metaxcanresults AS m ",
    " INNER JOIN tissue AS t ON t.id = m.tissue_id ",
    " INNER JOIN pheno as p ON p.id = m.pheno_id ",
    where);

    if (input$ordered){
        query <- paste0(query, " ORDER BY pval");
    }
    l = 100
    if (input$limit > 1) {
      l = input$limit
    }

    db <- get_db()
    query <- paste0(query, " LIMIT ", l);
    query <- paste0(query, ";")
    data <- dbGetQuery(db, query)
    dbDisconnect(db)

    data
  })
})

