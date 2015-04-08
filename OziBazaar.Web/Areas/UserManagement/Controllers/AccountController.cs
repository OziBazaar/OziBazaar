using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;
using OziBazaar.Web.Models;
using System.Web.Security;
using System.Transactions;
using DotNetOpenAuth.AspNet;
using OziBazaar.DAL;
using OziBazaar.Web.Infrastructure.Repository;
using System.Data.SqlClient;
using OziBazaar.DAL.Repository;
using OziBazaar.Common.Cryptography;
using OziBazaar.Notification;
using OziBazaar.Notification.Email;
using OziBazaar.Common.Transformation;
using OziBazaar.Common.Serialization;
using OziBazaar.Notification.Entities;
using System.Text;
using OziBazaar.Common.Helper;
using System.Configuration;
using OziBazaar.Notification.Controller;
using OziBazaar.Web.Areas.UserManagement.Converter;
using OziBazaar.Common.Graphic;
using OziBazaar.DAL.Models;

namespace OziBazaar.Web.Areas.UserManagement.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private readonly IActivationManager _activationManager;
        private readonly INotificationController _notificationController;
        private readonly IProductRepository _productRepository;
        private readonly IAccountRepository _accountRepository;
        private readonly ICacheRepository<Country> _countryRepository;
        private readonly IConverter<UserProfile, UserProfileViewModel> _userProfileViewModelConverter;
        private readonly IConverter<UserProfileViewModel, UserProfile> _userProfileConverter;
        private readonly IRandomPasswordGenerator _randomPasswordGenerator;

        public AccountController(
            IActivationManager activationManager, 
            INotificationController notificationController,
            IProductRepository productRepository,
            IAccountRepository accountRepository,
            ICacheRepository<Country> countryRepository,
            IConverter<UserProfile, UserProfileViewModel> userProfileViewModelConverter,
            IConverter<UserProfileViewModel, UserProfile> userProfileConverter,
            IRandomPasswordGenerator randomPasswordGenerator
            )
        {
            this._activationManager = activationManager;
            this._notificationController = notificationController;
            this._productRepository = productRepository;
            this._accountRepository = accountRepository;
            this._countryRepository = countryRepository;
            this._userProfileViewModelConverter = userProfileViewModelConverter;
            this._userProfileConverter = userProfileConverter;
            this._randomPasswordGenerator = randomPasswordGenerator;
        }
        
        //
        // GET: /Account/Login

        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View(@"~\Areas\UserManagement\Views\Account\Login.cshtml");
        }

        //
        // POST: /Account/Login

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model, string returnUrl)
        {
            UserProfile userProfile = _accountRepository.GetUser(model.UserName);
            if (userProfile != null)
            {
                if (ModelState.IsValid && WebSecurity.Login(userProfile.UserName, model.Password, persistCookie: model.RememberMe))
                {
                    if (userProfile.Activated == true)
                    {
                        return RedirectToLocal(returnUrl);
                    }
                    else
                    {
                        ModelState.AddModelError("", "Please activate your account.");
                    }
                }
                else
                {
                    ModelState.AddModelError("", "The password is incorrect.");
                }
            }
            else
            {
                ModelState.AddModelError("", "The user name is incorrect.");
            }
            // If we got this far, something failed, redisplay form            
            return View(@"~\Areas\UserManagement\Views\Account\Login.cshtml",model);
        }

        //
        // POST: /Account/LogOff

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            WebSecurity.Logout();

            return RedirectToAction("Index", "Home", new { area = "" });
        }

        //
        // GET: /Account/Register

        [AllowAnonymous]
        public ActionResult Register()
        {
            RegisterModel model = new RegisterModel();
            model.CountryList = _countryRepository.GetAll().ToList<Country>();
            return View(model);
        }

        //
        // POST: /Account/Register

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (model.Captcha.ToLower() != Session["captchaText"].ToString().ToLower())
                    {
                        throw new CaptchaException("Invalid captcha");
                    }
                    if (_accountRepository.GetUserByEmail(model.EmailAddress) != null)
                    {
                        throw new MembershipCreateUserException(MembershipCreateStatus.DuplicateEmail);
                    }
                    // Attempt to register the user

                    WebSecurity.CreateUserAndAccount(
                        model.UserName,
                        model.Password,
                        new
                        {
                            FullName = model.FullName,
                            EmailAddress = model.EmailAddress,
                            Phone = model.Phone,
                            Activated = false,
                            CountryID = model.CountryID,
                            Address1 = model.Address1,
                            Address2 = model.Address2,
                            PostCode = model.PostCode
                        },
                        false);
                    bool result = _notificationController.SendActivationEmail(
                        new ActivationEmail()
                        {
                            Fullname = model.UserName,
                            ActivationUrl = URLHelper.GetActivationEmailUrl(
                               _activationManager.GenerateCode(new string[] { model.UserName, model.EmailAddress }))
                        },
                        model.EmailAddress
                    );
                    ViewBag.Message = "An activation email has been sent to your email address";
                    return View("Message");
                }
                catch (CaptchaException c)
                {
                    ModelState.AddModelError("", c.Message);
                }
                catch (MembershipCreateUserException e)
                {
                    ModelState.AddModelError("", ErrorCodeToString(e.StatusCode));
                }
                catch (SqlException se)
                {
                    ModelState.AddModelError("", "Failed to Register new user, Try with new username/email");
                }
            }
            // If we got this far, something failed, redisplay form
            model.CountryList = _countryRepository.GetAll().ToList<Country>();
            model.Captcha = "";
            return View(model);
        }

        //
        // Get: /Account/Activate
        
        [AllowAnonymous]
        public ActionResult Activation(string activationCode)
        {
            try
            {
                string[] values = _activationManager.InterpretCode(activationCode);
                if (_accountRepository.ActivateUser(values[0], values[1]) == true)
                {
                    ViewBag.Message = "The account is activated sucessfuly";
                    return View("Message");
                }
                else
                    return View("Error");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // GET: /Account/UserProfile

        [Authorize]
        public ActionResult UserProfile()
        {
            UserProfileViewModel model = _userProfileViewModelConverter.ConvertTo(_accountRepository.GetUser(User.Identity.Name));
            model.CountryList = _countryRepository.GetAll().ToList<Country>();
            return View(model);
        }

        //
        // POST: /Account/UserProfile

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult UserProfile(UserProfileViewModel model)
        {
            if (ModelState.IsValid)
            {
                // Attempt to update user profile information
                try
                {
                    _accountRepository.UpdateUserProfile(_userProfileConverter.ConvertTo(model));
                    return RedirectToAction("Index", "UserDashboard", new { area = "UserManagement" });
                }
                catch (SqlException se)
                {
                    ModelState.AddModelError("", "Failed to update user information, Please try again");
                }
            }
            // If we got this far, something failed, redisplay form
            model.CountryList = _countryRepository.GetAll().ToList<Country>();
            return View(model);
        }

        // GET: /Account/ResetPassword

        [AllowAnonymous]
        public ActionResult ResetPassword()
        {
            return View();
        }

        //
        // POST: /Account/ResetPassword

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ResetPassword(ResetPasswordModel model)
        {
            UserProfile userProfile = _accountRepository.GetUser(model.UserName);
            if (userProfile != null && userProfile.Activated == true)
            {
                if (ModelState.IsValid && userProfile.EmailAddress == model.EmailAddress)
                {
                    string newPassword = _randomPasswordGenerator.CreatePassword(8);
                    var token = WebSecurity.GeneratePasswordResetToken(model.UserName);
                    var result = WebSecurity.ResetPassword(token, newPassword);

                    bool result1 = _notificationController.SendResetPassword(
                        new ResetPassword()
                        {
                            Fullname = userProfile.FullName,
                            NewPassword = newPassword
                        },
                        model.EmailAddress
                    );
                    ViewBag.Message = "A new password has been sent to your email address";
                    return View("Message");                    
                }
                else
                {
                    ModelState.AddModelError("", "The user name or email address provided is incorrect.");
                }
            }
            else
            {
                ModelState.AddModelError("", "Please activate your account.");
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // POST: /Account/Disassociate

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Disassociate(string provider, string providerUserId)
        {
            string ownerAccount = OAuthWebSecurity.GetUserName(provider, providerUserId);
            ManageMessageId? message = null;

            // Only disassociate the account if the currently logged in user is the owner
            if (ownerAccount == User.Identity.Name)
            {
                // Use a transaction to prevent the user from deleting their last login credential
                using (var scope = new TransactionScope(TransactionScopeOption.Required, new TransactionOptions { IsolationLevel = IsolationLevel.Serializable }))
                {
                    bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
                    if (hasLocalAccount || OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name).Count > 1)
                    {
                        OAuthWebSecurity.DeleteAccount(provider, providerUserId);
                        scope.Complete();
                        message = ManageMessageId.RemoveLoginSuccess;
                    }
                }
            }

            return RedirectToAction("Manage", new { Message = message });
        }

        //
        // Get: /Account/ChangePassword
        public ActionResult ChangePassword()
        {
            return View();
        }

        //
        // POST: /Account/ChangePassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ChangePassword(LocalPasswordModel model)
        {
            if (ValidateUser(User.Identity.Name, model.OldPassword) == false)
                ModelState.AddModelError("", "Invalid password, Please try again");
            if (ModelState.IsValid)
            {
                var token = WebSecurity.GeneratePasswordResetToken(User.Identity.Name);
                var result = WebSecurity.ResetPassword(token, model.NewPassword);
                ViewBag.Message = "Your password sucessfuly changed";
                return View("Message");
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/Manage

        public ActionResult Manage(ManageMessageId? message)
        {
            ViewBag.StatusMessage =
                message == ManageMessageId.ChangePasswordSuccess ? "Your password has been changed."
                : message == ManageMessageId.SetPasswordSuccess ? "Your password has been set."
                : message == ManageMessageId.RemoveLoginSuccess ? "The external login was removed."
                : "";
            ViewBag.HasLocalPassword = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.ReturnUrl = Url.Action("Manage");
            return View();
        }

        //
        // POST: /Account/Manage

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Manage(LocalPasswordModel model)
        {
            bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.HasLocalPassword = hasLocalAccount;
            ViewBag.ReturnUrl = Url.Action("Manage");
            if (hasLocalAccount)
            {
                if (ModelState.IsValid)
                {
                    // ChangePassword will throw an exception rather than return false in certain failure scenarios.
                    bool changePasswordSucceeded;
                    try
                    {
                        changePasswordSucceeded = WebSecurity.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword);
                    }
                    catch (Exception)
                    {
                        changePasswordSucceeded = false;
                    }

                    if (changePasswordSucceeded)
                    {
                        return RedirectToAction("Manage", new { Message = ManageMessageId.ChangePasswordSuccess });
                    }
                    else
                    {
                        ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
                    }
                }
            }
            else
            {
                // User does not have a local password so remove any validation errors caused by a missing
                // OldPassword field
                ModelState state = ModelState["OldPassword"];
                if (state != null)
                {
                    state.Errors.Clear();
                }

                if (ModelState.IsValid)
                {
                    try
                    {
                        WebSecurity.CreateAccount(User.Identity.Name, model.NewPassword);
                        return RedirectToAction("Manage", new { Message = ManageMessageId.SetPasswordSuccess });
                    }
                    catch (Exception)
                    {
                        ModelState.AddModelError("", String.Format("Unable to create local account. An account with the name \"{0}\" may already exist.", User.Identity.Name));
                    }
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // POST: /Account/ExternalLogin

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            return new ExternalLoginResult(provider, Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/ExternalLoginCallback

        [AllowAnonymous]
        public ActionResult ExternalLoginCallback(string returnUrl)
        {
            AuthenticationResult result = OAuthWebSecurity.VerifyAuthentication(Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
            if (!result.IsSuccessful)
            {
                return RedirectToAction("ExternalLoginFailure");
            }

            if (OAuthWebSecurity.Login(result.Provider, result.ProviderUserId, createPersistentCookie: false))
            {
                return RedirectToLocal(returnUrl);
            }

            if (User.Identity.IsAuthenticated)
            {
                // If the current user is logged in add the new account
                OAuthWebSecurity.CreateOrUpdateAccount(result.Provider, result.ProviderUserId, User.Identity.Name);
                return RedirectToLocal(returnUrl);
            }
            else
            {
                // User is new, ask for their desired membership name
                string loginData = OAuthWebSecurity.SerializeProviderUserId(result.Provider, result.ProviderUserId);
                ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(result.Provider).DisplayName;
                ViewBag.ReturnUrl = returnUrl;
                return View("ExternalLoginConfirmation", new RegisterExternalLoginModel { UserName = result.UserName, ExternalLoginData = loginData });
            }
        }

        //
        // POST: /Account/ExternalLoginConfirmation

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLoginConfirmation(RegisterExternalLoginModel model, string returnUrl)
        {
            string provider = null;
            string providerUserId = null;

            if (User.Identity.IsAuthenticated || !OAuthWebSecurity.TryDeserializeProviderUserId(model.ExternalLoginData, out provider, out providerUserId))
            {
                return RedirectToAction("Manage");
            }

            if (ModelState.IsValid)
            {
                // Insert a new user into the database
                using (OziBazaarEntities db = new OziBazaarEntities())
                {
                    UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.ToLower() == model.UserName.ToLower());
                    // Check if user already exists
                    if (user == null)
                    {
                        // Insert name into the profile table
                        db.UserProfiles.Add(new UserProfile { UserName = model.UserName });
                        db.SaveChanges();

                        OAuthWebSecurity.CreateOrUpdateAccount(provider, providerUserId, model.UserName);
                        OAuthWebSecurity.Login(provider, providerUserId, createPersistentCookie: false);

                        return RedirectToLocal(returnUrl);
                    }
                    else
                    {
                        ModelState.AddModelError("UserName", "User name already exists. Please enter a different user name.");
                    }
                }
            }

            ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(provider).DisplayName;
            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        //
        // GET: /Account/ExternalLoginFailure

        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        [AllowAnonymous]
        [ChildActionOnly]
        public ActionResult ExternalLoginsList(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return PartialView("_ExternalLoginsListPartial", OAuthWebSecurity.RegisteredClientData);
        }

        [ChildActionOnly]
        public ActionResult RemoveExternalLogins()
        {
            ICollection<OAuthAccount> accounts = OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name);
            List<ExternalLogin> externalLogins = new List<ExternalLogin>();
            foreach (OAuthAccount account in accounts)
            {
                AuthenticationClientData clientData = OAuthWebSecurity.GetOAuthClientData(account.Provider);

                externalLogins.Add(new ExternalLogin
                {
                    Provider = account.Provider,
                    ProviderDisplayName = clientData.DisplayName,
                    ProviderUserId = account.ProviderUserId,
                });
            }

            ViewBag.ShowRemoveButton = externalLogins.Count > 1 || OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            return PartialView("_RemoveExternalLoginsPartial", externalLogins);
        }

        #region Helpers

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home", new { area = "" });
            }
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
        }

        internal class ExternalLoginResult : ActionResult
        {
            public ExternalLoginResult(string provider, string returnUrl)
            {
                Provider = provider;
                ReturnUrl = returnUrl;
            }

            public string Provider { get; private set; }
            public string ReturnUrl { get; private set; }

            public override void ExecuteResult(ControllerContext context)
            {
                OAuthWebSecurity.RequestAuthentication(Provider, ReturnUrl);
            }
        }

        private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        {
            // See http://go.microsoft.com/fwlink/?LinkID=177550 for
            // a full list of status codes.
            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "User name already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A user name for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }

        private bool ValidateUser(string userName, string password)
        {
            var membership = (SimpleMembershipProvider)Membership.Provider;
            return membership.ValidateUser(userName, password);
        }

        #endregion
    }
}
