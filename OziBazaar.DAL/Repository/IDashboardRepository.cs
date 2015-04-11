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
        List<UserProductViewModel> GetUserProducts(int UserID, int page = 1, int pageSize = 10);
        List<UserProductViewModel> GetWishListProducts(int UserID, int page = 1, int pageSize = 10);
    }
}
