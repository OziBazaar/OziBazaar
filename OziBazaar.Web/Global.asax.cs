using Microsoft.Practices.Unity;
using OziBazaar.Web.App_Start;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using OziBazaar.Web.Binder;
using Unity.WebApi;

namespace OziBazaar.Web
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            Bootstrapper.Initialise();
            SecurityConfig.InitializeComponents();
            var binder = new DateTimeModelBinder("dd/MM/yyyy");
            ModelBinders.Binders.Add(typeof(DateTime), binder);
            ModelBinders.Binders.Add(typeof(DateTime?), binder);
        }
    }
}
