#!/usr/bin/env Rscript


args=commandArgs(trailingOnly=TRUE)
name_table=args[1]
name_final=args[2]
trained_model <- readRDS("trained_model_new.RDS")

# Check if the trained model exists, if not, train and save it
if (!file.exists("trained_model_new.RDS")) {
  train_model_and_save()
}

# PREDICTION FUNCTION
predict_output <- function(trained_model, new_data) {
  validating_rf <- predict(trained_model, new_data)
  output <- cbind(rownames(new_data), validating_rf)
  return(output)
}


input_R <- read.table(name_table, row.names = 1, header = TRUE, sep = "\t", check.names = FALSE)
for (col in colnames(input_R)) {
  input_R[, col] <- as.numeric(input_R[, col])
}
input_R[is.na(input_R)] <- 0

column_index <- which(names(input_R) == "real miRNA")
new_column_order <- c(names(input_R)[-column_index], "real miRNA")
df_1917 <-input_R[new_column_order]

# Normalization
performNormalization <- function(data) {
  normalized_data <- data[, 1:36] / data$`hairpin length`
  normalized_data[, 37] <- data[, 37] / 100
  normalized_data <- cbind(normalized_data, data[, 38:71] / data$`hairpin length`)
  normalized_data <- cbind(normalized_data, data[, 72:81])
  normalized_data <- cbind(normalized_data, data[, 82:124] / data$`hairpin length`)
  normalized_data <- cbind(normalized_data, data[, 125:125])
  colnames(normalized_data)[37] <- 'hairpin length'
  colnames(normalized_data)[125] <- 'real miRNA'
  return(normalized_data)
}

new_1917_normL <- performNormalization(df_1917)


# Use the loaded trained model to make predictions
set.seed(825)
output <- predict_output(trained_model, new_1917_normL)
colnames(output) <- c("miRNA name", "prediction")

# Write the updated output to a file with the specified column names
write.table(output, name_final, sep = "\t", col.names = TRUE, row.names = FALSE)

#write.table(output, "final_output.tsv")
