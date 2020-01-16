#Essential changes for each release
releaseVersion = "v0.1.0"
releaseYear    = "2020"


deviceNode = ATDF.getNode("/avr-tools-device-file/devices")
deviceChild = []
deviceChild = deviceNode.getChildren()
deviceName = deviceChild[0].getAttribute("series")
print(deviceName)

global getDeviceName
getDeviceName = classBComponent.createStringSymbol("DEVICE_NAME", classBMenu)
getDeviceName.setDefaultValue(deviceName)
getDeviceName.setVisible(False)

getreleaseVersion = classBComponent.createStringSymbol("REL_VER", classBMenu)
getreleaseVersion.setDefaultValue(releaseVersion)
getreleaseVersion.setVisible(False)

getreleaseYear = classBComponent.createStringSymbol("REL_YEAR", classBMenu)
getreleaseYear.setDefaultValue(releaseYear)
getreleaseYear.setVisible(False)