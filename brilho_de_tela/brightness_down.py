actual = open("/sys/class/backlight/intel_backlight/brightness","w+")

#min = 90
min = 9
bright = int(actual.read()) - 80

if (bright >= min):
        actual.write("%s" % (bright))
else:
        actual.write("%s" % (min))
