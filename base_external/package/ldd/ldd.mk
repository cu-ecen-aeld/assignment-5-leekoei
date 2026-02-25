
##############################################################
#
# LDD
#
##############################################################

LDD_VERSION = f4cb4bb28f2f8de2e3d91f5b175e43392b16b4a5
LDD_SITE = git@github.com:leekoei/aesd-assignment-leekoei.git
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES

define LDD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(LINUX_MAKE_FLAGS) -C $(@D)/misc-modules KERNELDIR=$(LINUX_DIR) modules
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(LINUX_MAKE_FLAGS) -C $(@D)/scull KERNELDIR=$(LINUX_DIR) modules
endef

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
define LDD_INSTALL_TARGET_CMDS
	# Load the kernel modules
	$(INSTALL) -D -m 0644 $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/hello.ko
	if [ "$(LINUX_VERSION_PROBED)" != "$(LINUX_VERSION)" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/hello.ko ; \
	fi
	if [ -n "$(BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE)" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE)/hello.ko ; \
	fi
	$(INSTALL) -m 0644 $(@D)/misc-modules/faulty.ko $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0644 $(@D)/scull/scull.ko $(TARGET_DIR)/usr/bin

	# Load the helper scripts
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_load $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_unload $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/scull/scull_load $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/scull/scull_unload $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
