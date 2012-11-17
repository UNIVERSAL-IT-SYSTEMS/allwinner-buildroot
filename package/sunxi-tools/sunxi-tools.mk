

SUNXI_TOOLS_DIR := $(BUILD_DIR)/sunxi-tools

$(SUNXI_TOOLS_DIR)/.source : 
	mkdir -pv $(SUNXI_TOOLS_DIR)
	cp -rf package/sunxi-tools/sunxi-tools/* $(SUNXI_TOOLS_DIR)
	touch $@

$(SUNXI_TOOLS_DIR)/.configured : $(SUNXI_TOOLS_DIR)/.source
	touch $@


sunxi-tools-binary: $(SUNXI_TOOLS_DIR)/.configured
	echo $(TARGET_CC)
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(SUNXI_TOOLS_DIR) clean
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(SUNXI_TOOLS_DIR) all


sunxi-tools: sunxi-tools-binary
	$(MAKE) DESTDIR="$(TARGET_DIR)" HOSTDIR="$(HOST_DIR)" -C $(SUNXI_TOOLS_DIR) install


##############################################################
#
# Add our target
#
#############################################################
ifeq ($(BR2_PACKAGE_SUNXI_TOOLS),y)
TARGETS += sunxi-tools
endif
