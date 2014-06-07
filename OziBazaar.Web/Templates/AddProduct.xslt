<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="/">
         <p>
         Enter Advertisement details
        </p>
        <br/>
        <table class="table table-striped table-bordered table-condensed">
        <xsl:for-each select="Features/Feature">
           <xsl:variable name="EditorType" select="./@EditorType" />
           <xsl:variable name="FeatureName" select="./@Name" />
          <xsl:variable name="DependsOn" select="./@DependsOn" />
          <xsl:variable name="FeatureId" select="./@PropertyId" />
            <tr >
              <td>
                  <strong> <xsl:value-of select="./@Name"/>                       
                  </strong>
              </td>
              <td>
                    <xsl:choose>
                      <xsl:when test="$EditorType='TextBox'">
                        <input type="text">
                          <xsl:attribute name="name">
                              <xsl:value-of select="./@PropertyId"/>
                          </xsl:attribute>
                          <xsl:attribute name="data-required">
                            <xsl:value-of select="./@IsMandatory"/>
                          </xsl:attribute>
                      </input>
                      </xsl:when>
                                            
                      <xsl:when test="$EditorType='TextArea'">
                        <textarea rows="8"  columns="60">
                          <xsl:attribute name="name">
                              <xsl:value-of select="./@PropertyId"/>
                          </xsl:attribute>
                          <xsl:value-of select="''"/>
                       </textarea>
                      </xsl:when>
                      
                      <xsl:when test="$EditorType='DropDown'">
                        <select>
                          <xsl:attribute name="name">
                            <xsl:value-of select="./@PropertyId"/>
                          </xsl:attribute>
                          <xsl:attribute name="id">
                            <xsl:value-of select="./@Name"/>
                          </xsl:attribute>
                          <xsl:attribute name="data-dependsOn">
                            <xsl:value-of select="./@DependsOn"/>
                          </xsl:attribute>
                          <option value="" text="--select--"></option>
                          <xsl:for-each select="./EnumValue/Value">
                            <option>
                              <xsl:value-of select="."/>
                            </option>
                          </xsl:for-each>
                        </select>
                      </xsl:when>
                      
                      <xsl:when test="$EditorType='CheckBox'">
                        <input type="checkbox">
                          <xsl:attribute name="name">
                            <xsl:value-of select="./@PropertyId"/>
                          </xsl:attribute>
                          <xsl:attribute name="value">
                              <xsl:value-of select="$FeatureName"/>
                            </xsl:attribute>
                        </input>
                      </xsl:when>
                      
                      <xsl:when test="$EditorType='RadioButton'">
                        <xsl:for-each select="./EnumValue/Value">
                          <input type="radio">
                            <xsl:attribute name="name">
                              <xsl:value-of select="$FeatureId"/>
                            </xsl:attribute>
                             <xsl:attribute name="value">
                              <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                          </input>
                          <br/>
                        </xsl:for-each>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:value-of select="./@Name"/>
                    </xsl:otherwise>
                    </xsl:choose>
              </td>
            </tr>
        </xsl:for-each>  
        </table>
   </xsl:template>
</xsl:stylesheet>