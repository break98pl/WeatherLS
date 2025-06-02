ARCHS = arm64 arm64e
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
export TARGET := iphone:clang:16.5:14.0
PACKAGE_VERSION = 9.9.9

INSTALL_TARGET_PROCESSES += SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeatherLS

WeatherLS_LIBRARIES += pddokdo
WeatherLS_FRAMEWORKS = SpringBoard SpringBoardFoundation SpringBoardUIServices
WeatherLS_FILES = $(shell find Sources/WeatherLS -name '*.swift') $(shell find Sources/WeatherLSC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
WeatherLS_SWIFTFLAGS = -ISources/WeatherLSC/include
WeatherLS_CFLAGS = -fobjc-arc -ISources/WeatherLSC/include

include $(THEOS_MAKE_PATH)/tweak.mk
