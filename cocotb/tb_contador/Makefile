# ==============================================================================
# Makefile para el Chipathon - Acelerador de Convolución (50 MHz)
# ==============================================================================

# Simulador por defecto y lenguaje
SIM ?= icarus
#SIM ?= cvc

TOPLEVEL_LANG ?= verilog

TOP_PROJECT=contador

# ------------------------------------------------------------------------------
# Forzar recompilación de la simulación una sola vez por comando `make`.
# Cocotb invoca un segundo make internamente; MAKELEVEL evita borrar allí.
# ------------------------------------------------------------------------------
ifeq ($(MAKELEVEL),0)
$(info Eliminando sim_build anterior...)
$(shell rm -rf $(PWD)/sim_build/)
endif


# Dirección de tus archivos fuentes lógicos
SRC_DIR = $(PWD)/../../src/$(TOP_PROJECT)

# Lista completa de tus 10 archivos de diseño (sin el timescale/tb)
PROJECT_SOURCES = contador.v 

# ------------------------------------------------------------------------------
# Configuración SDF (solo se usa con GATES=yes TIMING=yes)
# ------------------------------------------------------------------------------
BUILD_DIR  = $(PWD)/../../librelane/build/$(TOP_PROJECT)
SDF_CORNER ?= nom_tt_025C_3v30
#Compatibles:
#para 3v3:
#max_ff_n40C_3v60  min_ff_n40C_3v60  nom_ff_n40C_3v60
#max_ss_125C_3v00  min_ss_125C_3v00  nom_ss_125C_3v00
#max_tt_025C_3v30  min_tt_025C_3v30  nom_tt_025C_3v30



SDF_FILE   ?= $(BUILD_DIR)/sdf/$(SDF_CORNER)/$(TOP_PROJECT)__$(SDF_CORNER).sdf



ifneq ($(GATES),yes)

# ------------------------------------------------------------------------------
# Configuración para Simulación RTL (Pre-Síntesis)
# ------------------------------------------------------------------------------
SIM_BUILD        = $(PWD)
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
VERILOG_SOURCES += $(PWD)/tb.v
else

# ------------------------------------------------------------------------------
# Configuración para Simulación Gate-Level (GL / Post-Síntesis)
# ------------------------------------------------------------------------------
SIM_BUILD        = sim_build/gl

# ------------------------------------------------------------------------------
# Defines compatibles con el simulador seleccionado
# ------------------------------------------------------------------------------
ifeq ($(SIM),cvc)
COMPILE_ARGS    += +define+GL_TEST
COMPILE_ARGS    += +define+USE_POWER_PINS
COMPILE_ARGS    += +define+SIM
else
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
endif

# Si TIMING=yes, usar el SDF generado por LibreLane.
# Si TIMING no está habilitado, conservar la simulación GL funcional original.
ifeq ($(TIMING),yes)

ifeq ($(SIM),cvc)
COMPILE_ARGS    += +define+TIMING
COMPILE_ARGS    += +define+SDF_FILE=\"$(SDF_FILE)\"
else
COMPILE_ARGS    += -DTIMING
COMPILE_ARGS    += -DSDF_FILE=\"$(SDF_FILE)\"
COMPILE_ARGS    += -gspecify
COMPILE_ARGS    += -ginterconnect
endif

$(info SDF_CORNER = $(SDF_CORNER))
$(info SDF_FILE = $(SDF_FILE))

else

ifeq ($(SIM),cvc)
COMPILE_ARGS    += +define+FUNCTIONAL
COMPILE_ARGS    += +define+UNIT_DELAY=\#1
else
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUNIT_DELAY=\#1
endif

endif

# Modelos del PDK correspondientes a tu entorno de la fundición
VERILOG_SOURCES += $(PWD)/../../gf180mcu/gf180mcuD/libs.ref/gf180mcu_as_sc_mcu7t3v3/verilog/gf180mcu_as_sc_mcu7t3v3.v


# Netlist sintetizado final del proyecto
VERILOG_SOURCES += $(PWD)/../../librelane/build/$(TOP_PROJECT)/pnl/$(TOP_PROJECT).pnl.v
VERILOG_SOURCES += $(PWD)/tb_gls.v
endif

# Permitir compartir configuraciones vía `include` si es necesario
ifeq ($(SIM),cvc)
COMPILE_ARGS    += +incdir+$(SRC_DIR)
else
COMPILE_ARGS    += -I$(SRC_DIR)
endif

# Incluir el archivo de testbench puente (el que tiene el dumper de ondas)

TOPLEVEL = tb

# Nombre de tu archivo de python (test_con32_cocotb.py sin el .py)
MODULE = test

# Incluye las reglas oficiales de cocotb para configurar el simulador
include $(shell cocotb-config --makefiles)/Makefile.sim
