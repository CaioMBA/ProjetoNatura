using Domain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Interfaces
{
    public interface IUserService
    {
        public DefaultResponseModel? PostRegisterUser(CreateUserRequestModel Body);
        public DefaultResponseModel? ValidateUser(ValidateUserRequestModel obj);
        public DefaultResponseModel? PutChangePassword(string? LoginCredential, string? OldPassword, string? NewPassword, bool ForgotPassword = false);
        public DefaultResponseModel? PutChangePhoto(string? LoginCredential, string? NewPhoto);
        public DefaultResponseModel? PutChangeUserDetails(ChangeUserDetailsModel Body);
    }
}
