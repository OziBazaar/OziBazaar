using OziBazaar.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Web.Infrastructure.Repository
{
    public interface IAccountRepository
    {
        string GetUserNameByEmail(string emailAddress);
        UserProfile GetUserByEmail(string emailAddress);
        UserProfile GetUser(string userToken);
        bool ActivateUser(string userName, string emailAddress);
    }
}
