# ⭐ ÉTAPE 5 - Niveau PRO

## ✅ Ce que contient ce dossier

- `requete1_loc_right.xq` - Requête 1 (même que Minimum)
- `requete2_top10_labels.xq` - Requête 2 (même que Minimum)
- `webservice.xqm` - **Webservice REST API**
- `README_PRO.md` - Ce fichier

---

## 🚀 INSTALLATION DU WEBSERVICE

### Étape 1 : Copier le webservice dans BaseX

1. Copie le fichier `webservice.xqm`
2. Colle-le dans : `C:\Téléchargements\BaseX120\basex\webapp\`

**Chemin complet** : `C:\Téléchargements\BaseX120\basex\webapp\webservice.xqm`

---

### Étape 2 : Démarrer le serveur BaseX

Dans PowerShell :
```bash
cd C:\Téléchargements\BaseX120\basex\bin
.\basexhttp.bat
```

Tu verras :
```
[main] INFO org.eclipse.jetty.server.Server - Started
HTTP Server started (port: 8080)
```

**⚠️ IMPORTANT : Laisse cette fenêtre OUVERTE !**

---

### Étape 3 : Tester dans le navigateur

Ouvre ton navigateur et va sur :

**Page d'accueil** :
```
http://localhost:8080/padchest
```

Tu verras une belle page avec les 3 endpoints ! 🎉

**Endpoint 1 - loc right** :
```
http://localhost:8080/padchest/loc-right
```

**Endpoint 2 - Top 10 labels** :
```
http://localhost:8080/padchest/top-labels
```

**Endpoint 3 - JSON** :
```
http://localhost:8080/padchest/stats
```

---

## 📸 Screenshots à prendre

Pour la présentation :

1. Screenshot de la page d'accueil
2. Screenshot du résultat "loc right"
3. Screenshot du top 10 labels
4. Screenshot du JSON

---

## 🎓 POUR L'ORAL

**Question** : "Qu'est-ce qu'un webservice ?"

**Réponse** :
> "Un webservice est une API accessible via HTTP qui permet d'interroger 
> la base de données depuis n'importe quel navigateur ou application."

**Question** : "Comment ça marche ?"

**Réponse** :
> "BaseX intègre un serveur HTTP. J'ai créé un module XQuery avec des 
> annotations REST qui définissent les routes (URLs) et les fonctions 
> qui retournent les résultats en HTML ou JSON."

---

