
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

# init value for plot 2
timeSeries <- as.POSIXct(paste(cacheddata$Date, cacheddata$Time), format="%d/%m/%Y %H:%M:%S")
activePower <- as.numeric(as.character(cacheddata$Global_active_power))

# create png file with 480x480
png("plot2.png", width=480, height= 480)

plot(timeSeries,
     activePower, 
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)", 
     main="", 
     col = "black")

dev.off()





