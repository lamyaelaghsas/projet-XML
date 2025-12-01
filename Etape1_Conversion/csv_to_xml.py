# -*- coding: utf-8 -*-
"""
Convertisseur CSV vers XML pour le projet PadChest
Peut générer deux versions : une avec DTD, une avec XSD
"""

import csv
import ast
import os

# ============================================================
# CONFIGURATION DES CHEMINS
# ============================================================

RACINE_PROJET = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FICHIER_CSV = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "PADCHEST_chest_x_ray_images_labels_160K_01.02.19.csv")

# Fichiers de sortie
FICHIER_XML_DTD = os.path.join(os.path.dirname(__file__), "padchest_images_dtd.xml")
FICHIER_XML_XSD = os.path.join(os.path.dirname(__file__), "padchest_images_xsd.xml")

# Mode test
NOMBRE_LIGNES_TEST = None

# ============================================================
# FONCTIONS
# ============================================================

# Nettoie une chaîne représentant une liste
def nettoyer_liste(chaine):
    if not chaine or chaine.strip() == "[]":
        return []
    try:
        return ast.literal_eval(chaine)
    except:
        return []

# Échappe les caractères spéciaux pour XML
def echapper_xml(texte):
    if not texte:
        return ""
    texte = str(texte)
    texte = texte.replace("&", "&amp;")
    texte = texte.replace("<", "&lt;")
    texte = texte.replace(">", "&gt;")
    texte = texte.replace('"', "&quot;")
    texte = texte.replace("'", "&apos;")
    return texte

# Écrit une image dans le fichier XML
def ecrire_image(xml_file, ligne):
    """
    Écrit une image dans le fichier XML
    Fonction commune pour les deux versions
    """
    # Extraction et nettoyage des données
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
    
    # Écriture de l'élément image
    xml_file.write(f'  <image id="{image_id}">\n')
    xml_file.write(f'    <study_id>{study_id}</study_id>\n')
    xml_file.write(f'    <patient_id>{patient_id}</patient_id>\n')
    xml_file.write(f'    <birth_year>{birth_year}</birth_year>\n')
    xml_file.write(f'    <projection>{projection_type}</projection>\n')
    xml_file.write(f'    <method_projection>{method_projection}</method_projection>\n')
    xml_file.write(f'    <pediatric>{pediatric}</pediatric>\n')
    xml_file.write(f'    <report_id>{report_id}</report_id>\n')
    xml_file.write(f'    <report>{report_text}</report>\n')
    xml_file.write(f'    <method_label>{method_label}</method_label>\n')
    
    # Labels
    xml_file.write(f'    <labels>\n')
    if labels:
        for label in labels:
            label_escape = echapper_xml(label)
            xml_file.write(f'      <label>{label_escape}</label>\n')
    xml_file.write(f'    </labels>\n')
    
    # Localizations
    xml_file.write(f'    <localizations>\n')
    if localizations:
        for loc in localizations:
            loc_escape = echapper_xml(loc)
            xml_file.write(f'      <localization>{loc_escape}</localization>\n')
    xml_file.write(f'    </localizations>\n')
    
    # Labels by sentence
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
    
    xml_file.write(f'  </image>\n')

# Création de padchest_images_dtd.xml
def generer_xml_avec_dtd():
    """
    Génère le XML avec référence au DTD (version minimum)
    """
    print("=" * 70)
    print("GENERATION XML AVEC DTD (Minimum)")
    print("=" * 70)
    print(f"Fichier de sortie : {FICHIER_XML_DTD}")
    print()
    
    if not os.path.exists(FICHIER_CSV):
        print("ERREUR : Fichier CSV introuvable !")
        return
    
    with open(FICHIER_CSV, 'r', encoding='utf-8') as csv_file:
        lecteur = csv.DictReader(csv_file)
        
        with open(FICHIER_XML_DTD, 'w', encoding='utf-8') as xml_file:
            # En-tête avec référence DTD
            xml_file.write('<?xml version="1.0" encoding="UTF-8"?>\n')
            xml_file.write('<!DOCTYPE padchest_database SYSTEM "../Etape2_Structure/Minimum/padchest_images.dtd">\n')
            xml_file.write('<padchest_database>\n')
            
            compteur = 0
            for ligne in lecteur:
                compteur += 1
                if compteur % 1000 == 0:
                    print(f"  Traitement image {compteur}...")
                
                ecrire_image(xml_file, ligne)
                
                if NOMBRE_LIGNES_TEST and compteur >= NOMBRE_LIGNES_TEST:
                    break
            
            xml_file.write('</padchest_database>\n')
    
    print(f"✓ XML avec DTD créé : {compteur} images")
    print()

# Création de padchest_images_xsd.xml
def generer_xml_avec_xsd():
    """
    Génère le XML avec référence au XSD (version pro)
    """
    print("=" * 70)
    print("GENERATION XML AVEC XSD (Pour les pros)")
    print("=" * 70)
    print(f"Fichier de sortie : {FICHIER_XML_XSD}")
    print()
    
    if not os.path.exists(FICHIER_CSV):
        print("ERREUR : Fichier CSV introuvable !")
        return
    
    with open(FICHIER_CSV, 'r', encoding='utf-8') as csv_file:
        lecteur = csv.DictReader(csv_file)
        
        with open(FICHIER_XML_XSD, 'w', encoding='utf-8') as xml_file:
            # En-tête avec référence XSD
            xml_file.write('<?xml version="1.0" encoding="UTF-8"?>\n')
            xml_file.write('<padchest_database\n')
            xml_file.write('    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n')
            xml_file.write('    xsi:noNamespaceSchemaLocation="../Etape2_Structure/Pro/padchest_images_inline.xsd">\n')
            
            compteur = 0
            for ligne in lecteur:
                compteur += 1
                if compteur % 1000 == 0:
                    print(f"  Traitement image {compteur}...")
                
                ecrire_image(xml_file, ligne)
                
                if NOMBRE_LIGNES_TEST and compteur >= NOMBRE_LIGNES_TEST:
                    break
            
            xml_file.write('</padchest_database>\n')
    
    print(f"✓ XML avec XSD créé : {compteur} images")
    print()

# ============================================================
# POINT D'ENTRÉE
# ============================================================

if __name__ == "__main__":
    print()
    print("CONVERTISSEUR CSV → XML (PadChest)")
    print()
    
    if NOMBRE_LIGNES_TEST:
        print(f"⚠ Mode TEST : {NOMBRE_LIGNES_TEST} lignes")
    else:
        print("Mode COMPLET")
    
    print()
    
    # Génération des deux versions
    generer_xml_avec_dtd()
    generer_xml_avec_xsd()
    
    print("=" * 70)
    print("✓ Conversion terminée !")
    print()
    print("Fichiers créés :")
    print(f"  - {FICHIER_XML_DTD} (avec DTD)")
    print(f"  - {FICHIER_XML_XSD} (avec XSD)")
    print("=" * 70)