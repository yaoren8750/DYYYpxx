# 插件：显示编译成功，显示的信息
PACKAGE_IDENTIFIER = com.huami.dyyy
PACKAGE_NAME = DYYY
PACKAGE_VERSION = 2.1-7++
PACKAGE_ARCHITECTURE = iphoneos-arm64 iphoneos-arm64e
PACKAGE_REVISION = 1
PACKAGE_SECTION = Tweaks
PACKAGE_DEPENDS = firmware (>= 14.0), mobilesubstrate
PACKAGE_DESCRIPTION = DYYY （原作者：huami1314；魔改：pxx917144686）

# 插件：编译时，引用的信息
define Package/DYYY
  Package: com.huami.dyyy
  Name: DYYY
  Version: 2.1-7++
  Architecture: iphoneos-arm64 iphoneos-arm64e
  Author: huami <huami@example.com>
  Section: Tweaks
  Depends: firmware (>= 14.0), mobilesubstrate
endef

# 直接输出到根路径
export THEOS_PACKAGE_DIR = $(CURDIR)

# TARGET
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0

# 关闭严格错误检查和警告
export DEBUG = 0
export THEOS_STRICT_LOGOS = 0
export ERROR_ON_WARNINGS = 0
export LOGOS_DEFAULT_GENERATOR = internal

# Rootless 插件配置
export THEOS_PACKAGE_SCHEME = rootless
THEOS_PACKAGE_INSTALL_PREFIX = /var/jb

# 目标进程
INSTALL_TARGET_PROCESSES = Aweme

# 引入 Theos 的通用设置
include $(THEOS)/makefiles/common.mk

# 插件名称
TWEAK_NAME = DYYY

# 源代码文件
DYYY_FILES = DYYY.xm DYYYFloatClearButton.xm DYYYFloatSpeedButton.xm AWEPlayInteractionViewController.xm AWEModernLongPressPanelTableViewController.xm CityManager.m DYYYManager.m DYYYSettingViewController.m

# 添加 FLEX 源文件
DYYY_FILES += $(shell find FLEX -name '*.m' -o -name '*.mm') FLEX/flex_fishhook.c

# 编译标志
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -w

# 使用全局C++
CXXFLAGS += -std=c++11
CCFLAGS += -std=c++11

# 保留内部生成器选项
$(TWEAK_NAME)_LOGOS_DEFAULT_GENERATOR = internal

# 框架
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation AVFoundation MediaPlayer

# 修改 FLEX 库配置部分
$(TWEAK_NAME)_LIBRARIES = 
$(TWEAK_NAME)_CFLAGS += -I$(THEOS_PROJECT_DIR)
$(TWEAK_NAME)_CFLAGS += -I$(THEOS)/include
$(TWEAK_NAME)_CFLAGS += -I$(THEOS_PROJECT_DIR)/FLEX # 添加 FLEX 头文件路径

# 编译规则
include $(THEOS_MAKE_PATH)/tweak.mk
clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos packages
# 编译并自动安装
after-package::
	@echo -e "\033[32m==>\033[0m Packaging complete."
	@if [ "$(GITHUB_ACTIONS)" != "true" ] && [ "$(INSTALL)" = "1" ]; then \
        DEB_FILE=$$(ls -t packages/*.deb | head -1); \
        PACKAGE_NAME=$$(basename "$$DEB_FILE" | cut -d'_' -f1); \
        echo -e "\033[34m==>\033[0m Installing $$PACKAGE_NAME to device…"; \
        ssh root@$(THEOS_DEVICE_IP) "rm -rf /tmp/$${PACKAGE_NAME}.deb"; \
        scp "$$DEB_FILE" root@$(THEOS_DEVICE_IP):/tmp/$${PACKAGE_NAME}.deb; \
        ssh root@$(THEOS_DEVICE_IP) "dpkg -i --force-overwrite /tmp/$${PACKAGE_NAME}.deb && rm -f /tmp/$${PACKAGE_NAME}.deb"; \
	else \
        echo -e "\033[33m==>\033[0m Skipping installation (GitHub Actions environment or INSTALL!=1)"; \
	fi
