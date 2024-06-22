<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:php="http://php.net/xsl">

  <!-- 
    Outstanding
    1. <foldout>, <multimedia>, <....alts> belum difungsikan/dicoba
   -->

  <!-- 
    param 'id' diperlukan jika ingin pakai page 1 of <total>
   -->
  <xsl:template match="dmodule">
    <xsl:param name="masterReference"/>
    <xsl:variable name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>
    
    <fo:page-sequence master-reference="{$masterReference}" initial-page-number="auto-odd" force-page-count="even">
      <xsl:call-template name="getRegion">
        <xsl:with-param name="masterReference" select="$masterReference"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
      <fo:flow flow-name="body">
        <xsl:apply-templates select="content">
          <xsl:with-param name="masterName" select="$masterReference"/>
        </xsl:apply-templates>
        <!-- <xsl:call-template name="body"/> -->
        <!-- <fo:block-container>
          <fo:block>aaa</fo:block>
        </fo:block-container> -->
      </fo:flow>
    </fo:page-sequence>
  </xsl:template> 

  <!-- <xsl:template match="pm" name="call_pmx"> -->
    <!-- <xsl:param name="masterReference"/> -->
    <!-- <xsl:variable name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable> -->
    <!-- <xsl:value-of select="php:function('dd', 'tes4')"/> -->
    <!-- <xsl:apply-templates select="//content"/> -->
  <!-- </xsl:template> -->
  
  
</xsl:transform>