﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.Xml.Xsl;
namespace OziBazaar.Framework.RenderEngine
{

    public class XslRenderEngine : IRenderEngine
    {
        public  string Render(IXMLRenderable component)
        {
            return GenerateHTML(component.Render(), component.Xsl);
        }
      
        private static string GenerateHTML(XDocument inputXml, string templateFileName)
        {
            
            XsltSettings xsltSettings = new XsltSettings(false, true);
            XslCompiledTransform xslt = new XslCompiledTransform();

            using (Stream stream =new FileStream(templateFileName, FileMode.Open, FileAccess.Read))
            {
                if (stream == null)
                {
                    string message = string.Format("template file  {0} not found", templateFileName);
                    throw new ApplicationException(message);
                }
                xslt.Load(XmlReader.Create(stream), xsltSettings, new XmlUrlResolver());
            }

            //transform
            StringBuilder htmlContent = new StringBuilder();
            XmlWriter outputXmlWriter = XmlWriter.Create(htmlContent, new XmlWriterSettings { ConformanceLevel = ConformanceLevel.Auto });
            xslt.Transform(inputXml.CreateReader(), outputXmlWriter);

            return htmlContent.ToString();
        }
    }
}