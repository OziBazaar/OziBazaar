<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <body>
        <h2>
          Hello <xsl:value-of select="Parameters/Fullname"/>,
        </h2>
        <br />
        Your password has been reset to:
        <b>
          <xsl:value-of select="Parameters/NewPassword"/>
        </b>
        <br />
        <br />
        Regards
        <br />
        Ozi Bazaar Team
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
