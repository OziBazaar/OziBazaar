<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <body>
        <h2>
          Hello <xsl:value-of select="Parameters/Fullname"/>,
        </h2>
        <br />
        <br />
        The following advertisement:
        <br />
        <table border="1">
          <tr>
            <th style="text-align:left">Code</th>
            <th style="text-align:left">Title</th>
            <th style="text-align:left">Price</th>
          </tr>
          <tr>
            <td>
              <xsl:value-of select="Parameters/Code" />
            </td>
            <td>
              <xsl:value-of select="Parameters/Title" />
            </td>
            <td>
              <xsl:value-of select="Parameters/Price" />
            </td>
          </tr>
        </table>
        <br />
        is rejected because does not follow the terms and conditions of OziBazaar. In order to activate it, please change it
        <br />
        <br />
        Regards
        <br />
        Ozi Bazaar Team
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
