# -*- coding: utf-8 -*-
"""
Convertisseur CSV vers XML pour le projet PadChest
Transforme le fichier CSV en document XML structure
"""

import csv
import ast
import os

# Chemin du dossier racine du projet (remonte de 1 niveau)
RACINE_PROJET = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Chemins des fichiers
FICHIER_CSV = os.path.join(RACINE_PROJET, "data", "PADCHEST_chest_x_ray_images_labels_160K_01.02.19.csv")
FICHIER_XML = os.path.join(os.path.dirname(__file__), "padchest_images.xml")

NOMBRE_LIGNES_TEST = None  # Nombre de lignes a convertir (mettre None pour tout)

def nettoyer_liste(chaine):
    """
    Transforme une chaine "[...]" en liste Python
    Retourne une liste vide si le champ est vide
    """
    if not chaine or chaine.strip() == "[]":
        return []
    try:
        return ast.literal_eval(chaine)
    except:
        return []

def echapper_xml(texte):
    """
    Echappe les caracteres speciaux XML
    & devient &amp;
    < devient &lt;
    > devient &gt;
    " devient &quot;
    ' devient &apos;
    """
    if not texte:
        return ""
    texte = str(texte)
    texte = texte.replace("&", "&amp;")
    texte = texte.replace("<", "&lt;")
    texte = texte.replace(">", "&gt;")
    texte = texte.replace('"', "&quot;")
    texte = texte.replace("'", "&apos;")
    return texte

def generer_xml():
    """
    Fonction principale qui lit le CSV et genere le XML
    """
    print("Debut de la conversion CSV vers XML...")
    print(f"Fichier source : {FICHIER_CSV}")
    print(f"Fichier destination : {FICHIER_XML}")
    
    if NOMBRE_LIGNES_TEST:
        print(f"Mode TEST : conversion de {NOMBRE_LIGNES_TEST} lignes seulement")
    else:
        print("Mode COMPLET : conversion de toutes les lignes")
    
    print("-" * 70)
    
    # Ouverture du fichier CSV en lecture
    with open(FICHIER_CSV, 'r', encoding='utf-8') as csv_file:
        lecteur = csv.DictReader(csv_file) # Lecture du CSV en dictionnaire grâce a la class DictReader
        
        # Ouverture du fichier XML en ecriture
        with open(FICHIER_XML, 'w', encoding='utf-8') as xml_file:
            # Ecriture de l'en-tete XML
            xml_file.write('<?xml version="1.0" encoding="UTF-8"?>\n')
            #xml_file.write('<!DOCTYPE padchest_database SYSTEM "../Etape2_Structure/Minimum/padchest_images.dtd">\n')            
            xml_file.write('<padchest_database>\n')
            
            compteur = 0
            
            # Pour chaque ligne du CSV
            for ligne in lecteur:
                compteur += 1
                
                # Affichage de la progression tous les 1000 lignes
                if compteur % 1000 == 0:
                    print(f"  Traitement de l'image {compteur}...")
                
                # Extraction et nettoyage des donnees
                image_id = echapper_xml(ligne['ImageID'])
                study_id = echapper_xml(ligne['StudyID'])
                patient_id = echapper_xml(ligne['PatientID'])
                birth_year = echapper_xml(ligne['PatientBirth'])
                projection_type = echapper_xml(ligne['Projection'])
                method_projection = echapper_xml(ligne['MethodProjection'])
                pediatric = echapper_xml(ligne['Pediatric'])
                report_id = echapper_xml(ligne['ReportID'])
                report_text = echapper_xml(ligne['Report'])
                method_label = echapper_xml(ligne['MethodLabel'])
                
                # Nettoyage des listes
                labels = nettoyer_liste(ligne['Labels'])
                localizations = nettoyer_liste(ligne['Localizations'])
                labels_by_sentence = nettoyer_liste(ligne['LabelsLocalizationsBySentence'])
                
                # Ecriture de l'element image
                xml_file.write(f'  <image id="{image_id}">\n')
                xml_file.write(f'    <study_id>{study_id}</study_id>\n')
                
                # Element patient avec attribut id
                xml_file.write(f'    <patient id="{patient_id}">\n')
                xml_file.write(f'      <birth_year>{birth_year}</birth_year>\n')
                xml_file.write(f'    </patient>\n')
                
                # Element projection avec attribut type
                xml_file.write(f'    <projection type="{projection_type}">\n')
                xml_file.write(f'      <method>{method_projection}</method>\n')
                xml_file.write(f'      <pediatric>{pediatric}</pediatric>\n')
                xml_file.write(f'    </projection>\n')
                
                # Element report avec attributs id et method
                xml_file.write(f'    <report id="{report_id}" method="{method_label}">\n')
                xml_file.write(f'      <text>{report_text}</text>\n')
                xml_file.write(f'    </report>\n')
                
                # Element labels
                xml_file.write(f'    <labels>\n')
                if labels:
                    for label in labels:
                        label_escape = echapper_xml(label)
                        xml_file.write(f'      <label>{label_escape}</label>\n')
                xml_file.write(f'    </labels>\n')
                
                # Element localizations
                xml_file.write(f'    <localizations>\n')
                if localizations:
                    for loc in localizations:
                        loc_escape = echapper_xml(loc)
                        xml_file.write(f'      <localization>{loc_escape}</localization>\n')
                xml_file.write(f'    </localizations>\n')
                
                # Element labels_by_sentence (tableau de tableaux)
                xml_file.write(f'    <labels_by_sentence>\n')
                if labels_by_sentence:
                    for sentence in labels_by_sentence:
                        xml_file.write(f'      <sentence>\n')
                        if isinstance(sentence, list):
                            for item in sentence:
                                item_escape = echapper_xml(item)
                                xml_file.write(f'        <item>{item_escape}</item>\n')
                        xml_file.write(f'      </sentence>\n')
                xml_file.write(f'    </labels_by_sentence>\n')
                
                # Fermeture de l'element image
                xml_file.write(f'  </image>\n')
                
                # Arret si on a atteint le nombre de lignes test
                if NOMBRE_LIGNES_TEST and compteur >= NOMBRE_LIGNES_TEST:
                    break
            
            # Fermeture de l'element racine
            xml_file.write('</padchest_database>\n')
    
    print("-" * 70)
    print(f"Conversion terminee !")
    print(f"Nombre d'images converties : {compteur}")
    print(f"Fichier XML cree : {FICHIER_XML}")

# Point d'entree du programme
if __name__ == "__main__":
    generer_xml()