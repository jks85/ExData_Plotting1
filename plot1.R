#install and load dependent packages
# R may throw a warning if the packages are already installed
install.packages(c("dplyr","lubridate"))
library(dplyr)
library(lubridate)

# ZIP FOLDER MUST BE IN WORKING DIRECTORY
# unzip data file folder into working directory (github clone of repo)


unzip("./exdata_data_household_power_consumption.zip",exdir = getwd())



#read in data
house_power = read.table("household_power_consumption.txt", header = TRUE, sep = ';')

# create POSIXlt date variable from Date and Time columns
house_power <- mutate(house_power, Date_Time = strptime(paste(Date,Time), format = '%d/%m/%Y %H:%M:%S', tz = 'UTC'))

#convert Dates format easier regex matching
house_power$Date <- as.Date(house_power$Date, format = '%d/%m/%Y')


# use regex to subset dates from 2/1/2007 to 2/2/2007

desired_data <- house_power[grepl("(2007-02-01|2007-02-02)",house_power$Date),]


# open png device. default is 480 x 480
png(filename = "plot1.png") 

# create plot 1. Note data must be coerced to numeric
with(desired_data, hist(as.numeric(Global_active_power), col = 'red', xlab = "Global Active Power (kilowatts)" ,main = "Global Active Power"))

# turn off graphics device
dev.off()



