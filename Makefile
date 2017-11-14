
# Copyright (C) 2012-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hustoj
PKG_VERSION:=r3120.58b04b80
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/zhblue/hustoj.git
PKG_SOURCE_DATE:=2017-11-10

# used for i686/x86_64
#PKG_SOURCE_VERSION:=c630bc450fe1a1d61240737000d6022305054d85
#PKG_MIRROR_HASH:=

# used for ARM
PKG_SOURCE_VERSION:=01ff618ea3052ddb2c46eb31a6a0bbdd2eda16aa
#PKG_MIRROR_HASH:=

PKG_MAINTAINER:=yhfudev
PKG_LICENSE:=GPL

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/hustoj
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=hustoj for web server
  URL:=https://github.com/zhblue/hustoj.git
  DEPENDS:= +libstdcpp +libmysqlclient +php7-mod-simplexml
  MENU:=0

  MAKE_PATH=trunk/core
  CONFIGURE_PATH=trunk/core
  CONFIGURE_ARGS+= --disable-debug
  TARGET_LDFLAGS += "-L$(STAGING_DIR)/usr/lib/mysql/"
endef

define Package/hustoj/description
  HUST Online Judge
endef

define Package/hustoj/install
	$(INSTALL_DIR) $(1)/usr/share/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/share/webapps/
	#$(INSTALL_DIR) $(1)/etc/init.d
	rm -rf "$(1)/usr/share/hustoj/"
	rm -rf "$(1)/usr/share/webapps/hustoj/"
	$(CP) -r "$$(PKG_BUILD_DIR)/trunk/install/" "$(1)/usr/share/hustoj"
	cd $(PKG_BUILD_DIR)/trunk/core/ && make DESTDIR=$(1) install
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/judged/judged $(1)/usr/bin/
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/judge_client/judge_client $(1)/usr/bin/
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/sim_c.exe $(1)/usr/bin/sim_c
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/sim_java.exe $(1)/usr/bin/sim_java
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/sim_pasc.exe $(1)/usr/bin/sim_pasc
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/sim_text.exe $(1)/usr/bin/sim_text
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/sim_lisp.exe $(1)/usr/bin/sim_scm
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/trunk/core/sim/sim.sh $(1)/usr/bin/
	ln -sf sim_c $(1)/usr/bin/sim_cc
	$(INSTALL_BIN) ./files/sethustoj.sh $(1)/usr/share/hustoj/sethustoj.sh
	$(CP) -r "$$(PKG_BUILD_DIR)/trunk/web/" "$(1)/usr/share/webapps/hustoj"
	#chown http:http -R "$pkgdir/usr/share/webapps/hustoj"
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	chmod 755 $(PKG_BUILD_DIR)/trunk/core/autoclean.sh
	chmod 755 $(PKG_BUILD_DIR)/trunk/core/autogen.sh
	rm -f $(PKG_BUILD_DIR)/trunk/core/judge_client/makefile
	rm -f $(PKG_BUILD_DIR)/trunk/core/judged/makefile
	rm -f $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77/Makefile
	cd $(PKG_BUILD_DIR)/trunk/core/ && ./autogen.sh
	#cd $(PKG_BUILD_DIR)/trunk/core/judged && make
	#cd $(PKG_BUILD_DIR)/trunk/core/judge_client && make
	#cd $(PKG_BUILD_DIR)/trunk/core/sim/sim_2_77 && make fresh && make exes
endef

$(eval $(call BuildPackage,hustoj))

