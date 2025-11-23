# 🎯 ÉTAPE 5 - Niveau MINIMUM

## ✅ Ce que contient ce dossier

- `requete1_loc_right.xq` - Compte les images avec "loc right"
- `requete2_top10_labels.xq` - Top 10 des labels les plus fréquents
- `README_MINIMUM.md` - Ce fichier

---

## 📦 PRÉREQUIS : Installer BaseX

### Étape 1 : Télécharger BaseX

Va sur : https://basex.org/download/

Télécharge **BaseX 10.x** (version Windows)

### Étape 2 : Installer

1. Extrais le ZIP dans `C:\BaseX\`
2. Double-clique sur `BaseX.exe`
3. Tu verras l'interface graphique BaseX

---

## 🚀 UTILISATION

### Étape 1 : Créer la base de données

Dans BaseX :

1. Menu **Database** → **New**
2. **Name** : `padchest`
3. **Input file** : Sélectionne ton `padchest_images_dtd.xml`
4. Clique sur **OK**

⏳ Attends quelques secondes (BaseX va importer les 160K images)

---

### Étape 2 : Exécuter la Requête 1

1. Ouvre `requete1_loc_right.xq` dans BaseX
   - Menu **File** → **Open**
2. Clique sur **▶ Execute** (ou F5)
3. Tu verras le résultat en bas :
```
======================================
RÉSULTAT REQUÊTE 1
======================================
Nombre d'images avec 'loc right' : XXXX
======================================
```

---

### Étape 3 : Exécuter la Requête 2

1. Ouvre `requete2_top10_labels.xq` dans BaseX
2. Clique sur **▶ Execute**
3. Tu verras :
```
======================================
RÉSULTAT REQUÊTE 2 - TOP 10 LABELS
======================================
1. normal : 45000 occurrences
2. pneumonia : 12000 occurrences
3. ...
======================================
```

---

## 📊 EXPLICATIONS DES REQUÊTES

### Requête 1 : Comment ça marche ?
```xquery
count(
  //image[localizations/localization[contains(., 'loc right')]]
)
```

**Traduction** :
- `//image` = Toutes les images
- `[localizations/localization[...]]` = Qui ont des localisations
- `contains(., 'loc right')` = Contenant "loc right"
- `count(...)` = Compter le tout

💡 **Analogie** : C'est comme faire un `SELECT COUNT(*) WHERE localisation LIKE '%loc right%'` en SQL

---

### Requête 2 : Comment ça marche ?
```xquery
for $label in distinct-values($tous_les_labels)
let $count := count($tous_les_labels[. = $label])
order by $count descending
```

**Traduction** :
1. `distinct-values()` = Liste des labels uniques
2. `count($tous_les_labels[. = $label])` = Compter chaque label
3. `order by $count descending` = Trier par ordre décroissant
4. `subsequence(..., 1, 10)` = Prendre les 10 premiers

💡 **Analogie** : C'est comme un `GROUP BY label ORDER BY count DESC LIMIT 10` en SQL

---

## ✅ CHECKLIST AVANT PRÉSENTATION

- [ ] BaseX installé
- [ ] Base de données `padchest` créée
- [ ] Requête 1 fonctionne (affiche un nombre)
- [ ] Requête 2 fonctionne (affiche top 10)
- [ ] Screenshots des résultats pris

---

## 🎓 POUR L'ORAL

**Question** : "Expliquez XQuery"

**Réponse** :
> "XQuery est un langage de requête pour XML, comme SQL pour les bases relationnelles. 
> Il permet de rechercher, filtrer et transformer des données XML."

**Question** : "Différence avec XSLT ?"

**Réponse** :
> "XSLT transforme XML en HTML pour l'affichage, 
> XQuery interroge XML pour extraire des données."

---

Bon courage ! 🚀