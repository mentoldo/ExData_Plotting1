## Getting data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, "household_power_consumption.zip")
if(!dir.exists("./data")) dir.create("./data")
unzip("household_power_consumption.zip", exdir = "./data/")
file.remove("household_power_consumption.zip")

## Reading and Cleaning Data
# Reading data. Only read the rows corresponding from the date 2007-02-01 to 2007-02-02
colnames <- read.table("./data/household_power_consumption.txt", sep = ";", nrows = 1, stringsAsFactors = FALSE)
consumption <- read.table("./data/household_power_consumption.txt", sep = ";", na.strings = "?",
                          colClasses = c("character", "character", "numeric", "numeric", "numeric",
                                         "numeric", "numeric", "numeric", "numeric"),
                          nrows = 2880, skip = 66637)
# Editing variable names
names(consumption) <- colnames[1,]
names(consumption) <- tolower(gsub("_", "", names(consumption)))

# Transforming Date and Time variables into one POSIXct class variable
datetime <- paste(consumption$date, consumption$time)
datetime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")
consumption <- data.frame(datetime, consumption[,-(1:2)])

## Plot 3 ##
png("plot2.png")
with(consumption, {
    plot(datetime, globalactivepower, type = "n",
         ann = FALSE)
    lines(datetime, globalactivepower)
    title(ylab = "Global Active Power (kilowatts)")
})
dev.off()
