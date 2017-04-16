## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the 
# ggplot2 plotting system to make a plot answer this question.

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
# SCC <- readRDS("Source_Classification_Code.rds")

# Calculate total emissions by type per year for Baltimore, MD, USA
NEI.Balt <- subset(NEI, fips == "24510")
TEbyType <- aggregate(Emissions ~ year + type, NEI.Balt, FUN = sum)
colnames(TEbyType) <- c("Year", "Type", "Total.Emissions")

# plot Total Emissions by source type per Year for Baltimore, MD, USA
png("plot3.png", width=480, height=480)
g <- ggplot(TEbyType, aes(Year, Total.Emissions, color = Type)) + geom_line(size=1.1) + geom_point(size=2) +
  xlab("year") + ylab("Total Emissions") +
  ggtitle("Total Emissions in Baltimore, MD,USA by source type \nin tons of PM2.5 emitted per year") +
  theme(plot.title = element_text(hjust = 0.5))
print(g)
dev.off()