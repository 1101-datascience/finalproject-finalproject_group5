library(ggplot2)

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("USAGE: Rscript final.R input", call.=FALSE)
} else if (length(args)==1) {
  i_f <- args[1] 
}

################
if (length(args)==4){
  if(args[1]=="--input"){
    inputpath <- args[2]
    outputpath <- args[4]
  }
  if(args[3]=="--input"){
    inputpath <- args[4]
    outputpath <- args[2]
  }
}
infilename <- unlist(strsplit(inputpath,'/',fixed = TRUE))
setname <- infilename[length(infilename)]
setname <- sub(pattern = '.csv',replacement = '',x=setname)
#################create new folder for output
final <- ''
out <- as.list(unlist(strsplit(outputpath,'/',fixed = TRUE)))
for (i in c(1:(length(out)-1))){
  #print(out[[i]])
  final <- paste(final,out[[i]],sep='/')
}
final <- sub(pattern = '/',replacement = '',x = final)
if(dir.exists(final)==FALSE){
  dir.create(final,recursive = TRUE)
  print("output dir not exist,create a new one")
}
######################
#x <- read.csv(file=inputpath)

data <- read.csv("./data/data.csv")
print(data)
ggplot(data,aes(x=start_at,y=close))+geom_line()
#keep <- c("open","high","low","close") 
#data <- data[keep]
head(data)
#######################

normalize <- function(x) {
  return((x- min(x)) /(max(x)-min(x)))
}
data["close"] <- as.data.frame(apply(data["close"],2, normalize))
data["high"] <- as.data.frame(apply(data["high"],2, normalize))
data["open"] <- as.data.frame(apply(data["open"],2, normalize))
data["low"] <- as.data.frame(apply(data["low"],2, normalize))
data["shifted"] <- as.data.frame(apply(data["shifted"],2, normalize))

print(data)
ggplot(data,aes(x=start_at,y=shifted))+geom_line()
##################
library(h2o) 
h2o.init(nthreads = -1, max_mem_size = "8g") 

y <- "shifted" #variable we want to forecast 
x <- c("open","high","low","close")
l <- round(nrow(data)*0.8)
train <- data[c(1:l),]
test <- data[c(l+1:nrow(data)),]
train <- as.h2o(train)
test <- as.h2o(test)
qq <- as.data.frame(test)
ggplot(qq,aes(x=start_at,y=close))+geom_line()
print(train)
##################


model_a=h2o.loadModel("./GBM_nor_4f_nshuf_times/StackedEnsemble_BestOfFamily_4_AutoML_4_20220109_214506")
pred <- h2o.predict(model_a, test)
deno <- function(x,max,min) {
  return(x*(max-min)+min)
}
deno_truth <- read.csv("./data/data.csv")
deno_truth$shifted <- shift(deno_truth$close, 1) 
deno_truth <- na.omit(deno_truth)
print(max(deno_truth["close"]))
predictions <- deno(predictions,max(deno_truth["shifted"]),min(deno_truth["shifted"]))
print(predictions)
test["shifted"] <- deno(test["shifted"],max(deno_truth["shifted"]),min(deno_truth["shifted"]))
s <- cal(array(pred),array(test["shifted"]))
h2o.exportFile(pred,path="./results/pred_nor.csv",force=TRUE)
