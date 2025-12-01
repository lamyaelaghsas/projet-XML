(:~
 : WEBSERVICE PRO - Niveau PRO
 : API REST pour accéder aux statistiques PadChest
 :)

module namespace api = "http://padchest/api";

(: Déclaration du namespace REST - OBLIGATOIRE :)
declare namespace rest = "http://exquery.org/ns/restxq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(:~
 : Page d'accueil du webservice
 :)
declare
  %rest:GET
  %rest:path("/padchest")
  %output:method("html")
function api:home() as element(html){
  <html>
    <head>
      <title>PadChest API</title>
      <style>
        body {{
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 50px auto;
          padding: 20px;
          background-color: #f0f8ff;
        }}
        h1 {{
          color: #5c6bc0;
          text-align: center;
        }}
        .endpoint {{
          background: white;
          padding: 15px;
          margin: 15px 0;
          border-radius: 8px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }}
        .endpoint h3 {{
          color: #9c27b0;
          margin-top: 0;
        }}
        a {{
          color: #5c6bc0;
          text-decoration: none;
        }}
        a:hover {{
          text-decoration: underline;
        }}
      </style>
    </head>
    <body>
      <h1> PadChest API - Webservice</h1>
      
      <div class="endpoint">
        <h3> Endpoint 1 : Images avec "loc right"</h3>
        <p><strong>URL :</strong> <a href="/padchest/loc-right">/padchest/loc-right</a></p>
        <p><strong>Description :</strong> Retourne le nombre d'images contenant la localisation "loc right"</p>
      </div>
      
      <div class="endpoint">
        <h3>  Endpoint 2 : Top 10 des labels</h3>
        <p><strong>URL :</strong> <a href="/padchest/top-labels">/padchest/top-labels</a></p>
        <p><strong>Description :</strong> Retourne les 10 labels les plus fréquents</p>
      </div>
      
      <div class="endpoint">
        <h3> Endpoint 3 : Toutes les statistiques</h3>
        <p><strong>URL :</strong> <a href="/padchest/stats">/padchest/stats</a></p>
        <p><strong>Description :</strong> Retourne toutes les statistiques en JSON</p>
      </div>
    </body>
  </html>
};

(:~
 : Endpoint 1 : Nombre d'images avec "loc right"
 :)
declare
  %rest:GET
  %rest:path("/padchest/loc-right")
  %output:method("html")
function api:locRight() as element(html) {
  let $count := count(
    collection("padchest")//image[localizations/localization[contains(., 'loc right')]]
  )
  return
    <html>
      <head>
        <title>Résultat - loc right</title>
        <style>
          body {{
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #e3f2fd;
            text-align: center;
          }}
          .result {{
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
          }}
          h1 {{
            color: #5c6bc0;
          }}
          .number {{
            font-size: 48px;
            color: #9c27b0;
            font-weight: bold;
            margin: 20px 0;
          }}
          a {{
            color: #5c6bc0;
            text-decoration: none;
          }}
        </style>
      </head>
      <body>
        <div class="result">
          <h1> Images avec "loc right"</h1>
          <div class="number">{$count}</div>
          <p>images contiennent la localisation "loc right"</p>
          <p><a href="/padchest">← Retour à l'accueil</a></p>
        </div>
      </body>
    </html>
};

(:~
 : Endpoint 2 : Top 10 des labels
 :)
declare
  %rest:GET
  %rest:path("/padchest/top-labels")
  %output:method("html")
function api:topLabels() as element(html) {
  let $all_labels := collection("padchest")//labels/label
  let $grouped := 
    for $label in distinct-values($all_labels)
    let $count := count($all_labels[. = $label])
    order by $count descending
    return <item><label>{$label}</label><count>{$count}</count></item>
  let $top10 := subsequence($grouped, 1, 10)
  
  return
    <html>
      <head>
        <title>Top 10 Labels</title>
        <style>
          body {{
            font-family: Arial, sans-serif;
            max-width: 700px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff0f5;
          }}
          h1 {{
            color: #d4a574;
            text-align: center;
          }}
          .labels-list {{
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
          }}
          .label-item {{
            padding: 12px;
            margin: 8px 0;
            background: #fafafa;
            border-radius: 5px;
            border-left: 4px solid #c5cae9;
          }}
          .rank {{
            font-weight: bold;
            color: #9c27b0;
          }}
          .count {{
            float: right;
            color: #5c6bc0;
            font-weight: bold;
          }}
          a {{
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #d4a574;
            text-decoration: none;
          }}
        </style>
      </head>
      <body>
        <h1>  Top 10 des labels les plus fréquents</h1>
        <div class="labels-list">
          {
            for $item at $pos in $top10
            return
              <div class="label-item">
                <span class="rank">{$pos}.</span> {$item/label/text()}
                <span class="count">{$item/count/text()} occurrences</span>
              </div>
          }
        </div>
        <a href="/padchest">← Retour à l'accueil</a>
      </body>
    </html>
};

(:~
 : Endpoint 3 : Toutes les stats en JSON
 :)
declare
  %rest:GET
  %rest:path("/padchest/stats")
  %output:method("json")
function api:stats() as element(html)  {
  let $all_labels := collection("padchest")//labels/label
  let $grouped := 
    for $label in distinct-values($all_labels)
    let $count := count($all_labels[. = $label])
    order by $count descending
    return <item><label>{$label}</label><count>{$count}</count></item>
  let $top10 := subsequence($grouped, 1, 10)
  let $loc_right_count := count(
    collection("padchest")//image[localizations/localization[contains(., 'loc right')]]
  )
  
  return 
    <json type="object">
      <loc__right__count type="number">{$loc_right_count}</loc__right__count>
      <top__labels type="array">
        {
          for $item in $top10
          return
            <_ type="object">
              <label type="string">{$item/label/text()}</label>
              <count type="number">{$item/count/text()}</count>
            </_>
        }
      </top__labels>
    </json>
};