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
        Please click the following link to activate your account
        <br />
        <xsl:variable name="hyperlink">
          <xsl:value-of select="Parameters/ActivationUrl" />
        </xsl:variable>
        <a href="{$hyperlink}">Click here to activate your account.</a>
        <br />
        <br />
        Thanks
        <br />
        Ozi Bazaar Team
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
