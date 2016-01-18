#library(RSQLite)
#Modify the following line to point to a different data set, if you want. Or just replace the db file with an appropriate one.
#db <- dbConnect(SQLite(), "data/allresultsn.db")
#data <- dbGetQuery(db, "SELECT DISTINCT tissue from results;")
#dbDisconnect(db)

sgt <- scan("data/sgt", what=character())
sgp <- scan("data/sgp", what=character())

shinyUI(fluidPage(
  fluidPage(
    titlePanel("[Write your title here]"),

    p("'Tissue' stands for different transcriptome models used when generating the association."),
    p("[Example data built with IGROWTH pheotype GWAS]."),
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(3,
          textInput("gene_name",
                      "Gene Name:",
                      "")
      ),
      column(2,
          selectInput("pheno",
                      "Phenotype:",
                      sgp)
      ),
      column(2,
          selectInput("tissue",
                      "Tissue:",
                      sgt)
      ),
      column(2,
          numericInput("threshold",
                      "Pvalue threshold:",
                      0.05)
      ),
      column(2,
          numericInput("limit",
                      "Record limit:",
                      100)
      )
    ),
    # Create a new row for the table.
    fluidRow(
      dataTableOutput(outputId="table")
    )
  )
))
