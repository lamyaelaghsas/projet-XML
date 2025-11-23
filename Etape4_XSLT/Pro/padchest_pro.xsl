<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  XSLT Niveau Pro - PadChest
  Design avec cards et couleurs pastels
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>PadChest Pro</title>
        <meta charset="UTF-8"/>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f8ff;
          }
          
          h1 {
            text-align: center;
            color: #8b9dc3;
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
          }
          
          .stats {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
          }
          
          .stat-box {
            flex: 1;
            background-color: #e3f2fd;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .stat-box h2 {
            color: #5c6bc0;
            margin: 0;
            font-size: 32px;
          }
          
          .stat-box p {
            color: #7986cb;
            margin: 5px 0 0 0;
          }
          
          .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
          }
          
          .card {
            background-color: white;
            padding: 18px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
          }
          
          .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e1bee7;
          }
          
          .card-id {
            font-weight: bold;
            color: #9c27b0;
            font-size: 13px;
            word-break: break-all;
            max-width: 70%;
          }
          
          .badge {
            padding: 4px 8px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: bold;
            flex-shrink: 0;
          }
          
          .badge-yes {
            background-color: #ffcdd2;
            color: #c62828;
          }
          
          .badge-no {
            background-color: #f5f5f5;
            color: #757575;
          }
          
          .info-line {
            margin: 8px 0;
            padding: 8px;
            background-color: #fafafa;
            border-radius: 5px;
          }
          
          .info-label {
            font-weight: bold;
            color: #616161;
            font-size: 12px;
            margin-bottom: 4px;
          }
          
          .info-value {
            font-size: 13px;
            color: #424242;
            word-break: break-word;
          }
          
          .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-top: 6px;
          }
          
          .tag {
            background-color: #c5cae9;
            color: #3f51b5;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 11px;
          }
          
          .tag-loc {
            background-color: #b2dfdb;
            color: #00796b;
          }
        </style>
      </head>
      <body>
        <h1>Base de données PadChest</h1>
        
        <div class="stats">
          <div class="stat-box">
            <h2><xsl:value-of select="count(//image)"/></h2>
            <p>Images totales</p>
          </div>
          <div class="stat-box">
            <h2><xsl:value-of select="count(//image[pediatric='Yes'])"/></h2>
            <p>Pédiatriques</p>
          </div>
          <div class="stat-box">
            <h2><xsl:value-of select="count(//label)"/></h2>
            <p>Labels</p>
          </div>
          <div class="stat-box">
            <h2><xsl:value-of select="count(//localization)"/></h2>
            <p>Localisations</p>
          </div>
        </div>
        
        <div class="cards-container">
          <xsl:apply-templates select="//image"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="image">
    <div class="card">
      <div class="card-header">
        <span class="card-id">
          Image <xsl:value-of select="substring(@id, 1, 15)"/>...
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
          ID: <xsl:value-of select="substring(patient_id, 1, 20)"/>
          <xsl:if test="string-length(patient_id) &gt; 20">...</xsl:if>
        </div>
      </div>
      
      <div class="info-line">
        <div class="info-label">Projection</div>
        <div class="info-value">
          <xsl:value-of select="projection"/> - <xsl:value-of select="substring(method_projection, 1, 25)"/>
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