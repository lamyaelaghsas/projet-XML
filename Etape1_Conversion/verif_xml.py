# -*- coding: utf-8 -*-
"""
Script de verification du fichier XML genere
Compte le nombre d'images et verifie la structure
"""

FICHIER_XML = "padchest_images.xml"

print("Verification du fichier XML...")
print("=" * 70)

# Compteur d'images
nb_images = 0

# Lecture ligne par ligne (plus rapide que parser tout le XML)
with open(FICHIER_XML, 'r', encoding='utf-8') as f:
    for ligne in f:
        if '<image id=' in ligne:
            nb_images += 1

print(f"Nombre d'images trouvees : {nb_images}")
print("=" * 70)

# Verification de la structure
print("\nVerification de la structure...")

with open(FICHIER_XML, 'r', encoding='utf-8') as f:
    contenu = f.read()
    
    # Verifications basiques
    if contenu.startswith('<?xml version="1.0" encoding="UTF-8"?>'):
        print("  Declaration XML : OK")
    else:
        print("  Declaration XML : ERREUR")
    
    if '<padchest_database>' in contenu:
        print("  Balise racine ouvrante : OK")
    else:
        print("  Balise racine ouvrante : ERREUR")
    
    if contenu.strip().endswith('</padchest_database>'):
        print("  Balise racine fermante : OK")
    else:
        print("  Balise racine fermante : ERREUR")

print("\n" + "=" * 70)
print("Verification terminee !")
print(f"\nFichier : {FICHIER_XML}")
print(f"Taille : {len(contenu) / (1024*1024):.2f} Mo")
print(f"Nombre d'images : {nb_images}")