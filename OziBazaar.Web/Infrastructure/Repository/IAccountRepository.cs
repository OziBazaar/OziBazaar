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
        UserProfile GetUser(string userName);
        bool ActivateUser(string userName, string emailAddress);
    }
}
