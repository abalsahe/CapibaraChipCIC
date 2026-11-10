#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: Debes indicar el archivo GDS."
  echo "Uso: ./open_gds_2.sh ruta/a/tu_diseno.gds"
  exit 1
fi

PDK_ROOT_GDS="gf180mcu"
PDK_GDS="gf180mcuD"
KLAYOUT_PATH="./$PDK_ROOT_GDS/$PDK_GDS/libs.tech/klayout"

# Abre KLayout mostrando el GDS con su tecnología y colores, sin ejecutar nada extra
klayout -nn "$KLAYOUT_PATH/tech/gf180mcu.lyt" \
        -l "./gf180mcu_PK.lyp" \
        "$1" &
