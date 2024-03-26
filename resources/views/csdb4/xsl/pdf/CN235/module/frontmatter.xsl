<?xml version="1.0" encoding="UTF-8"?>

<!-- 
  Outstanding:
  - <dataRestriction> belum dibuat
  - @frontMatterInfoType (fmi-xx) belum dibuat
-->

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:php="http://php.net/xsl">

  <xsl:template match="content[name(child::*) = 'frontMatter']">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="frontMatterTitlePage">
    <xsl:apply-templates select="productIntroName"/>
    <xsl:apply-templates select="productAndModel"/>
    <xsl:apply-templates select="pmTitle"/>
    <xsl:apply-templates select="shortPmTitle"/>

    <fo:block>
      <xsl:apply-templates select="pmCode"/>
      <fo:inline-container inline-progression-dimension="30%">
        <xsl:apply-templates select="issueInfo"/>
      </fo:inline-container>
      <fo:inline-container>
        <xsl:apply-templates select="issueDate"/>
      </fo:inline-container>
    </fo:block>

    <xsl:apply-templates select="productIllustration"/>
    <xsl:apply-templates select="dataRestrictions"/>

    <!-- externalPubCode -->
    <fo:block-container>
      <xsl:for-each select="externalPubCode">
        <fo:block>
          <xsl:value-of select="@pubCodingScheme"/><xsl:text>:</xsl:text><xsl:apply-templates/> <xsl:text>   </xsl:text>
        </fo:block>
      </xsl:for-each>
    </fo:block-container>

    <!-- dervative classification here -->

    <!-- manufacturer -->
    <fo:block-container margin-top="11pt">
      <fo:block font-size="8pt">Manufacturer:</fo:block>
      <fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell width="2.5cm">
                <xsl:apply-templates select="enterpriseLogo"/>
              </fo:table-cell>
              <fo:table-cell display-align="center">
                <xsl:apply-templates select="enterpriseSpec"/>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>

    <!-- publisher -->
    <fo:block-container margin-top="11pt">
      <fo:block font-size="8pt">Publisher:</fo:block>
      <fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell width="2.5cm">
                <xsl:apply-templates select="publisherLogo"/>
                <fo:block></fo:block>
              </fo:table-cell>
              <fo:table-cell display-align="center">
                <fo:block><xsl:value-of select="string(responsiblePartnerCompany/enterpriseName)"/></fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>

    <xsl:apply-templates select="security"/>
    <xsl:apply-templates select="barCode"/>
    
    <fo:block break-before="page">
      <xsl:apply-templates select="frontMatterInfo"/>
    </fo:block>


  </xsl:template>

  <xsl:template match="productIntroName[ancestor::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmIntroName">
      <xsl:apply-templates select="name" />
    </fo:block>
  </xsl:template>

  <xsl:template match="productAndModel[parent::frontMatterTitlePage]">
    <xsl:if test="productName">
      <fo:block class="productName"><xsl:apply-templates class="productName"/></fo:block>
    </xsl:if>
    <xsl:for-each select="productModel">
      <fo:block-container>
        <fo:block>
          <fo:inline>Model: <xsl:apply-templates select="modelName"/></fo:inline>
          <xsl:if test="natoStockNumber">
            <xsl:text>   </xsl:text>
            <fo:inline>NSN: <xsl:apply-templates select="natoStockNumber"/></fo:inline>
          </xsl:if>
          <xsl:if test="identNumber">
            <xsl:text>   </xsl:text>
            <fo:inline>Manufacture Code: <xsl:apply-templates select="identNumber/manufacturerCode"/></fo:inline>
          </xsl:if>
        </fo:block>
      </fo:block-container>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="pmTitle[parent::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmPmTitle">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="shortPmTitle[parent::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmShortPmTitle">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="pmCode[parent::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmPmCode">
      <xsl:value-of select="php:function('Ptdi\Mpub\Main\CSDBStatic::resolve_pmCode', .)" />
    </fo:block>
  </xsl:template>

  <xsl:template match="issueInfo[parent::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmPmIssueInfo">
      Issue No.: <xsl:value-of select="@issueNumber"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="issueDate[parent::frontMatterTitlePage]">
    <fo:block xsl:use-attribute-sets="fmPmIssueDate">
      Issue Date: <xsl:value-of select="php:function('Ptdi\Mpub\Main\CSDBStatic::resolve_issueDate', .)"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="productIllustration">
    <fo:block text-align="center">
      <fo:external-graphic src="url('{unparsed-entity-uri(graphic/@infoEntityIdent)}')" content-width="scale-to-fit">
        <xsl:call-template name="setGraphicDimension"/>
      </fo:external-graphic>
    </fo:block>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="enterpriseLogo">
    <fo:block>
      <xsl:for-each select="symbol">
        <fo:external-graphic src="url('{unparsed-entity-uri(@infoEntityIdent)}')" content-width="scale-to-fit" width="2cm"/>
      </xsl:for-each>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="publisherLogo">
    <fo:block>
      <xsl:for-each select="symbol">
        <fo:external-graphic src="url('{unparsed-entity-uri(@infoEntityIdent)}')" content-width="scale-to-fit" width="2cm"/>
      </xsl:for-each>
    </fo:block>
  </xsl:template>

  <xsl:template match="enterpriseSpec">
    <fo:block><xsl:apply-templates select="enterpriseName"/></fo:block>
    <fo:block><xsl:apply-templates select="businessUnit/businessUnitName"/></fo:block>
    <fo:block><xsl:apply-templates select="businessUnit/businessUnitAddress"/></fo:block>
    <fo:block>
      <fo:inline>
        <xsl:for-each select="contactPerson">
          <xsl:apply-templates select="lastName"/>
          <xsl:if test="middleName">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="middleName"/>
          </xsl:if>
          <xsl:if test="firstName">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="firstName"/>
          </xsl:if>
          <xsl:if test="jobTitle">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="jobTitle"/>
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:if test="contactPersonAddress">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="contactPersonAddress"/>
          </xsl:if>
          <xsl:text>.</xsl:text>
        </xsl:for-each>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <xsl:template match="businessUnitAddress">
    <fo:block>
      <xsl:variable name="address">
        <xsl:if test="department">
          <xsl:text>Dept. </xsl:text><xsl:value-of select="department"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="street">
          <xsl:text>St. </xsl:text><xsl:value-of select="street"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="city"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="country"/>
        <xsl:text>, </xsl:text>
        <xsl:if test="state">
          <xsl:value-of select="state"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="province">
          <xsl:value-of select="province"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="building">
          <xsl:value-of select="building"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="room">
          <xsl:value-of select="room"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="postOfficeBox">
          <xsl:value-of select="postOfficeBox"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="postalZipCode">
          <xsl:value-of select="postalZipCode"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="phoneNumber">
          <xsl:text>Phone: </xsl:text>
          <xsl:for-each select="phoneNumber">
            <xsl:value-of select="phoneNumber"/>
            <xsl:text>, </xsl:text>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="faxNumber">
          <xsl:text>Fax: </xsl:text>
          <xsl:for-each select="faxNumber">
            <xsl:value-of select="faxNumber"/>
            <xsl:text>, </xsl:text>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="email">
          <xsl:text>Email: </xsl:text>
          <xsl:for-each select="email">
            <xsl:value-of select="email"/>
            <xsl:text>, </xsl:text>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="internet">
          <xsl:text>Web: </xsl:text>
          <xsl:for-each select="internet">
            <xsl:value-of select="internet"/>
            <xsl:text>, </xsl:text>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="SITA">
          <xsl:value-of select="SITA"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:variable>
      <xsl:value-of select="php:function('preg_replace', '/,\s?$/','',$address)"/>
      <xsl:text>.</xsl:text>
    </fo:block>
  </xsl:template>

  <xsl:template match="frontMatterInfo">
    <fo:block-container margin-top="6pt">
      <fo:block xsl:use-attribute-sets="h1">
        <xsl:value-of select="title"/>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block-container>
  </xsl:template>
  

  
</xsl:transform>