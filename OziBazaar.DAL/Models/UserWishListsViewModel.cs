using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.DAL.Models
{
    public class UserWishListsViewModel
    {
        public List<UserWishListViewModel> UserWishListsViewModelList { get; set; }
        public PagingInfo PagingInfo { get; set; } 
    }
}
