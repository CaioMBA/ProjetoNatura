using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class CreateUserRequestModel
    {
        public string? P_USERNAME { get; set; }
        public string? P_USERLOGIN { get; set; }
        public string? P_PASSWORD { get; set; }

        [Required(ErrorMessage = "CPF|CNPJ é um campo OBRIGATÓRIO, por favor insira-o!")]
        public string? P_CPF_CNPJ { get; set; }

        [Required(ErrorMessage = "Data de Nascimento é um campo OBRIGATÓRIO, por favor insira-a!")]
        public DateTime? P_BIRTHDAY { get; set; }

        [Required(ErrorMessage = "E-mail é um campo OBRIGATÓRIO, por favor insira-o!")]
        public string? P_EMAIL { get; set; }
        public string? P_PHONE { get; set; }
        public string? P_TYPE { get; set; }
        public string? P_PHOTO { get; set; }
    }
}
