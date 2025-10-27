# -*- coding: utf-8 -*-
"""
Script de test pour lire le fichier CSV PadChest
Ce script lit les 5 premières lignes et affiche les informations importantes
"""

import csv
import os

# Chemin vers le fichier CSV (adapté à la nouvelle structure)
RACINE_PROJET = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
fichier_csv = os.path.join(RACINE_PROJET, "data", "PADCHEST_chest_x_ray_images_labels_160K_01.02.19.csv")

print("Lecture du fichier CSV PadChest...")
print("=" * 60)
print(f"Fichier : {fichier_csv}")
print()

# Vérification que le fichier existe
if not os.path.exists(fichier_csv):
    print("ERREUR : Le fichier CSV n'existe pas !")
    print(f"Chemin recherché : {fichier_csv}")
    exit(1)

# On ouvre le fichier en mode lecture
# encoding='utf-8' permet de lire les accents correctement
with open(fichier_csv, 'r', encoding='utf-8') as f:
    # csv.DictReader lit le CSV et transforme chaque ligne en dictionnaire
    # Cela signifie qu'on peut accéder aux colonnes par leur nom !
    lecteur = csv.DictReader(f)
    
    # Compteur pour limiter l'affichage aux 5 premières lignes
    compteur = 0
    
    # Pour chaque ligne du CSV...
    for ligne in lecteur:
        compteur += 1
        
        # On affiche les informations importantes
        print(f"\n IMAGE {compteur}")
        print("-" * 60)
        print(f"  ImageID       : {ligne['ImageID']}")
        print(f"  PatientID     : {ligne['PatientID']}")
        print(f"  PatientBirth  : {ligne['PatientBirth']}")
        print(f"  Projection    : {ligne['Projection']}")
        print(f"  Pediatric     : {ligne['Pediatric']}")
        print(f"  Labels        : {ligne['Labels']}")
        print(f"  Localizations : {ligne['Localizations']}")
        
        # On s'arrête après 5 images
        if compteur >= 5:
            break

print("\n" + "=" * 60)
print(f"Lecture terminée ! {compteur} images affichées.")
print("\nObservations :")
print("  - Les Labels sont entre guillemets et crochets")
print("  - Certains champs peuvent être vides")
print("  - On devra 'nettoyer' ces données pour le XML")