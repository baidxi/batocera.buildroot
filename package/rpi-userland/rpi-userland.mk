################################################################################
#
# rpi-userland
#
################################################################################
# batocera (update) - Commits on Mar 22, 2023
RPI_USERLAND_VERSION = 9d5250fd98679e09c4c1a44883f9312a21f1ac6d
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3-Clause
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPTS = -DVMCS_INSTALL_PREFIX=/usr

ifeq ($(BR2_arm),y)
RPI_USERLAND_PROVIDES = libegl libgles libopenmax libopenvg
endif

ifeq ($(BR2_PACKAGE_LIBEXECINFO),y)
RPI_USERLAND_DEPENDENCIES += libexecinfo
endif

ifeq ($(BR2_aarch64),y)
RPI_USERLAND_CONF_OPTS += -DARM64=ON
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND_HELLO),y)

RPI_USERLAND_CONF_OPTS += -DALL_APPS=ON

define RPI_USERLAND_EXTRA_LIBS_TARGET
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(TARGET_DIR)/usr/lib/libilclient.so
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/librevision.so \
		$(TARGET_DIR)/usr/lib/librevision.so
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_EXTRA_LIBS_TARGET

define RPI_USERLAND_EXTRA_LIBS_STAGING
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(STAGING_DIR)/usr/lib/libilclient.so
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/librevision.so \
		$(STAGING_DIR)/usr/lib/librevision.so
endef
RPI_USERLAND_POST_INSTALL_STAGING_HOOKS += RPI_USERLAND_EXTRA_LIBS_STAGING

else

RPI_USERLAND_CONF_OPTS += -DALL_APPS=OFF

endif # BR2_PACKAGE_RPI_USERLAND_HELLO

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -Rf $(TARGET_DIR)/usr/src
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
