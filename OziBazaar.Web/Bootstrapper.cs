using System.Web.Mvc;
using Microsoft.Practices.Unity;
using Unity.Mvc4;
using OziBazaar.Framework.RenderEngine;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Infrastructure.Email;
using OziBazaar.Web.Infrastructure.Cryptography;
using OziBazaar.Web.Infrastructure.Security;
using Microsoft.Practices.ServiceLocation;

namespace OziBazaar.Web
{
    //added something
    //add another line
  public static class Bootstrapper
  {
    public static IUnityContainer Initialise()
    {
      var container = BuildUnityContainer();

      DependencyResolver.SetResolver(new UnityDependencyResolver(container));
      UnityServiceLocator locator = new UnityServiceLocator(container);
      ServiceLocator.SetLocatorProvider(() => locator);

      return container;
    }

    private static IUnityContainer BuildUnityContainer()
    {
      var container = new UnityContainer();
      
      // register all your components with the container here
      // it is NOT necessary to register your controllers
        
      // e.g. container.RegisterType<ITestService, TestService>(); 
      container.RegisterType<IRenderEngine, XslRenderEngine>();
      container.RegisterType<IProductRepository, ProductRepository>();
      container.RegisterType<ILookupRepository, LookupRepository>();
      container.RegisterType<IAccountRepository, AccountRepository>();
      container.RegisterType<ISmtpEmail, SmtpEmail>();
      container.RegisterType<IEncryptionEngine, EncryptionEngine>();
            
      RegisterTypes(container);

      return container;
    }

    public static void RegisterTypes(IUnityContainer container)
    {
    
    }
  }
}