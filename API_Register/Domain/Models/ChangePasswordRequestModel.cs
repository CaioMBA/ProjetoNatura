using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class ChangePasswordRequestModel
    {
        public string? P_LOGINCREDENTIAL { get; set; }
        public string? P_OLDPASSWORD { get; set; }
        public string? P_NEWPASSWORD { get; set; }
    }
}
