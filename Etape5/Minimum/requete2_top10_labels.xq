(: ============================================================================
   REQUÊTE 2 - Niveau MINIMUM
   Top 10 des labels les plus fréquents
   ============================================================================ :)

declare option output:method "text";

(: Récupérer tous les labels :)
let $tous_les_labels := //labels/label

(: Grouper par label et compter :)
let $labels_groupes := 
  for $label in distinct-values($tous_les_labels) (: liste des labels distincts :)
  let $count := count($tous_les_labels[. = $label]) (: compter chaque label :)
  order by $count descending (: trier par nombre d'occurrences :)
  return <item><label>{$label}</label><count>{$count}</count></item> (: créer un élément pour chaque label avec son compte :)

(: Prendre seulement le top 10 :)
let $top10 := subsequence($labels_groupes, 1, 10)

(: Affichage du résultat :)
return (
  "======================================&#10;",
  "RÉSULTAT REQUÊTE 2 - TOP 10 LABELS&#10;",
  "======================================&#10;",
  for $item at $position in $top10
  return concat(
    $position, ". ", 
    $item/label/text(), 
    " : ", 
    $item/count/text(), 
    " occurrences&#10;"
  ),
  "======================================&#10;"
)