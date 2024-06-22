<?xml version="1.0" encoding="UTF-8"?>

<!-- 
  outstanding:
  1. @char belum difungsikan
  2. @charoff belum difungsikan 
  3. table caption contined in multiple pages is not supported as it must comply to S1000D v5.0 Chap 6.2.2 page 13, last paragraph
      jadi untuk itu table caption akan diletakkan dibawah table agar lebih mudah dipahami
  4. @tabstyle dan @tgstyle belum di implementasikan karena belum tahu bagaimana cara/aturan implementasi
  5. @cols difungsikan hanya ketika ada table footnote yang 1 cell nya perlu di span maximal
  6. @colspec HARUS definisikan saat membuat table, sesuai dengan jumlah column yang diperlukan
  7. centering table is not supported by the FOP. If not use FOP, put the @text-align in <table-and-caption>
 -->

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:php="http://php.net/xsl">

  <!-- <xsl:value-of select="php:function('dd', //node()[position() &gt; 30])"/> -->
  <!-- <xsl:template match="table">
    <fo:block-container>
      <fo:table width="100%">
        <fo:table-column column-number="1" column-width="20%"/>
        <fo:table-column column-number="2" column-width="80%"/>
        <fo:table-header>
          <fo:table-row>
            <fo:table-cell><fo:block>AAA</fo:block></fo:table-cell>
            <fo:table-cell><fo:block>BBB</fo:block></fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="//node()[position() &gt; 27]">
            <fo:table-row>
              <fo:table-cell>
                <fo:block>Lorem, ipsum dolor sit amet consectetur adipisicing elit. Vel, eveniet?</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>
                  Lorem ipsum dolor sit amet consectetur adipisicing elit. Nisi non ad quaerat, soluta cumque minus accusantium unde quisquam aperiam sed?
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </fo:block-container>
  </xsl:template> -->
  <xsl:template match="table">
    <xsl:param name="level"/>

    <!-- <xsl:variable name="controlAutorityRefs"><xsl:value-of select="parent::table/@controlAutorityRefs"/></xsl:variable> -->
    <!-- <xsl:variable name="id"><xsl:value-of select="parent::table/@id"/></xsl:variable> -->
    <!-- <xsl:variable name="changeType"><xsl:value-of select="parent::table/@changeType"/></xsl:variable>
    <xsl:variable name="changeMark"><xsl:value-of select="parent::table/@changeMark"/></xsl:variable>
    <xsl:variable name="reasonForUpdateRefIds"><xsl:value-of select="parent::table/@reasonForUpdateRefIds"/></xsl:variable>
    <xsl:variable name="securityClassification"><xsl:value-of select="parent::table/@securityClassification"/></xsl:variable>
    <xsl:variable name="derivativeClassificationRefId"><xsl:value-of select="parent::table/@derivativeClassificationRefId"/></xsl:variable>
    <xsl:variable name="commercialClassification"><xsl:value-of select="parent::table/@commercialClassification"/></xsl:variable>
    <xsl:variable name="caveat"><xsl:value-of select="parent::table/@caveat"/></xsl:variable> -->
    <xsl:call-template name="cgmark_begin"/>
    <xsl:call-template name="add_applicability"/>
    <xsl:call-template name="add_controlAuthority"/>
    <xsl:call-template name="add_security"/>

    <fo:block-container width="100%" page-break-before="avoid">
      <!-- <xsl:call-template name="add_id"/>       -->
      <!-- <xsl:call-template name="style-table">
        <xsl:with-param name="orient" select="string(@orient)"/>
        <xsl:with-param name="level" select="$level"/>
      </xsl:call-template> -->

      <xsl:apply-templates select="tgroup">
        <!-- <xsl:with-param name="tocentry" select="string(@tocentry)"/>
        <xsl:with-param name="frame">
          <xsl:choose>
            <xsl:when test="@frame">
              <xsl:value-of select="string(@frame)"/>
            </xsl:when>
            <xsl:otherwise>topbot</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="orient" select="string(@orient)"/> -->
      </xsl:apply-templates>
      
      <xsl:apply-templates select="graphic"/>
    </fo:block-container>
    <xsl:call-template name="cgmark_end"/>
  </xsl:template>

  <!-- sama/mirip dengan captionGraphic di figuresMultimediaFoldouts/All.xsl -->
  <xsl:template name="captionTable">
    <xsl:param name="prefix">
      <xsl:text>Table</xsl:text>
      <xsl:text>&#160;</xsl:text>
      <xsl:for-each select="..">
        <xsl:number level="any"/>
      </xsl:for-each>
      <xsl:text>&#160;</xsl:text>
      <xsl:if test="count(parent::*/tgroup) > 1">
        <xsl:text>sheet </xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>&#160;</xsl:text>
      </xsl:if>
    </xsl:param>
    <xsl:apply-templates select="parent::*/title">
      <xsl:with-param name="prefix" select="$prefix"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="tgroup">
    <!-- 
      jika ada tabstyle maka semua style akan memakan template tabstyle ini
    -->
    <xsl:param name="tabstyle"/>

    <!-- jika ada tocentry (1) maka akan ditambahkan ke toc jika ada fitur autogenerated toc -->
    <xsl:param name="tocentry" select="string(parent::table/@tocentry)"/>

    <!-- frame adalah border table, bukan border cell -->
    <xsl:param name="frame"/>

    <!-- 
      if @colsep non-zero, setiap captionEntry akan diberikan border-right (calau caption entry di column pertama, border-left juga berikan).
      ini akan dioverride jika ada @colsep di <colspec>
    -->
    <xsl:param name="colsep">
      <xsl:choose>
        <xsl:when test="@colsep">
          <xsl:value-of select="string(@colsep)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(parent::table/@colsep)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- 
      if @rowsep non-zero, setiap captionEntry akan diberikan border-bottom
      ini akan dioverride jika ada @rowsep di <colspec>
    -->
    <xsl:param name="rowsep">
      <xsl:choose>
        <xsl:when test="@rowsep">
          <xsl:value-of select="string(@rowsep)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(parent::table/@rowsep)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    
    <!-- 
      jika @pgwide == 1, maka table width = 100% terhadap region body dan indendasi diabaikan
      jika orientation == landscape, ini diabaikan 
    -->
    <xsl:param name="pgwide">
      <xsl:choose>
         <xsl:when test="parent::table/@pgwide">
            <xsl:value-of select="string(parent::table/@pgwide)"/>
         </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- 
      semua entries akan menyesuaikan ini
     -->
    <xsl:param name="align" select="string(@align)"/>
    
    <xsl:param name="cols" select="string(@cols)"/>
    <xsl:param name="tgstyle">
      <xsl:choose>
        <xsl:when test="@tgstyle">
          <xsl:value-of select="string(@tgstyle)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(parent::table/@tabstyle)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="char" select="string(@char)"/>
    <xsl:param name="charoff" select="string(@charoff)"/>
    <xsl:variable name="controlAutorityRefs"><xsl:value-of select="string(parent::table/@controlAutorityRefs)"/></xsl:variable>

    <xsl:call-template name="add_applicability"/>
    <xsl:call-template name="add_controlAuthority"/>

    <!-- 
      table-omit-footer-at-break=true agar tidak dirender footnote setiap page jika break 
      table-omit-header-at-break="false" agar header selalu diprint jika page break
    -->
    <!-- <fo:table table-omit-footer-at-break="true" page-break-before="avoid"> -->
    <fo:table>
      <!-- <xsl:call-template name="style-tgroup">
        <xsl:with-param name="pgwide" select="$pgwide"/>
        <xsl:with-param name="frame" select="$frame"/>
      </xsl:call-template> -->
      <xsl:for-each select="colspec[@colnum and @colwidth]">
        <xsl:variable name="width" select="php:function('Ptdi\Mpub\Main\CSDBStatic::interpretDimension', string(@colwidth))"/>
        <fo:table-column column-number="{@colnum}" column-width="{$width}"/>
      </xsl:for-each>

      <xsl:if test="thead">
        <fo:table-header>
          <xsl:apply-templates select="thead"/>
        </fo:table-header>
      </xsl:if>      
      
      <!-- <xsl:if test="descendant::footnote or tfoot">
        <xsl:variable name="colsQuantity" select="string(@cols)"/>
        <fo:table-footer font-size="8pt">
          <xsl:apply-templates select="tfoot|__cgmark"/>
          <xsl:for-each select="descendant::footnote">
            <xsl:if test="@changeMark = '1'">
              <fo:change-bar-begin change-bar-class="{generate-id(.)}" change-bar-style="solid" change-bar-width="0.5pt" change-bar-offset="0.5cm"/>
            </xsl:if>
            <fo:table-row>
              <fo:table-cell number-columns-spanned="{$colsQuantity}">
                <xsl:call-template name="style-entry"/>
                <xsl:call-template name="add_applicability"/>
                <xsl:call-template name="add_controlAuthority"/> 
                <xsl:call-template name="add_security"/>
                <xsl:call-template name="add_footnote"/>
              </fo:table-cell>
            </fo:table-row>
            <xsl:if test="@changeMark = '1'">
              <fo:change-bar-end change-bar-class="{generate-id(.)}"/>
            </xsl:if>
          </xsl:for-each>
        </fo:table-footer>
      </xsl:if> -->
      <fo:table-body>
        <!-- <xsl:call-template name="style-tbody"/> -->
        <xsl:apply-templates select="tbody"/>
      </fo:table-body>      
    </fo:table>

    <!-- <xsl:if test="parent::*/title">
      <fo:block margin-top="3pt">
        <xsl:call-template name="captionTable"/>
      </fo:block>
    </xsl:if> -->

  </xsl:template>

  <xsl:template match="row">
    <!-- <xsl:if test="@applicRefId or controlAuthorityRefs or @securityClassification or @commercialClassification or @caveat">
      <fo:table-row keep-together="always">
        <fo:table-cell number-columns-spanned="{string(ancestor::tgroup/@cols)}" padding-top="4pt" padding-bottom="-4pt">
          <xsl:call-template name="add_applicability"/>
          <xsl:call-template name="add_controlAuthority"/> 
          <xsl:call-template name="add_security"/>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if> -->
    <fo:table-row>
      <!-- <xsl:call-template name="add_id"/> -->
      <!-- <xsl:call-template name="style-row"/> -->
      <xsl:apply-templates/>
    </fo:table-row>
    <!-- <xsl:if test="@applicRefId or controlAuthorityRefs or @securityClassification or @commercialClassification or @caveat">
      <fo:table-row keep-together="always">
        <fo:table-cell number-columns-spanned="{string(ancestor::tgroup/@cols)}" padding-top="4pt" padding-bottom="-4pt"><fo:block/></fo:table-cell>
      </fo:table-row>
    </xsl:if> -->
  </xsl:template>

  <!-- 
    outstanding <entry>:
    1. @namest, @nameend belum tahu kegunaannya
    2. @charoff, @char belum difungsikan
    3. @warningRefs, @cautionRefs
    4. @rotate masih bermasalah saat di render pdf karena @width nya atau karena memang @rotate nya belum berfungsi dengan benar
        masalahnya jika di rotate, cell nya tidak ke rotate juga
    5. @colname tidak bisa difungsikan, karena cell yang menggunakan width pada colspec tersebut akan stacking dengan cell lainnya. Hal ini sepertinya mungkin dikarenakan FOP tidak support table-layout=auto. FItur ini sepertinya bisa di implementasikan oleh TCPDF php
    6. @spanname tidak bisa digunakan jika total entry pada row tersebut melebihi jumlahnya jika ditambah spanspec. Hal ini sepertinya mungkin dikarenakan FOP tidak support table-layout=auto.
   -->
  <xsl:template match="entry">
    <!-- <xsl:param name="colname" select="string(@colname)"/>
    <xsl:param name="rowsep">
      <xsl:choose>
        <xsl:when test="@rowsep"><xsl:value-of select="string(@rowsep)"/></xsl:when>
        <xsl:when test="parent::row/@rowsep"><xsl:value-of select="string(parent::row/@rowsep)"/></xsl:when>
        <xsl:when test="($colname != '') and ancestor::tgroup/colspec[string(@colname) = $colname]/@rowsep">
          <xsl:value-of select="string(ancestor::tgroup/colspec[string(@colname) = $colname]/@rowsep)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ancestor::*[string(@rowsep) != '']/@rowsep"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="colsep">
      <xsl:choose>
        <xsl:when test="@colsep"><xsl:value-of select="string(@colsep)"/></xsl:when>
        <xsl:when test="parent::row/@colsep"><xsl:value-of select="string(parent::row/@colsep)"/></xsl:when>
        <xsl:when test="($colname != '') and ancestor::tgroup/colspec[string(@colname) = $colname]/@colsep">
          <xsl:value-of select="string(ancestor::tgroup/colspec[string(@colname) = $colname]/@colsep)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ancestor::*[string(@colsep) != '']/@colsep"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>     -->

    <fo:table-cell>
      <!-- <xsl:call-template name="style-entry">
        <xsl:with-param name="rowsep" select="$rowsep"/>
        <xsl:with-param name="colsep" select="$colsep"/>
      </xsl:call-template> -->

      <!-- <xsl:if test="@morerows"><xsl:attribute name="number-rows-spanned"><xsl:value-of select="string(@morerows)"/></xsl:attribute></xsl:if> -->

      <!-- <xsl:if test="@spanname">
        <xsl:variable name="numberColumnsSpanned">
          <xsl:variable name="namestColname"><xsl:value-of select="string(ancestor::tgroup/spanspec[@spanname = string(@spanname)]/@namest)"/></xsl:variable>
          <xsl:variable name="nameendColname"><xsl:value-of select="string(ancestor::tgroup/spanspec[@spanname = string(@spanname)]/@nameend)"/></xsl:variable>
          <xsl:variable name="namestColnum"><xsl:value-of select="number(ancestor::tgroup/colspec[@colname = $namestColname]/@colnum)"/></xsl:variable>
          <xsl:variable name="nameendColnum"><xsl:value-of select="number(ancestor::*/colspec[@colname = $nameendColname]/@colnum)"/></xsl:variable>
          <xsl:value-of select="number($nameendColnum - $namestColnum + 1)"/>
        </xsl:variable>
        <xsl:attribute name="number-columns-spanned"><xsl:value-of select="$numberColumnsSpanned"/></xsl:attribute>
      </xsl:if> -->

      <!-- <xsl:variable name="valign">
        <xsl:choose>
          <xsl:when test="@valign"><xsl:value-of select="string(@valign)"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="string(ancestor::*[@valign]/@align)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable> -->
      
      <!-- <xsl:choose>
        <xsl:when test="$valign = 'bottom'">
          <xsl:attribute name="display-align">after</xsl:attribute>
        </xsl:when>
        <xsl:when test="$valign = 'center'">
          <xsl:attribute name="display-align">middle</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="display-align">top</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose> -->

      <!-- <xsl:if test="@align"><xsl:attribute name="text-align"><xsl:value-of select="string(@align)"/></xsl:attribute>      </xsl:if> -->

      <!-- 
        1. supaya block container tidak akan di page-break, jangan pakai keep-togeter="always" karena cell/container tidak akan membuat line baru jika tulisan lebih panjang dari width cell.
        2. mungkin nanti dicoba pakai attribute yang lain
        <fo:block-container keep-together="always"> 
        3. jangan di page-break-inside="avoid" agar table nya break. Kalau tidak tampilannya akan hancur karena table panjang ada pada satu page
      -->
      <xsl:call-template name="cgmark_begin">
        <xsl:with-param name="changeMark" select="parent::row/@changeMark"/>
      </xsl:call-template>
      <fo:block>
        <!-- <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="string(@id)"/></xsl:attribute></xsl:if>
        <xsl:if test="string(@rotate) = '1'"><xsl:attribute name="reference-orientation">90</xsl:attribute></xsl:if>
        <xsl:if test="@applicRefId">
          <xsl:call-template name="add_applicability">
            <xsl:with-param name="prefix"><xsl:text>This cell is applicable to: </xsl:text></xsl:with-param>
          </xsl:call-template>          
          <xsl:call-template name="add_controlAuthority"/>
        </xsl:if> -->
        <!-- <xsl:apply-templates/> -->
        <xsl:text>a</xsl:text>
      </fo:block>
      <xsl:call-template name="cgmark_end">
        <xsl:with-param name="changeMark" select="parent::row/@changeMark"/>
      </xsl:call-template>
    </fo:table-cell>    
  </xsl:template>

</xsl:transform>