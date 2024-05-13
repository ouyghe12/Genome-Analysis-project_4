library(vcfR)
library(tidyverse)

vcf <- read.vcfR("merged.vcf")
if (is.null(vcf)) {
  stop("VCF file could not be read. Please check the file path and format.")
}

vcf_df <- as.data.frame(vcf@fix)

extract_frequency <- function(info_string) {
  key_value_pairs <- str_split(info_string, ";")[[1]]
  frequency <- NA
  
  af_found <- FALSE
  ac_found <- FALSE
  an_found <- FALSE
  ac_value <- NA
  an_value <- NA
  
  for (pair in key_value_pairs) {
    if (str_detect(pair, "^AF=")) {
      freq_part <- str_replace(pair, "AF=", "")
      if (!is.na(as.numeric(freq_part)) && !is.nan(as.numeric(freq_part))) {
        frequency <- as.numeric(freq_part)
        af_found <- TRUE
        break
      }
    } else if (str_detect(pair, "^AC=")) {
      ac_part <- str_replace(pair, "AC=", "")
      if (!is.na(as.numeric(ac_part)) && !is.nan(as.numeric(ac_part))) {
        ac_value <- as.numeric(ac_part)
        ac_found <- TRUE
      }
    } else if (str_detect(pair, "^AN=")) {
      an_part <- str_replace(pair, "AN=", "")
      if (!is.na(as.numeric(an_part)) && !is.nan(as.numeric(an_part))) {
        an_value <- as.numeric(an_part)
        an_found <- TRUE
      }
    }
  }
  
  if (!af_found && ac_found && an_found && an_value > 0) {  
    frequency <- ac_value / an_value
  }
  
  return(frequency)
}

vcf_df$Frequency <- sapply(vcf_df$INFO, extract_frequency)

freq_data <- vcf_df %>%
  filter(!is.na(Frequency))

ggplot(freq_data, aes(x = Frequency)) +
  geom_histogram(binwidth = 0.01, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Frequency Distribution", x = "Frequency", y = "Count")
