
#Load essential libraries
require(sqldf) #to help filter out rows before reading raw data file

#Pre-flight check: is the dataset file available in the working directory?
foundData <- ("household_power_consumption.txt" %in% dir())
  #Terminate script, if dataset not found in working directory
    error_message = paste0("Terminating Script: Dataset Not Found in Working Directory: ", getwd())    
    if(!foundData) { stop(error_message) }

#Read just the data for Feb 1 and 2 of year 2007 using sqldf
hpcfile <- file("household_power_consumption.txt")
powerdata <- sqldf('select * from hpcfile 
                    where "Date" == "1/2/2007" OR "Date" == "2/2/2007"',
                   file.format = list(sep = ";", header = TRUE, row.names = FALSE))

#Combine Date and Time columns into a new single column
powerdata$DateTime <- strptime(paste(powerdata$Date, powerdata$Time, sep = " "),"%d/%m/%Y %H:%M:%S")

#Rearrange columns: Make DateTime 1st column:
powerdata <- powerdata[c(10, 1:9)]

#Histogram 1
#Title: Global Active Power
#X: Global Active Power (kilowatts)
#Y: frequency

png(file = "plot1.png", bg = "transparent", width = 480, height = 480, units = "px")

hist(x = powerdata$Global_active_power, xlab = "Global Active Power (kilowatts)", 
     col = "red", main = "Global Active Power")

#Watermark PNG file
mtext(text = paste("BY github/tribetect", Sys.time()), side = 4,  
      line = 0.5, col = "gray")

#Cleanup: Close Graphic Device and File Connections
dev.off()
close(hpcfile)