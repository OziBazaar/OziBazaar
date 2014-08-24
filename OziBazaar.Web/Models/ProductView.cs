using OziBazaar.Framework.RenderEngine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace OziBazaar.Web.Models
{
    public class ProductView : IXMLRenderable
    {
        private readonly string renderTemplate = "~/Templates/DefaultProduct.xslt";
        public ProductView()
        {
            renderTemplate = HttpContext.Current.Server.MapPath(renderTemplate);
            Features = new List<ProductFeatureView>();
        }
        public ProductView(string template):this()
        {
            if(!string.IsNullOrEmpty(template))
                 renderTemplate = HttpContext.Current.Server.MapPath(template); ; ;
        }
        public List<ProductFeatureView> Features { get; set; }

        public XDocument Render()
        {
            List<XElement> features = new List<XElement>();

            foreach (var feature in Features)
            {
                features.Add(new XElement("Feature", new XAttribute("Name", feature.FeatureName), new XAttribute("Title", feature.Title), new XAttribute("Value", feature.FeatureValue)));

            }
            XDocument inputXml = new XDocument(new XElement("Features", features));
            return inputXml;
        }


        public string Xsl
        {
            get { return renderTemplate ; }
        }
    }
}