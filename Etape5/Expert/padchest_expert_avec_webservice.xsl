<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  XSLT Niveau Expert - PadChest
  Avec recherche, filtres ET intégration webservice BaseX
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>PadChest Expert</title>
        <meta charset="UTF-8"/>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #fffacd;
          }
          
          h1 {
            text-align: center;
            color: #d4a574;
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
          }
          
          .search-bar {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .search-bar input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ffd4a3;
            border-radius: 8px;
            font-size: 16px;
          }
          
          .filters {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .filters h3 {
            color: #d4a574;
            margin-top: 0;
          }
          
          .filter-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
          }
          
          .filter-group {
            flex: 1;
            min-width: 200px;
          }
          
          .filter-group label {
            display: block;
            margin-bottom: 5px;
            color: #8b7355;
            font-weight: bold;
          }
          
          .filter-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #f0e68c;
            border-radius: 6px;
            font-size: 14px;
          }
          
          .reset-button {
            padding: 10px 20px;
            background-color: #ffb6c1;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
          }
          
          .reset-button:hover {
            background-color: #ff9eb5;
          }
          
          .basex-button {
            padding: 12px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
            transition: all 0.3s;
          }
          
          .basex-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.5);
          }
          
          .stats {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
          }
          
          .stat-box {
            flex: 1;
            background-color: #e6f3ff;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .stat-box h2 {
            color: #7ba3cc;
            margin: 0;
            font-size: 32px;
          }
          
          .stat-box p {
            color: #9dbad9;
            margin: 5px 0 0 0;
          }
          
          .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 18px;
          }
          
          .card {
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .card.hidden {
            display: none;
          }
          
          .card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
          }
          
          .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 2px solid #d4f1d4;
            gap: 8px;
          }
          
          .card-id {
            font-weight: bold;
            color: #81c784;
            font-size: 11px;
            word-break: break-all;
            line-height: 1.3;
            flex: 1;
          }
          
          .badge {
            padding: 4px 8px;
            border-radius: 5px;
            font-size: 10px;
            font-weight: bold;
            flex-shrink: 0;
            white-space: nowrap;
          }
          
          .badge-yes {
            background-color: #ffccbc;
            color: #d84315;
          }
          
          .badge-no {
            background-color: #f5f5f5;
            color: #757575;
          }
          
          .info-line {
            margin: 8px 0;
            padding: 7px;
            background-color: #fafafa;
            border-radius: 5px;
          }
          
          .info-label {
            font-weight: bold;
            color: #616161;
            font-size: 11px;
            margin-bottom: 4px;
          }
          
          .info-value {
            font-size: 12px;
            color: #424242;
            word-break: break-word;
          }
          
          .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin-top: 5px;
          }
          
          .tag {
            background-color: #dcedc8;
            color: #558b2f;
            padding: 3px 7px;
            border-radius: 10px;
            font-size: 10px;
          }
          
          .tag-loc {
            background-color: #b3e5fc;
            color: #0277bd;
          }
          
          .no-results {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 18px;
          }
          
          .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
          }
          
          .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            width: 80%;
            max-width: 700px;
            box-shadow: 0 5px 30px rgba(0,0,0,0.3);
          }
          
          .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 15px;
          }
          
          .modal-header h2 {
            color: #667eea;
            margin: 0;
          }
          
          .close {
            font-size: 30px;
            font-weight: bold;
            color: #999;
            cursor: pointer;
          }
          
          .close:hover {
            color: #333;
          }
          
          .basex-stats {
            margin-top: 20px;
          }
          
          .basex-stat-item {
            background: #f8f9fa;
            padding: 15px;
            margin: 10px 0;
            border-radius: 8px;
            border-left: 4px solid #667eea;
          }
          
          .basex-stat-item h3 {
            color: #667eea;
            margin: 0 0 10px 0;
          }
          
          .loading {
            text-align: center;
            padding: 20px;
            color: #999;
          }
        </style>
      </head>
      <body>
        <h1>Base de donnees PadChest - Expert + BaseX</h1>
        
        <div class="search-bar">
          <input 
            type="text" 
            id="searchInput" 
            placeholder="Rechercher un label ou une localisation..."
            onkeyup="filterImages()"
          />
        </div>
        
        <div class="filters">
          <h3>Filtres</h3>
          <div class="filter-row">
            <div class="filter-group">
              <label>Pediatrique</label>
              <select id="filterPediatric" onchange="filterImages()">
                <option value="">Tous</option>
                <option value="Yes">Oui</option>
                <option value="No">Non</option>
              </select>
            </div>
            
            <div class="filter-group">
              <label>Projection</label>
              <select id="filterProjection" onchange="filterImages()">
                <option value="">Toutes</option>
                <xsl:for-each select="//projection[not(.=preceding::projection)]">
                  <option><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></option>
                </xsl:for-each>
              </select>
            </div>
            
            <div class="filter-group">
              <label>Methode</label>
              <select id="filterMethod" onchange="filterImages()">
                <option value="">Toutes</option>
                <xsl:for-each select="//method_projection[not(.=preceding::method_projection)]">
                  <option><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></option>
                </xsl:for-each>
              </select>
            </div>
            
            <div class="filter-group">
              <button class="reset-button" onclick="resetFilters()">Reinitialiser</button>
            </div>
            
            <div class="filter-group">
              <button class="basex-button" onclick="loadBaseXStats()">Statistiques BaseX</button>
            </div>
          </div>
        </div>
        
        <div class="stats">
          <div class="stat-box">
            <h2 id="statTotal"><xsl:value-of select="count(//image)"/></h2>
            <p>Images visibles</p>
          </div>
          <div class="stat-box">
            <h2 id="statPediatric"><xsl:value-of select="count(//image[pediatric='Yes'])"/></h2>
            <p>Pediatriques</p>
          </div>
          <div class="stat-box">
            <h2 id="statLabels"><xsl:value-of select="count(//label)"/></h2>
            <p>Labels</p>
          </div>
          <div class="stat-box">
            <h2 id="statLocalizations"><xsl:value-of select="count(//localization)"/></h2>
            <p>Localisations</p>
          </div>
        </div>
        
        <div class="cards-container" id="cardsContainer">
          <xsl:apply-templates select="//image"/>
        </div>
        
        <div class="no-results" id="noResults" style="display: none;">
          Aucun resultat trouve
        </div>
        
        <div id="basexModal" class="modal">
          <div class="modal-content">
            <div class="modal-header">
              <h2>Statistiques BaseX</h2>
              <span class="close" onclick="closeModal()">X</span>
            </div>
            <div id="basexContent" class="basex-stats">
              <div class="loading">Chargement des statistiques...</div>
            </div>
          </div>
        </div>
        
                <script><![CDATA[
          function filterImages() {
            var searchValue = document.getElementById('searchInput').value.toLowerCase();
            var pediatricFilter = document.getElementById('filterPediatric').value;
            var projectionFilter = document.getElementById('filterProjection').value;
            var methodFilter = document.getElementById('filterMethod').value;
            
            var cards = document.querySelectorAll('.card');
            var visibleCount = 0;
            var pediatricCount = 0;
            var labelsCount = 0;
            var localizationsCount = 0;
            
            cards.forEach(function(card) {
              var text = card.textContent.toLowerCase();
              var pediatric = card.dataset.pediatric;
              var projection = card.dataset.projection;
              var method = card.dataset.method;
              
              var matchSearch = text.includes(searchValue);
              var matchPediatric = !pediatricFilter || pediatric === pediatricFilter;
              var matchProjection = !projectionFilter || projection === projectionFilter;
              var matchMethod = !methodFilter || method === methodFilter;
              
              if (matchSearch && matchPediatric && matchProjection && matchMethod) {
                card.classList.remove('hidden');
                visibleCount++;
                if (pediatric === 'Yes') pediatricCount++;
                labelsCount += parseInt(card.dataset.labelscount || 0, 10);
                localizationsCount += parseInt(card.dataset.localizationscount || 0, 10);
              } else {
                card.classList.add('hidden');
              }
            });
            
            document.getElementById('statTotal').textContent = visibleCount;
            document.getElementById('statPediatric').textContent = pediatricCount;
            document.getElementById('statLabels').textContent = labelsCount;
            document.getElementById('statLocalizations').textContent = localizationsCount;
            
            document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
          }
          
          function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('filterPediatric').value = '';
            document.getElementById('filterProjection').value = '';
            document.getElementById('filterMethod').value = '';
            filterImages();
          }
          
          function loadBaseXStats() {
            var modal = document.getElementById('basexModal');
            var content = document.getElementById('basexContent');
            
            modal.style.display = 'block';
            content.innerHTML = '<div class="loading">Chargement des statistiques BaseX...</div>';
            
            fetch('http://localhost:8080/padchest/stats')
              .then(function(response) { 
                return response.json(); 
              })
              .then(function(data) {
                var html = '';
                
                html += '<div class="basex-stat-item">';
                html += '<h3>Images avec "loc right"</h3>';
                html += '<p style="font-size: 24px; color: #667eea; font-weight: bold;">' +
                          data.loc_right_count + ' images</p>';
                html += '</div>';
                
                html += '<div class="basex-stat-item">';
                html += '<h3>Top 10 des labels</h3>';
                html += '<ol style="margin: 10px 0; padding-left: 25px;">';
                
                if (Array.isArray(data.top_labels)) {
                  data.top_labels.forEach(function(item) {
                    html += '<li style="margin: 5px 0;">';
                    html += '<strong>' + item.label + '</strong> : ' + item.count + ' occurrences';
                    html += '</li>';
                  });
                }
                
                html += '</ol></div>';
                
                content.innerHTML = html;
              })
              .catch(function(error) {
                content.innerHTML = '<div style="color: red; padding: 20px;">' +
                  'Erreur : impossible de se connecter au serveur BaseX. ' +
                  'Assurez-vous qu\'il est démarré (basexhttp.bat) et que le webservice padchest/stats est actif.' +
                  '</div>';
                console.error('Erreur:', error);
              });
          }
          
          function closeModal() {
            document.getElementById('basexModal').style.display = 'none';
          }
          
          window.onclick = function(event) {
            var modal = document.getElementById('basexModal');
            if (event.target === modal) {
              modal.style.display = 'none';
            }
          };
        ]]></script>

      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="image">
    <div class="card">
      <xsl:attribute name="data-pediatric"><xsl:value-of select="pediatric"/></xsl:attribute>
      <xsl:attribute name="data-projection"><xsl:value-of select="projection"/></xsl:attribute>
      <xsl:attribute name="data-method"><xsl:value-of select="method_projection"/></xsl:attribute>
      <xsl:attribute name="data-labelscount"><xsl:value-of select="count(labels/label)"/></xsl:attribute>
      <xsl:attribute name="data-localizationscount"><xsl:value-of select="count(localizations/localization)"/></xsl:attribute>
      
      <div class="card-header">
        <span class="card-id">
          Image <xsl:value-of select="substring(@id, 1, 12)"/>...
        </span>
        <span>
          <xsl:attribute name="class">
            badge 
            <xsl:choose>
              <xsl:when test="pediatric='Yes'">badge-yes</xsl:when>
              <xsl:otherwise>badge-no</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="pediatric"/>
        </span>
      </div>
      
      <div class="info-line">
        <div class="info-label">Patient</div>
        <div class="info-value">
          ID: <xsl:value-of select="substring(patient_id, 1, 18)"/>...
        </div>
      </div>
      
      <div class="info-line">
        <div class="info-label">Projection</div>
        <div class="info-value">
          <xsl:value-of select="projection"/> - <xsl:value-of select="substring(method_projection, 1, 20)"/>
        </div>
      </div>
      
      <div class="info-line">
        <div class="info-label">Labels</div>
        <div class="tags">
          <xsl:for-each select="labels/label">
            <span class="tag"><xsl:value-of select="."/></span>
          </xsl:for-each>
        </div>
      </div>
      
      <xsl:if test="localizations/localization">
        <div class="info-line">
          <div class="info-label">Localisations</div>
          <div class="tags">
            <xsl:for-each select="localizations/localization">
              <span class="tag tag-loc"><xsl:value-of select="."/></span>
            </xsl:for-each>
          </div>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
