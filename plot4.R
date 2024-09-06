# install and load dependent packages
# R may throw a warning if the packages are already installed
install.packages(c("dplyr","lubridate"))
library(dplyr)
library(lubridate)


# added code to download zip folder from web if necessary. 
# previous code required zip folder to be in working directory
# unzip data file folder into working directory (github clone of repo)

if(!dir.exists("./exdata_data_household_power_consumption.zip"))
{
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, "exdata_data_household_power_consumption.zip")
  
}

unzip("./exdata_data_household_power_consumption.zip",exdir = getwd())



#read in data
house_power = read.table("household_power_consumption.txt", header = TRUE, sep = ';')

# create POSIXlt date variable from Date and Time columns
house_power <- mutate(house_power, Date_Time = strptime(paste(Date,Time), format = '%d/%m/%Y %H:%M:%S', tz = 'UTC'))

#convert Dates format easier regex matching
house_power$Date <- as.Date(house_power$Date, format = '%d/%m/%Y')


# use regex to subset dates from 2/1/2007 to 2/2/2007

desired_data <- house_power[grepl("(2007-02-01|2007-02-02)",house_power$Date),]

# identify midnight for 2/1/2007, 2/2/2007, 
# note: last value is actually 23:59:00 b/c it is the last time logged in the data set
# these values will be used to plot axes in all 4 sub plots
midnight_int <- 60*24
feb_1_midnight <- desired_data$Date_Time[1]
feb_2_midnight <- desired_data$Date_Time[1+midnight_int]
feb_3_midnight <- desired_data$Date_Time[2*midnight_int]




# open png device. default is 480 x 480
png(filename = "plot4.png") 

# want 4 plots in a 2x2 grid
par(mfcol = c(2,2))


# plot 4.1

# initialize sub plot 1. 
# Note data must be coerced to numeric
# initialize plot as empty and without x-axis labels
with(desired_data, plot(Date_Time, as.numeric(Global_active_power), type = 'n', xlab = '', ylab  = "Global Active Power", xaxt = 'n'))

# annotate lines
with(desired_data, lines(Date_Time, as.numeric(Global_active_power)))


# use axis.POSIXct to set x-axis to be days of week in date range
# use midnight labels to note Thu, Fri, Sat
axis.POSIXct(side = 1, at= c(feb_1_midnight, feb_2_midnight,feb_3_midnight), labels = c("Thu","Fri","Sat"))



# plot 4.2
# initialize sub plot 2. 
# Note data must be coerced to numeric
# initialize plot as empty and without x-axis labels
with(desired_data, plot(Date_Time, as.numeric(Sub_metering_1), type = 'n', xlab = '', ylab  = "Energy sub metering", xaxt = 'n'))

# annotate lines for reach sub_meter
with(desired_data, lines(Date_Time, as.numeric(Sub_metering_1)))
with(desired_data, lines(Date_Time, as.numeric(Sub_metering_2),col = 'red'))
with(desired_data, lines(Date_Time, as.numeric(Sub_metering_3),col = 'blue'))

# add legend
legend("topright", legend = c('Sub_metering_1', 'Sub_metering_2','Sub_metering_3'), 
       lty = c(1,1,1), col = c('black','red','blue'), lwd = 1, cex = 0.7, bty = 'n')

# add x-axis labels
axis.POSIXct(side = 1, at= c(feb_1_midnight, feb_2_midnight,feb_3_midnight),
             labels = c("Thu","Fri","Sat"))


# plot 4.3
# initialize sub plot 3 
# Note data must be coerced to numeric
# initialize plot as empty and with axis labels, but no x-axis ticks
with(desired_data, plot(Date_Time, as.numeric(Voltage), xlab = 'datetime', 
                        ylab = 'Voltage',xaxt ='n', type = 'n'))

# add lines
with(desired_data, lines(Date_Time, as.numeric(Voltage)))

# add x-axis labels
axis.POSIXct(side = 1, at= c(feb_1_midnight, feb_2_midnight,feb_3_midnight), 
             labels = c("Thu","Fri","Sat"))

# plot 4.4
# initialize sub plot 4 
# Note data must be coerced to numeric
# initialize plot as empty and with axis labels, but no x-axis ticks
with(desired_data, plot(Date_Time, as.numeric(Global_reactive_power), xlab = 'datetime', 
                        ylab = 'Global_reactive_power',xaxt ='n', type = 'n'))

# add lines
with(desired_data, lines(Date_Time, as.numeric(Global_reactive_power)))

# add x-axis labels
axis.POSIXct(side = 1, at= c(feb_1_midnight, feb_2_midnight,feb_3_midnight), 
             labels = c("Thu","Fri","Sat"))


# turn off graphics device
dev.off()