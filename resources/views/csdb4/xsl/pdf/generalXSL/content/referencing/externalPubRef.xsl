<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:php="http://php.net/xsl">

  <xsl:template match="externalPubRef">
    <xsl:variable name="externalPubRefIdent" select="php:function('Ptdi\Mpub\Main\CSDBStatic::resolve_externalPubRefIdent', ., '', '')"/>
    <xsl:call-template name="cgmark_begin"/>
    <xsl:call-template name="add_inline_applicability"/>
    <xsl:call-template name="add_inline_controlAuthority"/>
    <xsl:call-template name="add_inline_security"/>
    <fo:basic-link external-destination="/{$pmIdent}" color="blue">
      <xsl:value-of select="$pmIdent"/>
    </fo:basic-link>
    <xsl:call-template name="cgmark_end"/>
  </xsl:template>

</xsl:transform>