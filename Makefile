export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.5:15.0
export FINALPACKAGE=1
export THEOS_DEVICE_IP= 192.168.1.238
INSTALL_TARGET_PROCESSES = SpringBoard
PACKAGE_VERSION = 1.0.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeatherLS

WeatherLS_FILES = Tweak.xm
WeatherLS_LIBRARIES += pddokdo
WeatherLS_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
