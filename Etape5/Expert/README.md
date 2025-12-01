# ⭐⭐⭐ ÉTAPE 5 - Niveau EXPERT

## 🎯 Objectif

Ajouter un **bouton dans ta page XSLT** qui appelle le webservice BaseX et affiche les statistiques dans une popup !

---

## ✅ Ce que contient ce dossier

- `requete1_loc_right.xq` - Requête XQuery 1
- `requete2_top10_labels.xq` - Requête XQuery 2
- `webservice.xqm` - Webservice REST
- `padchest_expert_avec_webservice.xsl` - **XSLT avec bouton BaseX**
- `README_EXPERT.md` - Ce fichier

---

## 🚀 INSTALLATION (5 minutes)

### ✅ Prérequis

Tu dois avoir fait **Minimum** et **Pro** avant :
- ✅ BaseX installé
- ✅ Base de données `padchest` créée
- ✅ Webservice dans `C:\BaseX\webapp\webservice.xqm`
- ✅ Serveur démarré avec `basexhttp.bat`

---

### Étape 1 : Modifier ton XML

Ouvre `Etape1_Conversion/padchest_images_dtd.xml`

Change la **ligne 2** pour pointer vers le fichier XSLT de l'Étape 5 :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="../Etape5_BaseX/Expert/padchest_expert_avec_webservice.xsl"?>
<!DOCTYPE padchest_database SYSTEM "../Etape2_Structure/Minimum/padchest_images.dtd">
<padchest_database>
  <!-- Tes images -->
</padchest_database>
```

**💡 Astuce** : Tu peux garder ton fichier Étape 4 intact et juste changer cette ligne !

---

### Étape 2 : Vérifier que le serveur BaseX tourne

```bash
cd C:\BaseX\bin
basexhttp.bat
```

Tu dois voir :
```
HTTP Server was started (port: 8080).
```

**🚨 Laisse cette fenêtre OUVERTE !**

---

### Étape 3 : Tester

1. **Double-clique** sur `padchest_images_dtd.xml`
2. La page s'ouvre dans ton navigateur
3. Tu vois un **bouton violet "📊 Statistiques BaseX"** dans les filtres
4. **Clique** dessus !

**🎉 Une popup s'affiche avec les stats en temps réel !**

---

## 🎨 Ce qui change par rapport à l'Étape 4

### Nouveau : Bouton "📊 Statistiques BaseX"

- Design violet avec gradient
- Placé dans la barre de filtres (à côté de "Réinitialiser")
- Appelle le webservice au clic

### Nouveau : Popup avec les stats

**Contenu** :
1. **Images avec "loc right"** : Le nombre en gros
2. **Top 10 des labels** : Liste avec occurrences

**Design** :
- Fond semi-transparent noir
- Carte blanche centrée
- Bouton X pour fermer
- Clic à l'extérieur pour fermer

---

## 🔧 Comment ça marche (en 3 étapes)

### 1️⃣ Tu cliques sur le bouton

JavaScript appelle le webservice :
```javascript
fetch('http://localhost:8080/padchest/stats')
```

### 2️⃣ BaseX répond avec du JSON

```json
{
  "loc_right_count": 17,
  "top_labels": [
    {"label": "normal", "count": 30},
    {"label": "unchanged", "count": 17}
  ]
}
```

### 3️⃣ JavaScript affiche dans la popup

Les données sont injectées dans le HTML de la popup.

---

## ✅ Tests rapides

### ✓ Le bouton apparaît ?
Ouvre le XML → Tu dois voir **"📊 Statistiques BaseX"** en violet dans les filtres

### ✓ Le serveur tourne ?
Va sur http://localhost:8080/padchest → Page d'accueil du webservice s'affiche

### ✓ La popup fonctionne ?
Clique sur le bouton → Popup avec "Chargement..." puis les stats

---

## 🚨 Problèmes courants

### ❌ "Erreur : Impossible de se connecter"

**Problème** : Serveur BaseX arrêté  
**Solution** : Lance `basexhttp.bat` dans PowerShell

### ❌ Le bouton n'apparaît pas

**Problème** : Mauvais fichier XSLT  
**Solution** : Vérifie la ligne 2 du XML → doit pointer vers `Etape5_BaseX/Expert/padchest_expert_avec_webservice.xsl`

### ❌ "CORS Error" dans la console

**Problème** : Restrictions navigateur  
**Solution** : Utilise XAMPP ou ouvre avec `http://localhost/` (pas `file://`)

---

## 📊 Comparaison des niveaux

| | Minimum | Pro | Expert |
|---|---|---|---|
| Requêtes XQuery | ✅ | ✅ | ✅ |
| Interface | BaseX | Navigateur | Page XSLT |
| Webservice | ❌ | ✅ | ✅ |
| Bouton intégré | ❌ | ❌ | ✅ |
| Popup AJAX | ❌ | ❌ | ✅ |
| Points | 5/5 | 6/5 | 7/5 |

---

## 🎤 Pour l'oral (5 minutes max)

### Architecture simple

```
Navigateur (XSLT + JS)
    ↓ AJAX
Webservice BaseX (port 8080)
    ↓ XQuery
Base de données XML
```

### Question 1 : "Comment ça communique ?"

> "J'utilise JavaScript Fetch pour faire un appel HTTP GET vers le webservice BaseX. Le serveur exécute les requêtes XQuery et retourne du JSON que j'affiche dans une popup."

### Question 2 : "Pourquoi AJAX ?"

> "AJAX permet de récupérer les données sans recharger la page. C'est plus rapide et l'utilisateur garde son contexte (filtres, recherche)."

### Question 3 : "Si le serveur est arrêté ?"

> "Le fetch échoue, l'erreur est capturée dans le .catch(), et un message s'affiche : 'Impossible de se connecter au serveur BaseX'."

---

## ✅ Checklist présentation

- [ ] Serveur BaseX démarré (`basexhttp.bat`)
- [ ] XML pointe vers le bon fichier XSLT
- [ ] Page s'ouvre correctement
- [ ] Bouton visible et fonctionnel
- [ ] Popup affiche les bonnes données
- [ ] Screenshot pris (page + popup)

---

## 🎯 Démo en 2 minutes

1. **Ouvre la page** : "Voici ma page XSLT Expert"
2. **Montre le bouton** : "J'ai ajouté ce bouton qui appelle BaseX"
3. **Clique** : "L'appel AJAX se fait en arrière-plan"
4. **Montre la popup** : "Les statistiques s'affichent en temps réel"
5. **Ouvre F12** : "On voit l'appel HTTP et la réponse JSON"

---

## 🎉 Bravo !

Tu as terminé le **niveau EXPERT** de l'Étape 5 !

**Architecture full-stack** :
- Frontend : XSLT + JavaScript
- Backend : BaseX + XQuery  
- Communication : REST API + JSON

**Points bonus garantis ! 💪**

