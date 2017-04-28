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

## Plot 1
png("plot1.png")
hist(consumption$globalactivepower,
     col = "red",
     main = "Global Active Power",
     xlab = "Gobal Active Power (kilowatts)")
dev.off()
