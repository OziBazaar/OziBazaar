using System;
using System.Globalization;
using System.Web.Mvc;
using ModelBindingContext = System.Web.Http.ModelBinding.ModelBindingContext;

namespace OziBazaar.Web.Binder
{
 
    public class DateTimeModelBinder : DefaultModelBinder
    {
        private string _customFormat;

        public DateTimeModelBinder(string customFormat)
        {
            _customFormat = customFormat;
        }

        public override object BindModel(ControllerContext controllerContext, System.Web.Mvc.ModelBindingContext bindingContext)
        {
            var value = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
            return DateTime.ParseExact(value.AttemptedValue, _customFormat, CultureInfo.InvariantCulture);
        }

     
    }
}
