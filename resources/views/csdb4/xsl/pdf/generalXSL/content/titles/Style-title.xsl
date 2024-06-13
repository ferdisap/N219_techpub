<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:php="http://php.net/xsl">


  <!-- Note
    1. selanjutnya tes untuk numbering pakai <xsl:number/>, eg: <xsl:number level="multiple" count="levelledPara"/>, <xsl:number level="multiple" count="crewDrill|if"/> (output di crew.xsd '1.1')
  -->

  <xsl:template name="style-title">
    <xsl:param name="level"/>
    <xsl:choose>
      <!-- compliance to S1000D v5.0 chap 6.2.2 page 8, para 2.6.1 par2-->
      <xsl:when test="parent::randomList or parent::sequentialList or parent::definitionList or parent::attentionSequentialList or parent::attentionRandomList">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="margin-bottom">4pt</xsl:attribute> <!-- leading 14pt setara 4pt karena fontsize 10pt -->
      </xsl:when>
      <!-- compliance to S1000D v5.0 chap 6.2.2 page 5, table 2 dan table 3 (leading to a follow-on text paragraph)  -->
      <xsl:when test="$level = 'c1'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">14pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <!-- <xsl:attribute name="margin-bottom">17pt</xsl:attribute> -->
          <xsl:attribute name="margin-bottom">7pt</xsl:attribute>
          <xsl:attribute name="text-align">center</xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$level = 'c2'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">14pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="font-style">italic</xsl:attribute>
          <!-- <xsl:attribute name="margin-bottom">17pt</xsl:attribute> -->
          <xsl:attribute name="margin-bottom">7pt</xsl:attribute>
          <xsl:attribute name="text-align">center</xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$level = 's0'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">14pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-bottom">7pt</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$level = 's1'">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:when test="$level = 's2'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">12pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-bottom">2pt</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
        </xsl:if>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:when test="$level = 's2'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">10pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
          <xsl:attribute name="margin-bottom">2pt</xsl:attribute>
        </xsl:if>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:when test="$level = 's3'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">10pt</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
          <xsl:attribute name="margin-bottom">1pt</xsl:attribute>
        </xsl:if>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:when test="$level = 's4'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">10pt</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
          <xsl:attribute name="margin-bottom">1pt</xsl:attribute>
        </xsl:if>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:when test="$level = 's5'">
        <xsl:if test="following-sibling::para or following-sibling::figure or following-sibling::table or following-sibling::levelledPara">
          <xsl:attribute name="font-size">10pt</xsl:attribute>
          <xsl:attribute name="text-align">left</xsl:attribute>
          <xsl:attribute name="font-style">italic</xsl:attribute>
          <xsl:attribute name="margin-bottom">1pt</xsl:attribute>
        </xsl:if>
        <!-- <xsl:call-template name="numbered"/> -->
        <fo:inline-container start-indent="-{$stIndent}" width="{$titleNumberWidth}">
          <fo:block>
            <xsl:call-template name="numbered"/>
          </fo:block>
        </fo:inline-container>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:value-of select="php:function('dd',string(.))"/> -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>