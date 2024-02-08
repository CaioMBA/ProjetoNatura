using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class ChangeUserDetailsModel
    {
        public string P_CREDENCIAL {  get; set; }
        public string P_LOGIN {  get; set; }
        public string P_EMAIL {  get; set; }
        public string? P_PHONE {  get; set; }
    }
}
