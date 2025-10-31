# -*- coding: utf-8 -*-
"""
Script de test pour valider le XML avec DTD et XSD
"""

import xml.etree.ElementTree as ET
from lxml import etree
import os

# Chemins
RACINE = os.path.dirname(os.path.abspath(__file__))
XML_DTD = os.path.join(RACINE, "..", "Etape1_Conversion", "padchest_images_dtd.xml")
XML_XSD = os.path.join(RACINE, "..", "Etape1_Conversion", "padchest_images_xsd.xml")
DTD_FILE = os.path.join(RACINE, "Minimum", "padchest_images.dtd")
XSD_FILE = os.path.join(RACINE, "Pro", "padchest_images_inline.xsd")

print("=" * 70)
print("TEST DE VALIDATION - ÉTAPE 2")
print("=" * 70)
print()

# ============================================================
# TEST 1 : Vérifier que le XML est bien formé
# ============================================================

print("TEST 1 : XML bien formé (well-formed)")
print("-" * 70)

try:
    tree = ET.parse(XML_DTD)
    print("padchest_images_dtd.xml est bien formé")
except ET.ParseError as e:
    print(f"Erreur : {e}")

try:
    tree = ET.parse(XML_XSD)
    print("padchest_images_xsd.xml est bien formé")
except ET.ParseError as e:
    print(f"Erreur : {e}")

print()

# ============================================================
# TEST 2 : Validation avec DTD (nécessite lxml)
# ============================================================

print("TEST 2 : Validation avec DTD")
print("-" * 70)

try:
    # Charger le DTD
    with open(DTD_FILE, 'r', encoding='utf-8') as f:
        dtd = etree.DTD(f)
    
    # Parser le XML
    doc = etree.parse(XML_DTD)
    
    # Valider
    if dtd.validate(doc):
        print(" XML valide selon le DTD !")
    else:
        print(" XML invalide selon le DTD")
        print("Erreurs :")
        for error in dtd.error_log:
            print(f"  - Ligne {error.line}: {error.message}")
            
except FileNotFoundError:
    print(" Fichier DTD ou XML introuvable")
    print("   Assure-toi d'avoir exécuté csv_to_xml.py d'abord")
except Exception as e:
    print(f" Erreur : {e}")

print()

# ============================================================
# TEST 3 : Validation avec XSD (nécessite lxml)
# ============================================================

print("TEST 3 : Validation avec XSD")
print("-" * 70)

try:
    # Charger le XSD
    with open(XSD_FILE, 'r', encoding='utf-8') as f:
        schema_doc = etree.parse(f)
        schema = etree.XMLSchema(schema_doc)
    
    # Parser le XML
    doc = etree.parse(XML_XSD)
    
    # Valider
    if schema.validate(doc):
        print(" XML valide selon le XSD !")
    else:
        print(" XML invalide selon le XSD")
        print("Erreurs :")
        for error in schema.error_log:
            print(f"  - Ligne {error.line}: {error.message}")
            
except FileNotFoundError:
    print(" Fichier XSD ou XML introuvable")
    print("   Assure-toi d'avoir exécuté csv_to_xml.py d'abord")
except Exception as e:
    print(f" Erreur : {e}")

print()
print("=" * 70)
print("Tests terminés !")
print("=" * 70)