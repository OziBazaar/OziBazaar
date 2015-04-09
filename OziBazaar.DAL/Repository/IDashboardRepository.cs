using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OziBazaar.DAL.Models;

namespace OziBazaar.DAL.Repository
{
    public interface IDashboardRepository
    {
        List<UserProductViewModel> GetUserProducts(int UserID);
        List<UserProductViewModel> GetWishListProducts(int UserID);
    }
}
