import numpy as np 
from skimage import io
from skimage.transform import resize
import os

def generar_multiples_npy(ruta_imagen="./prueba.jpg", escala=(2**7-1)):
    # Verificamos si la imagen existe
    
    image_original = io.imread(ruta_imagen)
        
    print(f"✅ Imagen cargada correctamente. Dimensiones originales: {image_original.shape}")
    print("Iniciando conversión y guardado...")

    # Lista de tamaños que queremos generar (desde 8x8 hasta 16x16)
    tamaños_deseados = range(5, 16) 
    
    for size in tamaños_deseados:
        # Aplicamos la misma transformación de tu código original:
        # 1. Resize a la nueva dimensión (size, size)
        # 2. Multiplicamos por la escala
        # 3. Convertimos a entero de 32 bits sin signo (uint32)
        # 4. Extraemos solo el primer canal [:,:,0]
        img_resized = np.array(resize(image_original, (size, size)) * escala, dtype=np.uint32)[:, :, 0]
        
        # Generamos el nombre del archivo dinámicamente
        nombre_archivo = f"imagen_{size}x{size}.npy"
        
        # Guardamos la matriz en un archivo .npy
        np.save(nombre_archivo, img_resized)
        
        print(f" 💾 Guardado: {nombre_archivo} | Shape resultante: {img_resized.shape}")

if __name__ == '__main__':
    # Ejecutamos la función
    generar_multiples_npy()