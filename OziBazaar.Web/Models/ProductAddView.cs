using OziBazaar.Framework.RenderEngine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace OziBazaar.Web.Models
{
    public class ProductAddView : IXMLRenderable
    {
        private string renderTemplate= "~/Templates/AddProduct.xslt";
        protected virtual string RenderTemplate
        {
            get
            {
                return renderTemplate;
            }
            set
            {
                renderTemplate=value;
            }
        }
        public ProductAddView()
        {
            renderTemplate = HttpContext.Current.Server.MapPath(RenderTemplate);
            Features = new List<ProductFeatureAdd>();
        }
        public ProductAddView(string template):this()
        {
            renderTemplate = HttpContext.Current.Server.MapPath(template); ;
        }
        public  List<ProductFeatureAdd> Features { get; set; }
        public virtual System.Xml.Linq.XDocument Render()
        {
            List<XElement> features = new List<XElement>();

            foreach (var feature in Features)
            {
                var enumValue = string.Empty;
                if (feature.ValueEnum == null)
                    feature.ValueEnum = new List<string>();

                List<object> attributeList = new List<object>();
                attributeList.Add(new XAttribute("PropertyId", feature.PropertyId));
                attributeList.Add(new XAttribute("Name", feature.FeatureName));
                attributeList.Add(new XAttribute("EditorType", feature.EditorType));
                if (feature.IsMandatory )
                    attributeList.Add(new XAttribute("IsMandatory", feature.IsMandatory));
                if (feature.ValueEnum != null)
                    attributeList.Add(SerializeList(feature.ValueEnum));
                if (!string.IsNullOrEmpty(feature.DependsOn))
                    attributeList.Add(new XAttribute("DependsOn", feature.DependsOn));

                features.Add(new XElement("Feature", attributeList));

            }
            XDocument inputXml = new XDocument(new XElement("Features", features));
            return inputXml;

        }
        protected static XElement SerializeList(List<string> lst)
        {
            string name = "Value";

            XElement root = new XElement("EnumValue");
            int cnt = 0;
            foreach (var item in lst)
            {
                root.Add(new XElement(name, item.ToString()));
                cnt++;
            }
            return root;

        }
        public string Xsl
        {
            get { return renderTemplate; }
        }
    }
   
}