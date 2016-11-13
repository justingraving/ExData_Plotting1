rm(list = ls())

## Upload data to data folder
if(!file.exists("./data")){dir.create("./data")}
setwd("./data")
fileURL <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data <-download.file(fileURL, destfile = "EPC_data.zip", method = "auto")
unzip ("EPC_data.zip", exdir="data")

## Create Data Object with data from 2007-02-01 to 2007-02-02
epc_data <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)
epc_data[epc_data == "?"]=NA
epc_data$Date<-strptime(epc_data$Date, "%d/%m/%Y")
epc_data <- subset(epc_data, Date >= "2007-02-01" & Date <= "2007-02-02")

##convert to numeric 
epc_data$Global_active_power <- as.numeric(levels(epc_data$Global_active_power))[epc_data$Global_active_power]
epc_data$Sub_metering_1 <- as.numeric(levels(epc_data$Sub_metering_1))[epc_data$Sub_metering_1]
epc_data$Sub_metering_2 <- as.numeric(levels(epc_data$Sub_metering_2))[epc_data$Sub_metering_2]
epc_data$Voltage <- as.numeric(levels(epc_data$Voltage))[epc_data$Voltage]
epc_data$Global_reactive_power <- as.numeric(levels(epc_data$Global_reactive_power))[epc_data$Global_reactive_power]

##create datetime variable
epc_data$datetime <- paste(as.Date(epc_data$Date), epc_data$Time)
epc_data$datetime <- as.POSIXct(epc_data$datetime)

##Create plot 1
par(mfrow = c(1,1))
hist(epc_data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, file = 'plot1.png', height=480, width=480)
dev.off()

##Create plot 2
plot(epc_data$Global_active_power~epc_data$datetime, type = "l", xlab = "", ylab = "Global Active Power (killowatts)")
dev.copy(png, file = 'plot2.png', height=480, width=480)
dev.off()

##Create plot 3
plot(epc_data$Sub_metering_1~epc_data$datetime, type = "l", ylab = "Energy sub metering", xlab = "")
lines(epc_data$Sub_metering_2~epc_data$datetime, type = "l", col = "red")
lines(as.numeric(epc_data$Sub_metering_3)~epc_data$datetime, type = "l", col = "blue")
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file = 'plot3.png', height=480, width=480)
dev.off()

##Create plot 4
par(mfrow = c(2,2))
plot(epc_data$Global_active_power~epc_data$datetime, type = "l", xlab = "", ylab = "Global Active Power")
plot(epc_data$Voltage~epc_data$datetime, type = "l", xlab = "", ylab = "Voltage")
plot(epc_data$Sub_metering_1~epc_data$datetime, type = "l", ylab = "Energy sub metering", xlab = "")
lines(epc_data$Sub_metering_2~epc_data$datetime, type = "l", col = "red")
lines(as.numeric(epc_data$Sub_metering_3)~epc_data$datetime, type = "l", col = "blue")
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(epc_data$Global_reactive_power~epc_data$datetime, type = "l", xlab = "", ylab = "Global_reactive_power")
dev.copy(png, file = 'plot4.png', height=480, width=480)
dev.off()
