
# function to read data from "household_power_consumption.txt"
getFilterData <- function() {
    # init
    filename <- "household_power_consumption.txt"
    dates <- c(as.Date("01/02/2007", "%d/%m/%Y"), as.Date("02/02/2007", "%d/%m/%Y"))
    
    # read data frame using system.time()
    # user  system elapsed 
    # 12.06    0.56   12.66 
    #
    # read data table using system.time()
    # user  system elapsed 
    # 12.36    0.43   12.79 
    system.time(
        data <- read.csv(filename, sep = ";", header = TRUE)
    )
    
    # filter data and save to cached data
    filterdata <- data[as.Date(data$Date, "%d/%m/%Y") == dates[1] | as.Date(data$Date, "%d/%m/%Y") == dates[2] , ]
    filterdata <- filterdata[complete.cases(filterdata), ]
    return (filterdata)
}

# Read cached data exists then reuse
if(!exists("cacheddata")){
    cacheddata <-getFilterData()
}

# init all x,y for plot 4
timeSeries <- as.POSIXct(paste(cacheddata$Date, cacheddata$Time), format="%d/%m/%Y %H:%M:%S")
activePower <- as.numeric(as.character(cacheddata$Global_active_power))
subMetering1 <- as.numeric(as.character(cacheddata$Sub_metering_1))
subMetering2 <- as.numeric(as.character(cacheddata$Sub_metering_2))
subMetering3 <- as.numeric(as.character(cacheddata$Sub_metering_3))
voltage <- as.numeric(as.character(cacheddata$Voltage))
reactivePower <- as.numeric(as.character(cacheddata$Global_reactive_power))

# create png file with 480x480
png("plot4.png", width=480, height= 480)

# plot 4, make sure 2x2 in single view
par(mfcol = c(2,2))

# plot 4 - 1
plot(timeSeries,
     activePower, 
     type="l",
     lwd=1,
     xlab="",
     ylab="Global Active Power", 
     main="", 
     col = "black")

# plot 4 - 2
plot(timeSeries,
     subMetering1, 
     type="l",
     xlab="",
     ylab="Energy sub metering", 
     main="", 
     col = "black")

lines(timeSeries, 
      subMetering2,
      col="red")

lines(timeSeries, 
      subMetering3,
      col="blue")

legend("topright", 
       lty=1,
       bty = "n",
       col = c("black", "red", "blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# plot 4 - 3
plot(timeSeries,
     voltage, 
     type="l",
     lwd=1,
     xlab="datetime",
     ylab="Voltage", 
     main="", 
     col = "black")

# plot 4 - 4
plot(timeSeries,
     reactivePower, 
     type="l",
     lwd=1,
     xlab="datetime",
     ylab="Global_reactive_power", 
     main="", 
     col = "black")

dev.off()







