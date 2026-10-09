PRODUCT_VERSION_MAJOR = 24
PRODUCT_VERSION_MINOR = 0

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Set LINEAGE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef LINEAGE_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "LINEAGE_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LINEAGE_||g')
        LINEAGE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LINEAGE_BUILDTYPE)),)
    LINEAGE_BUILDTYPE := UNOFFICIAL
    LINEAGE_EXTRAVERSION :=
endif

ifeq ($(LINEAGE_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LINEAGE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)$(LINEAGE_EXTRAVERSION)-$(LINEAGE_BUILD)

# Internal version
LINEAGE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# Display version
LINEAGE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(LINEAGE_VERSION_SUFFIX)

# LineageOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.lineage.releasetype=$(LINEAGE_BUILDTYPE)

# Project-CarpeDiem platform version
CARPEDIEM_VERSION_MAJOR := 1
CARPEDIEM_VERSION_MINOR := 0
CARPEDIEM_VERSION_CODENAME := Initium

# Device maintainer (override per-device after inherit, or via env)
CARPEDIEM_MAINTAINER ?= Unknown

# Build type: official vs unofficial (default unofficial)
# Lazy so device-mk/env/CLI assignments landing after inherit still apply
CARPEDIEM_OFFICIAL ?= false
CARPEDIEM_BUILDTYPE ?= $(if $(filter true,$(CARPEDIEM_OFFICIAL)),OFFICIAL,UNOFFICIAL)
CARPEDIEM_VERSION_SUFFIX = $(LINEAGE_BUILD_DATE)-$(CARPEDIEM_BUILDTYPE)$(LINEAGE_EXTRAVERSION)-$(LINEAGE_BUILD)

# Package type, tracks WITH_GMS (lazy so common.mk defaults apply)
CARPEDIEM_PACKAGE_TYPE ?= $(if $(filter true,$(WITH_GMS)),GMS,VANILLA)

# Project-CarpeDiem branding (parallel, non-breaking - LINEAGE_* vars kept for compat)
CARPEDIEM_VERSION = CarpeDiem-$(CARPEDIEM_VERSION_MAJOR).$(CARPEDIEM_VERSION_MINOR)-$(CARPEDIEM_VERSION_CODENAME)-$(CARPEDIEM_PACKAGE_TYPE)-$(CARPEDIEM_VERSION_SUFFIX)
CARPEDIEM_DISPLAY_VERSION := CarpeDiem-$(CARPEDIEM_VERSION_MAJOR).$(CARPEDIEM_VERSION_MINOR)-$(CARPEDIEM_VERSION_CODENAME)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.carpediem.version=$(CARPEDIEM_VERSION) \
    ro.carpediem.display.version=$(CARPEDIEM_DISPLAY_VERSION) \
    ro.carpediem.build.version=$(CARPEDIEM_VERSION_MAJOR).$(CARPEDIEM_VERSION_MINOR) \
    ro.carpediem.codename=$(CARPEDIEM_VERSION_CODENAME) \
    ro.carpediem.maintainer=$(CARPEDIEM_MAINTAINER) \
    ro.carpediem.packagetype=$(CARPEDIEM_PACKAGE_TYPE) \
    ro.carpediem.releasetype=$(CARPEDIEM_BUILDTYPE) \
    ro.modversion=$(CARPEDIEM_VERSION)
