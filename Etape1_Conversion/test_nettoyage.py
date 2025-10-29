# -*- coding: utf-8 -*-
"""
Script pour nettoyer les données CSV avant conversion XML
On transforme les chaines "[...]" en vraies listes Python
"""

import csv
import ast  # Pour transformer les chaines en listes

fichier_csv = "PADCHEST_chest_x_ray_images_labels_160K_01.02.19.csv"

def nettoyer_liste(chaine):
    """
    Transforme une chaine comme "['val1', 'val2']" en liste Python ['val1', 'val2']
    Si la chaine est vide ou [], retourne une liste vide []
    """
    # Si le champ est vide ou contient juste []
    if not chaine or chaine.strip() == "[]":
        return []
    
    try:
        # ast.literal_eval transforme la chaine en objet Python
        # C'est plus sur que eval() car ca n'execute pas de code
        resultat = ast.literal_eval(chaine)
        return resultat
    except:
        # Si ca ne marche pas, on retourne une liste vide
        return []

print("Lecture et nettoyage du fichier CSV...")
print("=" * 70)

with open(fichier_csv, 'r', encoding='utf-8') as f:
    lecteur = csv.DictReader(f)
    compteur = 0
    
    for ligne in lecteur:
        compteur += 1
        
        # On nettoie les champs qui contiennent des listes
        labels_propres = nettoyer_liste(ligne['Labels'])
        localizations_propres = nettoyer_liste(ligne['Localizations'])
        labels_loc_propres = nettoyer_liste(ligne['LabelsLocalizationsBySentence'])
        
        print(f"\nIMAGE {compteur}")
        print("-" * 70)
        print(f"  ImageID    : {ligne['ImageID']}")
        print(f"  Projection : {ligne['Projection']}")
        
        # Affichage des labels (liste Python maintenant)
        print(f"\n  Labels nettoyes (type: {type(labels_propres).__name__}) :")
        if labels_propres:
            for label in labels_propres:
                print(f"    - {label}")
        else:
            print("    (vide)")
        
        # Affichage des localisations
        print(f"\n  Localizations nettoyees (type: {type(localizations_propres).__name__}) :")
        if localizations_propres:
            for loc in localizations_propres:
                print(f"    - {loc}")
        else:
            print("    (vide)")
        
        # Affichage du champ complexe (tableau de tableaux)
        print(f"\n  LabelsLocalizationsBySentence (type: {type(labels_loc_propres).__name__}) :")
        if labels_loc_propres:
            for i, sous_liste in enumerate(labels_loc_propres):
                print(f"    Phrase {i+1}: {sous_liste}")
        else:
            print("    (vide)")
        
        if compteur >= 3:
            break

print("\n" + "=" * 70)
print(f"Nettoyage termine ! {compteur} images traitees.")
print("\nConclusion :")
print("  - Les chaines ont ete transformees en vraies listes Python")
print("  - On peut maintenant facilement creer le XML")
print("  - LabelsLocalizationsBySentence est une liste de listes")