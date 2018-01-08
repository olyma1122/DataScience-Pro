library('dplyr') # data manipulation
library('readr') # input/output
library('tibble') # data wrangling


train <- as.tibble(fread('train.csv'))
members <- as.tibble(fread('members_v3.csv'))
trans <- as.tibble(fread('transactions.csv'))


df1 <- merge(x = train, y = members, by = "msno")
df1$is_churn <- NULL
df1$bd <- NULL
df1$gender <- NULL
df1$registration_init_time <- NULL

df2 <- merge(x = train, y = trans, by = "msno")
df2$is_churn <- NULL
df2$plan_list_price <- NULL
df2$actual_amount_paid <- NULL
df2$transaction_date <- NULL
df2$membership_expire_date <- NULL

data <- merge(x = df1, y = df2, by = "msno")

cleandata <- merge(x = train, y = data, by = "msno")

#saveRDS(cleandata,"cleandata.rds")
#write.csv(cleandata,file="cleandata.csv",row.names = F)
cleandata$msno <- NULL

###

#str(cleandata$is_churn)
#summary(cleandata$is_churn)

set.seed(1122)
cleandata$rgroup <- runif(dim(cleandata)[[1]])

dTrain <- subset(cleandata,rgroup>0.99)
#write.csv(dTrain,file="litedata.csv",row.names = F)
#saveRDS(dTrain,"litedata.rds")
dTest <- subset(cleandata,rgroup<0.002)

dTrain$rgroup <- NULL
dTest$rgroup <- NULL

#summary(dTrain$is_churn)

dTrain[["is_churn"]] = factor(dTrain[["is_churn"]])

library('e1071')
library('caret')

#Parallel Processing
library(doMC)
registerDoMC(cores = 2)

ctrl <- trainControl(method = "repeatedcv", number = 5, repeats = 1)
knn_fit <- train(is_churn ~., data=dTrain, method = "nb",
                 trControl = ctrl)
knn_fit

pr1 <- predict(knn_fit, newdata = dTest)


conf <- confusionMatrix(pr1,dTest$is_churn, mode = "prec_recall")
conf

conf$overall
conf

  
output <- data.frame(Precision=conf$byClass[5], Recall=conf$byClass[6], F1=conf$byClass[7], 
                  Accuracy=conf$overall[1], PValue=conf$overall[6], 
                  Sensitivity=conf$byClass[1], Specificity=conf$byClass[2])
output
write.table(output, 'outFile.csv', row.names=FALSE, sep = ",")
