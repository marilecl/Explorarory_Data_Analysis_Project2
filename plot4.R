## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 4 
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

library(ggplot2)

filename <- "getdata_dataset.zip"


# Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename, mode = "wb")
}  
if (!file.exists("summarySCC_PM25.rds") & !file.exists("Source_Classification_Code.rds")) { 
  unzip(filename) 
}


# Get the datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset SCC and NEI datasets for coal combustion-related sources
SCC.coal <- SCC[grepl("Coal" , SCC$Short.Name, ignore.case=TRUE), ]
NEI.coal <- NEI[NEI$SCC %in% SCC.coal$SCC, ]


# # Calculate total emissions for coal combustion-related sources per year 
TECoal <- aggregate(Emissions ~ year, NEI.coal, FUN = sum)
colnames(TECoal) <- c("Year", "Total.Emissions")
# 
# plot Total Emissions for coal combustion-related sources in USA per year
png("plot4.png", width=480, height=480)
g <- ggplot(TECoal, aes(factor(Year), Total.Emissions)) + 
  geom_bar(colour="black", fill="turquoise3", width=.6, stat="identity") + 
  xlab("year") + ylab("Total Emissions") +
  ggtitle("Total Emissions in USA from coal combustion-related sources \nin tons of PM2.5 emitted per year") +
  theme(plot.title = element_text(hjust = 0.5))
print(g)
dev.off()