using OziBazaar.Web.Areas.UserManagement.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using WebMatrix.WebData;

namespace OziBazaar.Web.App_Start
{
    public static class SecurityConfig
    {
        public static void InitializeComponents()
        {
            WebSecurity.InitializeDatabaseConnection("OziBazaarMembership", "UserProfile", "UserId", "UserName", autoCreateTables: true);
            
            InitializeUsresAndRoles();
        }

        private static void InitializeUsresAndRoles()
        {
            var roles = (SimpleRoleProvider)Roles.Provider;
            var membership = (ExtendedSimpleMembershipProvider)Membership.Provider;
            if (!roles.RoleExists("Admin"))
                roles.CreateRole("Admin");
            if (membership.GetUser("Administrator", false) == null)
                membership.CreateUserAndAccount("Administrator", "P@55word");
            if (!roles.GetRolesForUser("Administrator").Contains("Admin"))
                roles.AddUsersToRoles(new[] { "Administrator" }, new[] { "Admin" });
            if (!roles.RoleExists("Sales"))
                roles.CreateRole("Sales");
            }
        }
}