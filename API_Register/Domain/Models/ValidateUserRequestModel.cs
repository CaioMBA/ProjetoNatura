using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class ValidateUserRequestModel
    {
        [Required(ErrorMessage = "LOGIN USER é um campo OBRIGATÓRIO")]
        public string? P_USERLOGIN { get; set; }
        [Required(ErrorMessage = "SENHA é um campo OBRIGATÓRIO")]
        public string? P_USERPASSWORD { get; set; }
    }
}
