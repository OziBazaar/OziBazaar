using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace OziBazaar.Web.Models
{
    public class ProductEditView : ProductAddView
    {
        public  List<ProductFeatureEdit> Features { get; set; }
        private string renderTemplate = "~/Templates/EditProduct.xslt";
        protected override string RenderTemplate
        {
            get
            {
                return renderTemplate;
            }
            set
            {
                renderTemplate = value;
            }
        }
        public override System.Xml.Linq.XDocument Render()
        {
            List<XElement> features = new List<XElement>();
           
            foreach (var feature in Features.Cast<ProductFeatureEdit>())
            {
                var enumValue = string.Empty;
                if (feature.ValueEnum == null)
                    feature.ValueEnum = new List<string>();

                List<object> attributeList = new List<object>();
                attributeList.Add(new XAttribute("PropertyId", feature.PropertyId));
                attributeList.Add(new XAttribute("Name", feature.FeatureName));
                attributeList.Add(new XAttribute("Title", feature.Title));
                if(feature.Value != null)
                    attributeList.Add(new XAttribute("Value", feature.Value));

                attributeList.Add(new XAttribute("EditorType", feature.EditorType));
                if (feature.IsMandatory)
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
     
    }
}