<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:php="http://php.net/xsl">

  <xsl:template match="reducedPara">    
    <fo:block>
      <xsl:call-template name="style-para"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="para">
    <fo:block>
      <xsl:call-template name="style-para"/>
      <xsl:apply-templates/>
    </fo:block>
    <!-- <fo:block-container reference-orientation="90" width="2cm">
    </fo:block-container> -->
  </xsl:template>
  
  <xsl:template match="simplePara">
    <fo:block>
      <xsl:call-template name="style-para"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:transform>