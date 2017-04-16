## Programming Assignment for Exploratory Data Analysis Course Project 2
# Question 6 
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

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

# subset data for Baltimore and Los Angeles
NEI.Balt_LA <- subset(NEI, fips == "24510" | fips == "06037")

# subset data for motor vehicle related sources 
SCC.Vehicle <- SCC[grepl("vehicle" , SCC$EI.Sector, ignore.case=TRUE), ]
NEI.Balt_LA.Vehicle <- NEI.Balt_LA[NEI.Balt_LA$SCC %in% SCC.Vehicle$SCC, ]

# create column city with city names corresponding to fips code 
NEI.Balt_LA.Vehicle$city <- rep("",nrow(NEI.Balt_LA.Vehicle))
NEI.Balt_LA.Vehicle$city[NEI.Balt_LA.Vehicle$fips == "06037"] <- "Los Angeles"
NEI.Balt_LA.Vehicle$city[NEI.Balt_LA.Vehicle$fips == "24510"] <- "Baltimore"


# Calculate total emissions for motor vehicle related sources in Baltimore, MD, USA per year
TE <- aggregate(Emissions ~ year + city, NEI.Balt_LA.Vehicle, FUN = sum)
colnames(TE) <- c("Year", "City", "Total.Emissions")
#
# plot Total Emissions for motor vehicle related sources in Baltimore, MD, USA per year
png("plot6.png", width=480, height=480)
g <- ggplot(TE, aes(x=factor(Year), y=Total.Emissions, fill=City)) +
  geom_bar(width=.6, stat="identity",position=position_dodge()) +
  xlab("year") + ylab("Total Emissions") +
  ggtitle("Comparison of Total Emissions from motor vehicle related sources 
    between Baltimore, MD and Los Angeles, CA 
    in tons of PM2.5 emitted per year") +
  theme(plot.title = element_text(hjust = 0.5))
print(g)
dev.off()