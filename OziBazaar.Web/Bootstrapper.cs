using System.Web.Mvc;
using Microsoft.Practices.Unity;
using Unity.Mvc4;
using OziBazaar.Framework.RenderEngine;
using OziBazaar.Web.Infrastructure.Repository;
using OziBazaar.Web.Areas.UserManagement.Security;
using Microsoft.Practices.ServiceLocation;
using OziBazaar.DAL.Repository;
using OziBazaar.Common.Cryptography;
using OziBazaar.DAL;
using OziBazaar.Common.Provider;
using OziBazaar.Notification.Email;
using OziBazaar.Common.Transformation;
using OziBazaar.Common.Serialization;
using OziBazaar.Notification.Controller;
using OziBazaar.Web.Areas.UserManagement.Models;
using OziBazaar.Web.Areas.UserManagement.Converter;

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
      container.RegisterType<IRenderEngine, XslRenderEngine>();
      container.RegisterType<IProductRepository, ProductRepository>();
      container.RegisterType<ILookupRepository, LookupRepository>();
      container.RegisterType<IAccountRepository, AccountRepository>();
      container.RegisterType<IEncryptionEngine, EncryptionEngine>();
      container.RegisterType<ICacheRepository<Country>, CountryRepository>();
      container.RegisterType<ICacheProvider, DefaultCacheProvider>();
      container.RegisterType<INotificationController, NotificationController>();
      container.RegisterType<ISmtpEmailUtil, SmtpEmailUtil>();
      container.RegisterType<ITransformerUtil, TransformerUtil>();
      container.RegisterType<ISerializationUtil, SerializationUtil>();
      container.RegisterType<IConverter<UserProfile, UserProfileViewModel>, UserProfileViewModelConverter>();
      container.RegisterType<IConverter<UserProfileViewModel, UserProfile>, UserProfileConverter>();
      container.RegisterType<IActivationManager, ActivationManager>();
      RegisterTypes(container);

      return container;
    }

    public static void RegisterTypes(IUnityContainer container)
    {
    
    }
  }
}