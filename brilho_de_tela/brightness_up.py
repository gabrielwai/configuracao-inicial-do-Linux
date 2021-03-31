max = open("/sys/class/backlight/intel_backlight/max_brightness")
actual = open("/sys/class/backlight/intel_backlight/brightness","w+")

max = int(max.read())
bright = int(actual.read()) + 80

if (bright <= max):
        actual.write("%s" % (bright))
else:
        actual.write("%s" % (max))
