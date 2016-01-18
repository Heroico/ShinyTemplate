#! /usr/bin/env python

import sqlite3
import os
from scipy import stats as stats

FOLDER = "results"
OUTPUT = "allresultsn.db"

class CSVTF1(object):
    GENE=0
    GENE_NAME=1
    ZSCORE=2
    PVALUE=3
    PRED_PERF_R2=4
    VAR_G=5
    N=6
    COVARIANCE_N=7
    MODEL_N=8

    header="gene,gene_name,zscore,pvalue,pred_perf_R2,VAR_g,n,covariance_n,model_n"

class CSVTF2(object):
    GENE=0
    GENE_NAME=1
    ZSCORE=2
    VAR_G=3
    N=4
    COVARIANCE_N=5
    MODEL_N=6
    PRED_PERF_R2=7

    header="gene,gene_name,zscore,VAR_g,n,covariance_n,model_n,pred_perf_R2"


contents = os.listdir(FOLDER)

if os.path.exists(OUTPUT): os.remove(OUTPUT)

connection = sqlite3.connect(OUTPUT)
cursor = connection.cursor()
query = 'CREATE TABLE results (' \
' "gene" TEXT,' \
' "gene_name" TEXT,' \
' "zscore" REAL,' \
' "n" INTEGER,' \
' "model_n" INTEGER,' \
' "pred_perf_R2" REAL,' \
' "pval" REAL,' \
' "tissue" TEXT,' \
' "pheno" TEXT' \
' );'
print query
results = cursor.execute(query)
connection.commit()

for content in contents:
    path = os.path.join(FOLDER, content)

    if not "TW_" in content and not "DGN" in content:
        print "skipping " + path
        continue

    tissue = content
    if "_elasticNet" in tissue: tissue =tissue.split("_elasticNet")[0]
    if "-unscaled" in tissue: tissue = tissue.split("-unscaled")[0]
    if ".csv" in tissue: tissue = tissue.split(".csv")[0]

    if "_DGN" in tissue:
        pheno = tissue.split("_DGN")[0]
        tissue = "DGN_WB"
    elif "DGN" in tissue:
        pheno = tissue.split("DGN")[0]
        tissue = "DGN_WB"
    elif "_TW_" in tissue:
        pheno = tissue.split("_TW_")[0]
        tissue = "TW_"+tissue.split("_TW_")[1]
    elif "TW_" in tissue:
        pheno = tissue.split("TW_")[0]
        tissue = "TW_"+tissue.split("TW_")[1]
    else:
        raise RuntimeError("bad name")

    print "opening "+path
    with open(path) as file:
        for i, line in enumerate(file):
            if i==0:
                header = line.strip()
                if header == CSVTF1.header:
                    print "selected new format"
                    RTF=CSVTF1
                elif header == CSVTF2.header:
                    print "selected old format"
                    RTF=CSVTF2
                else:
                    raise RuntimeError("Invalid header")
                continue

            comps = line.strip().split(",")
            if comps[RTF.ZSCORE] == "NA": continue

            gene = comps[RTF.GENE]
            gene_name = comps[RTF.GENE_NAME]
            zscore = float(comps[RTF.ZSCORE])
            n = int(comps[RTF.N])
            model_n = int(comps[RTF.MODEL_N])
            pred_perf_r2 = float(comps[RTF.PRED_PERF_R2])
            if RTF == CSVTF1:
                pval = float(comps[RTF.PVALUE])
            else:
                pval = stats.norm.sf(abs(zscore)) * 2

            cursor.execute(
                    "insert into results (gene, gene_name, zscore, n, model_n, pred_perf_R2, pval, pheno, tissue) values (?,?,?,?,?,?,?,?,?)",
                    (gene, gene_name, zscore, n, model_n, pred_perf_r2, pval, pheno, tissue,))
    connection.commit()

connection.close()