
myDss = DSSMat
myDss.open('test.dss')
myDss.catalog()
records = myDss.catalog()
data = myDss.read('/TEST/BASIN/RAIN/01JAN1990/1MON/OBS/')
plot(data(:, 1), data(:, 2))
