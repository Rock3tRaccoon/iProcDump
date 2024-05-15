TARGET := iphone:clang:latest:16.5

include $(THEOS)/makefiles/common.mk

TOOL_NAME = pd

pd_FILES = main.m
pd_CFLAGS = -fobjc-arc
pd_CODESIGN_FLAGS = -Sentitlements.plist
pd_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk
THEOS_DEVICE_IP = iPhoneRoot
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_USER = root

