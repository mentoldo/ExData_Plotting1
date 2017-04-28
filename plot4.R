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

## Plot 4 ##
png("plot4.png")

par(mfcol = c(2,2))
with(consumption, {
    ## Plot a
    plot(datetime, globalactivepower, type = "n", ann = FALSE)
    lines(datetime, globalactivepower)
    title(ylab = "Global Active Power (kilowatts)")
    ## Plot b
    plot(datetime, submetering1, type = "n", ann = FALSE)
    title(ylab = "Energy sub metering")
    lines(datetime, submetering1, col = 1)
    lines(datetime, submetering2, col = 2)
    lines(datetime, submetering3, col = 4)
    legend("topright", lty = 1, col = c(1, 2, 4),
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    ## Plot c
    plot(datetime, voltage, type = "l", ann = FALSE)
    title(ylab = "Voltage", xlab = "datetime")
    ## Plot d
    plot(datetime, globalreactivepower, type = "l", ann = FALSE)
    title(ylab = "Global_reactive_power", xlab = "datetime")
})

dev.off()
