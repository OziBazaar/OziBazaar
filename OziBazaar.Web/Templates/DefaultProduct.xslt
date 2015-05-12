<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="/">
    <xsl:variable name="ImageSize" select="'100px'" />
        <table class="table table-striped table-bordered table-condensed">
        <xsl:for-each select="Features/Feature">
           <xsl:variable name="IsImage" select="./@Name" />
          <xsl:choose>
            <xsl:when test="$IsImage='Image'">
            </xsl:when>
            <xsl:otherwise>
              <tr >
                <td>
                  <strong>
                    <xsl:value-of select="./@Title"/>
                  </strong>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$IsImage='Image'">
                      <a  class="imageViewerdialog" href="/Media/FilpView?productId=1">
                        <img>
                          <xsl:attribute name="src">
                            <xsl:value-of select="./@Value"/>
                          </xsl:attribute>
                          <xsl:attribute name="width">
                            <xsl:value-of select="$ImageSize"/>
                          </xsl:attribute>
                          <xsl:attribute name="height">
                            <xsl:value-of select="$ImageSize"/>
                          </xsl:attribute>
                        </img>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="./@Value"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>  
        </table>  
  </xsl:template>
</xsl:stylesheet>