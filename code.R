#packages 
library("xlsx")
library("janitor")
library("tidyverse")

#fetch data from nrs website - probably need to update link each week
download.file("https://www.nrscotland.gov.uk/files//statistics/covid19/covid-deaths-data-week-16.xlsx", destfile="excel.xlsx")
df <- read.xlsx("excel.xlsx", sheetIndex=19 , 
                startRow=6, endRow=43, header=FALSE)
df <- df %>%
  select(-X3) %>%
  filter(!is.na(X2)) %>%
  rename(Date=X1) 

Deaths <-as_tibble(diff(df$X2, lag=1)) %>% 
  add_row(value=df$X2[1], .before=1)

df <- df %>%
  bind_cols(Deaths) %>%
  rename(Deaths=value) %>%
  mutate(check=cumsum(Deaths))

remove(Deaths)

#plot

ggplot(data=df, aes(x=Date, y=Deaths)) +
  geom_bar(stat="identity") +
  ggtitle("Deaths from Covid-19 in Scotland by Date of Death",
          subtitle="NRS Data from https://www.nrscotland.gov.uk/covid19stats")

ggsave("plot.png")