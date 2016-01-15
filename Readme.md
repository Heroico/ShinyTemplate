# Results Template

In order to use different different data, replace `data/allresultsn.db` sqlite file  with whatever you want.

You can also have the app use different data by changing the line:

```R
# server.R
# and in ui.R
[...]
    db <- dbConnect(SQLite(), "data/allresultsn.db")
[...]
```

The sqlite file must have the following schema:

```
CREATE TABLE results ('
"gene" TEXT,'
"gene_name" TEXT,'
"zscore" REAL,'
"n" INTEGER,'
"model_n" INTEGER,'
"pred_perf_R2" REAL,'
"pval" REAL,'
"tissue" TEXT'
);
```

## Sqlite building

If you have MetaXcan results CSV's, there is a utility script at `data` folder that builds the sqlite.

It works by picking csv's from `data/results`.

So, if you have

```bash
data/results/DGN_WholeBlood.csv
data/results/TW_Adipose.csv
...
```

It will read them and overwrite `allresultsn.db`

## Run

Assuming you installed `shiny` R package, you only need to run `runApp()` at an R console started at the project folder.

## deploy

You need to have `rsconnect`R Package installed. You need to configure your acount info by running:

```R
rsconnect::setAccountInfo(name='myaccount', token='MY_TOKEN', secret='MY_SECRET')
```

Then, from an R console started at the project, run `deployApp(appName="My App or Whatever")`

