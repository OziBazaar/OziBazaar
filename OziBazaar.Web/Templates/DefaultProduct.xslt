<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/">
        <table class="table table-striped table-bordered table-condensed">
        <xsl:for-each select="Features/Feature">
           <xsl:variable name="IsImage" select="./@Name" />
            <tr >
              <td>
                  <strong> <xsl:value-of select="./@Name"/>                       
                  </strong>
              </td>
              <td>
                    <xsl:choose>
                      <xsl:when test="$IsImage='Image'">
                        <a  class="imageViewerdialog" href="/OziBazaar.Web/Media/FilpView?productId=1">
                          <img>
                          <xsl:attribute name="src">
                              <xsl:value-of select="./@Value"/>
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
        </xsl:for-each>  
        </table>
  
  </xsl:template>
</xsl:stylesheet>