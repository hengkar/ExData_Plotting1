
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

# init all x,y for plot 3
timeSeries <- as.POSIXct(paste(cacheddata$Date, cacheddata$Time), format="%d/%m/%Y %H:%M:%S")
subMetering1 <- as.numeric(as.character(cacheddata$Sub_metering_1))
subMetering2 <- as.numeric(as.character(cacheddata$Sub_metering_2))
subMetering3 <- as.numeric(as.character(cacheddata$Sub_metering_3))

# create png file with 480x480
png("plot3.png", width=480, height= 480)

# plot 3
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
       col = c("black", "red", "blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


dev.off()

