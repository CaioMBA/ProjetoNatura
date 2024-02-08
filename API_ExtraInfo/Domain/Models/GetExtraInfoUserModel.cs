using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class GetExtraInfoUserModel
    {
        public long? USERID { get; set; }
        public string? NAME { get; set; }
        public string? LOGIN { get; set; }
        public string? BIRTHDAY { get; set; }
        public string? CPF_CNPJ { get; set; }
        public string? EMAIL { get; set; }
        public string? PHONE { get; set; }
        public string? PHOTO { get; set; }
    }
}
