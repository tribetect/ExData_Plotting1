
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

#Plot 3 Line graphs for sub_meterings 1,2,3
#X: Days/DateTime
#Y: Global Active Power (kilowatts)

png(file = "plot3.png", bg = "transparent", width = 480, height = 480, units = "px")

with(powerdata, plot(x = DateTime, y = Sub_metering_1, type = "l", ylab = "Energy sub metering"))
with(powerdata, points(x = DateTime, y = Sub_metering_2, type = "l", col = "red"))
with(powerdata, points(x = DateTime, y = Sub_metering_3, type = "l", col = "blue"))


legend(x = "topright", pch = "l", col = c("black", "red", "blue"), 
       legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))

#Watermark PNG file
mtext(text = paste("BY github/tribetect", Sys.time()), side = 4,  
      line = 0.5, col = "gray")

#Cleanup: Close Graphic Device and File Connections
dev.off()
close(hpcfile)