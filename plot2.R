## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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

# Calculate total emissions per year for Baltimore,MD,USA
NEI.Balt <- subset(NEI, fips == "24510")
TE <- aggregate(Emissions ~ year, NEI.Balt, FUN = sum)
colnames(TE) <- c("Year", "Total.Emissions")

# plot Total Emissions for Baltimore, MD, USA vs Year
png(filename="plot2.png",width=480, height=480)
barplot(height=TE$Total.Emissions, names.arg=TE$Year, xlab="Year", ylab="Total Emissions",
        main = "Total emissions in Baltimore, MD, USA \nin tons of PM2.5 emitted per year", col="turquoise3")
dev.off()