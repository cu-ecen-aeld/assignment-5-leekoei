
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 5 git contents
AESD_ASSIGNMENTS_VERSION = cc7cf3c0aeb308a02510247bae6318dd001369b2
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = git@github.com:leekoei/aesd-assignment-leekoei.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/server all
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(LINUX_MAKE_FLAGS) -C $(@D)/aesd-char-driver KERNELDIR=$(LINUX_DIR) modules
endef

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(@D)/conf/ $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/assignment-autotest/test/assignment5-buildroot/* $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket  $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop $(TARGET_DIR)/etc/init.d/S99aesdsocket

	$(INSTALL) -D -m 0644 $(@D)/aesd-char-driver/aesdchar.ko  $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/aesdchar.ko
	if [ "$(LINUX_VERSION_PROBED)" != "$(LINUX_VERSION)" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aesd-char-driver/aesdchar.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/aesdchar.ko ; \
	fi
	if [ -n "$(BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE)" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aesd-char-driver/aesdchar.ko $(TARGET_DIR)/lib/modules/$(BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE)/aesdchar.ko ; \
	fi
	$(INSTALL) -m 0644 $(@D)/aesd-char-driver/aesdchar.ko  $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_load $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_unload $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
