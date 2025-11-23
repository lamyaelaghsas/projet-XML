<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  XSLT Niveau Minimum - PadChest
  Design simple avec couleurs pastels
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>PadChest - Images Radiographiques</title>
        <meta charset="UTF-8"/>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #fff5f8;
          }
          
          h1 {
            color: #ff9eb5;
            text-align: center;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          }
          
          .info {
            background-color: #ffe4e1;
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            text-align: center;
            font-size: 18px;
            color: #d4698b;
          }
          
          table {
            width: 100%;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
          }
          
          th {
            background-color: #ffd4e5;
            color: #8b5a7d;
            padding: 15px;
            text-align: left;
            font-weight: bold;
          }
          
          td {
            padding: 12px 15px;
            border-bottom: 1px solid #ffe4f0;
          }
          
          tr:hover {
            background-color: #fff0f5;
          }
          
          .pediatric-yes {
            color: #ff6b9d;
            font-weight: bold;
          }
          
          .pediatric-no {
            color: #999;
          }
        </style>
      </head>
      <body>
        <h1>Base de données PadChest</h1>
        
        <div class="info">
          Nombre total d'images : <strong><xsl:value-of select="count(//image)"/></strong>
        </div>
        
        <table>
          <tr>
            <th>ID Image</th>
            <th>Patient ID</th>
            <th>Année</th>
            <th>Projection</th>
            <th>Pédiatrique</th>
            <th>Labels</th>
            <th>Localisations</th>
          </tr>
          <xsl:apply-templates select="//image"/>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="image">
    <tr>
      <td><xsl:value-of select="@id"/></td>
      <td><xsl:value-of select="patient_id"/></td>
      <td><xsl:value-of select="birth_year"/></td>
      <td><xsl:value-of select="projection"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="pediatric='Yes'">
            <span class="pediatric-yes">Oui</span>
          </xsl:when>
          <xsl:otherwise>
            <span class="pediatric-no">Non</span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:for-each select="labels/label">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
      </td>
      <td>
        <xsl:for-each select="localizations/localization">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>