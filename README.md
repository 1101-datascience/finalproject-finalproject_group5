# [Group5] 幣圈漫遊

### Groups
* 106703042 楊喻丞
* 108753132 黃翊唐
* 109258003 張竣凱
* 109258042 楊士逸
* 109258040 曾偉恩

### Goal
predict BTC's price

### Demo 
You should provide an example commend to reproduce your result
```R
Rscript code/final.R --input data/data.csv --output results/pred.csv
```

## Folder organization and its related information

### docs
* 1101_datascience_FP_group5.pptx

### data

* Source
  * Bybit加密貨幣交易平台
* Input format
  * data.csv
  * We use volume, open, high, low, close as our features.
* Any preprocessing?
  * omit missing data
  * dimension reduction
  * regularization

### code

* Which method do you use?
  * GBM algorithm
  * MACD trading strategy
* How do your perform evaluation?
  * 5 fold cross-validation

### results

* Which metric do you use? 
  * R-squared, MAE, MSE
* The return we get from our strategy is about 5%.

## packages
* h2o : https://cran.r-project.org/web/packages/h2o/index.html
* ggplot2
