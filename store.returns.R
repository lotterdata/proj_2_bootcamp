source("eff_front_app/helpers.R")
library(stringr)

full.list <- portfolioReturns(c('PFE','NVS','MRK','LLY',
                                'GS','JPM','MS','PNC',
                                'TWX','CMCSA','DIS','DISCA',
                                'WMT','TGT','HD','COST'))

full.list$date <- str_sub(full.list$date, 1, 7)
saveRDS(full.list,"eff_front_app/full_list.rds")