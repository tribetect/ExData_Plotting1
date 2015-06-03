
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

#Plot 2 Line graph
#Title: Null?
#X: Days of the week
#Y: Global Active Power (kilowatts)

png(file = "plot2.png", bg = "transparent", width = 480, height = 480, units = "px")


plot(x = powerdata$DateTime, y = powerdata$Global_active_power, type = "l", 
     xlab = "", ylab = "Global active power (kilowatts)")


#Watermark PNG file
mtext(text = paste("BY github/tribetect", Sys.time()), side = 4,  
      line = 0.5, col = "gray")

#Cleanup: Close Graphic Device and File Connections
dev.off()
close(hpcfile)