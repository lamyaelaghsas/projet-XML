(: ============================================================================
   REQUÊTE 1 - Niveau MINIMUM
   Compter le nombre d'images avec localisation "loc right"
   ============================================================================ :)

(: Déclaration pour avoir un résultat propre :)
declare option output:method "text";

(: Variable pour le compteur :)
let $nombre_images_loc_right := count(
  (: On cherche toutes les images qui ont au moins une localisation contenant "loc right" :)
  //image[localizations/localization[contains(., 'loc right')]]
)

(: Affichage du résultat :)
return concat(
  "======================================", "&#10;",
  "RÉSULTAT REQUÊTE 1", "&#10;",
  "======================================", "&#10;",
  "Nombre d'images avec 'loc right' : ", $nombre_images_loc_right, "&#10;",
  "======================================", "&#10;"
)