## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 5 
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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

# subset data for Baltimore
NEI.Balt <- subset(NEI, fips == "24510")

# subset data for motor vehicle related sources in Baltimore
SCC.Vehicle <- SCC[grepl("vehicle" , SCC$EI.Sector, ignore.case=TRUE), ]
NEI.Balt.Vehicle <- NEI.Balt[NEI.Balt$SCC %in% SCC.Vehicle$SCC, ]

# Calculate total emissions for motor vehicle related sources in Baltimore, MD, USA per year 
TE <- aggregate(Emissions ~ year, NEI.Balt.Vehicle, FUN = sum)
colnames(TE) <- c("Year", "Total.Emissions")
# 
# plot Total Emissions for motor vehicle related sources in Baltimore, MD, USA per year
png("plot5.png", width=480, height=480)
g <- ggplot(TE, aes(factor(Year), Total.Emissions)) +
  geom_bar(colour="black", fill="turquoise3", width=.6, stat="identity") +
  xlab("year") + ylab("Total Emissions") +
  ggtitle("Total Emissions in Baltimore, MD, USA  from motor vehicle related sources \nin tons of PM2.5 emitted per year") +
  theme(plot.title = element_text(hjust = 0.5))
print(g)
dev.off()