## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from 
# all sources for each of the years 1999, 2002, 2005 and 2008.

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

# Calculate total emissions in USA per year

TE <- aggregate(Emissions ~ year, NEI, FUN = sum)
colnames(TE) <- c("Year", "Total.Emissions")

# plot Total Emissions in USA per Year
png(filename="plot1.png",width=480, height=480)
barplot(height=TE$Total.Emissions, names.arg=TE$Year, xlab="Year", ylab="Total Emissions",
        main = "Total emissions in USA in tons of PM2.5 emitted per year", col="turquoise3")
dev.off()