using AutoMapper;
using DataBaseConnections.OracleSqlDao;
using Domain.Interfaces;
using Domain.Models;
using Domain.Models.Settings;
using Domain.Utils;
using System.Buffers.Text;
using System.Text.RegularExpressions;

namespace Service.Services
{
    public class UserService : IUserService
    {
        private UserDao _dao;
        private IMapper _map;
        private IApiService _api;
        private Utils _utils;

        public UserService(UserDao dao, IMapper map, IApiService api, Utils utils)
        {
            _dao = dao;
            _map = map;
            _api = api;
            _utils = utils;
        }

        public DefaultResponseModel? PutChangePhoto(string? LoginCredential, string? NewPhoto)
        {
            var Response = _dao.ChangePhoto(LoginCredential, NewPhoto);

            return Response;
        }

        public DefaultResponseModel? PutChangeUserDetails(ChangeUserDetailsModel Body)
        {
            DefaultResponseModel? Response = new DefaultResponseModel();
            if (String.IsNullOrEmpty(Body.P_EMAIL) || !ValidateEmail(Body.P_EMAIL))
            {
                Response.MSG = $"E-MAIL:{Body.P_EMAIL} inválido";
                Response.STATUS = "0";
                return Response;
            }
            if (!String.IsNullOrEmpty(Body.P_PHONE) && !ValidatePhone(Body.P_PHONE))
            {
                Response.MSG = $"TELEFONE:{Body.P_PHONE} inválido";
                Response.STATUS = "0";
                return Response;
            }

            Response = _dao.ChangeUserDetails(Body);

            return Response;
        }

        public DefaultResponseModel? PutChangePassword(string? LoginCredential, string? OldPassword, string? NewPassword, bool ForgotPassword = false)
        {
            string? Mail = "";
            string? Phone = "";

            DefaultResponseModel? ResponseDb = new DefaultResponseModel();
            if (ForgotPassword)
            {
                var ObjResponse = _dao.GetPasswordAndMailandPhone(LoginCredential);
                if (ObjResponse == null)
                {
                    ResponseDb.STATUS = "0";
                    ResponseDb.MSG = $"Nenhum usuario encontrado com essa Credencial: {LoginCredential}";
                    return ResponseDb;
                }

                Mail = ObjResponse != null ? ObjResponse.EMAIL : "";
                Phone = ObjResponse != null ? ObjResponse.PHONE : "";
                OldPassword = ObjResponse != null ? ObjResponse.PASSWORD : "";

                NewPassword = GenerateRandomPassword(8, 3);
            }

            OldPassword = !ForgotPassword ? OldPassword.ToBase64() : OldPassword;
            NewPassword = NewPassword.ToBase64();


            ChangePasswordRequestModel? RequestDb = new ChangePasswordRequestModel()
            {
                P_LOGINCREDENTIAL = LoginCredential,
                P_OLDPASSWORD = OldPassword,
                P_NEWPASSWORD = NewPassword
            };

            ResponseDb = _dao.ChangePassword(RequestDb);

            if (ResponseDb != null && ResponseDb.STATUS == "1" && ForgotPassword)
            {
                string MsgToSend = $"Sua senha foi alterada com sucesso, por favor utilizar sua nova senha para logar no aplicativo: {NewPassword.Base64ToString()}";
                List<SendMailModel>? MailsToSend = new List<SendMailModel>()
                {
                    new SendMailModel(){
                            MailDestinations = new List<string>{ Mail },
                            Subject = "Alteração de Senha Concluída!",
                            Msg = MsgToSend
                        }
                };
                List<SendPhoneMsgModel>? PhoneMsgToSend = new List<SendPhoneMsgModel>();

                if (!String.IsNullOrEmpty(Phone))
                {
                    PhoneMsgToSend.Add(new SendPhoneMsgModel()
                    {
                        Phones = new List<string> { Phone },
                        Msg = MsgToSend,
                        Type = "SMS",
                        Name = LoginCredential
                    });
                }


                NotifyRequestModel? ApiBody = new NotifyRequestModel()
                {
                    Mails = MailsToSend,
                    Phones = PhoneMsgToSend
                };

                var ApiSettings = _utils.GetAPI("Notify");

                ApiRequestModel apiRequestModel = new ApiRequestModel()
                {
                    Auth = null,
                    Body = ApiBody.To_UTF8Json(),
                    Headers = null,
                    Url = ApiSettings.Url,
                    TypeRequest = ApiSettings.Type
                };

                var ResponseAPI = _api.APIRequest(apiRequestModel);

                int? ResponseCodeAPI = (int)ResponseAPI.StatusCode;

                if (ResponseCodeAPI != null && ResponseCodeAPI == 200)
                {
                    ResponseDb.MSG = "Sua nova senha foi enviada ao e-mail|telefone cadastrado!";
                }
                else
                {
                    string? ResponseBodyAPI = ResponseAPI.Content.ReadAsStringAsync().Result;

                    ResponseDb.MSG = ResponseBodyAPI;
                }
            }

            return ResponseDb;
        }

        public DefaultResponseModel? PostRegisterUser(CreateUserRequestModel Body)
        {
            DefaultResponseModel? Response = new DefaultResponseModel();

            var PasswordValidation = ValidatePassword(Body.P_PASSWORD);

            if (PasswordValidation.STATUS == "0")
            {
                return PasswordValidation;
            }
            PasswordValidation = null;

            Body.P_PASSWORD = Body.P_PASSWORD.ToBase64();
            Body.P_CPF_CNPJ = Regex.Replace(Body.P_CPF_CNPJ, "[^0-9]", "");



            if (Body.P_CPF_CNPJ.Length <= 14)
            {
                if (!ValidateCNPJ(Body.P_CPF_CNPJ) && !ValidateCPF(Body.P_CPF_CNPJ))
                {
                    Response.MSG = $"CPF|CNPJ:{Body.P_CPF_CNPJ} inválido";
                    Response.STATUS = "0";
                    return Response;
                }
            }
            if (String.IsNullOrEmpty(Body.P_EMAIL) || !ValidateEmail(Body.P_EMAIL))
            {
                Response.MSG = $"E-MAIL:{Body.P_EMAIL} inválido";
                Response.STATUS = "0";
                return Response;
            }
            if (!String.IsNullOrEmpty(Body.P_PHONE) && !ValidatePhone(Body.P_PHONE))
            {
                Response.MSG = $"TELEFONE:{Body.P_PHONE} inválido";
                Response.STATUS = "0";
                return Response;
            }
            if(!String.IsNullOrEmpty(Body.P_PHOTO) && !Body.P_PHOTO.StartsWith("http") && !Body.P_PHOTO.IsBase64String())
            {
                Response.MSG = $"Arquivo ou link inválido para a photo";
                Response.STATUS = "0";
                return Response;
            }
            Body.P_PHONE = Regex.Replace(Body.P_PHONE, @"[()\-\s]", "");

            Response = _dao.RegisterUser(Body);

            Body = null;

            return Response;
        }

        public DefaultResponseModel? ValidateUser(ValidateUserRequestModel obj)
        {
            obj.P_USERPASSWORD = obj.P_USERPASSWORD.ToBase64();

            var Response = _dao.ValidateUser(obj);

            return Response;
        }

        public DefaultResponseModel? ValidatePassword(string? password)
        {
            DefaultResponseModel ValidationObject = new DefaultResponseModel();

            ValidationObject.STATUS = "0";
            ValidationObject.MSG = "";

            if (password.Length < 8)
            {
                ValidationObject.MSG += "|A senha deve ter pelo menos 8 caracteres|";
            }
            if (!Regex.IsMatch(password, @"[a-z]"))
            {
                ValidationObject.MSG += "|A senha deve ter pelo menos 1 letra minúscula|";
            }
            if (!Regex.IsMatch(password, @"[A-Z]"))
            {
                ValidationObject.MSG += "|A senha deve ter pelo menos 1 letra maiúscula|";
            }
            if (!Regex.IsMatch(password, @"[0-9]"))
            {
                ValidationObject.MSG += "|A senha deve ter pelo menos 1 número|";
            }
            if (!Regex.IsMatch(password, @"[!@#$%^&*()\-_+=[\]{}|;:,.<>?]"))
            {
                ValidationObject.MSG += "|A senha deve ter pelo menos 1 caractere especial|";
            }

            if (ValidationObject.MSG.Length == 0)
            {
                ValidationObject.STATUS = "1";
                ValidationObject.MSG += "|Senha válida!|";
            }
            return ValidationObject;
        }

        public bool ValidateCNPJ(string? cnpj)
        {
            string numericCNPJ = Regex.Replace(cnpj, "[^0-9]", "");

            if (numericCNPJ.Length != 14)
            {
                return false;
            }

            int[] multiplier1 = { 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
            int[] multiplier2 = { 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };

            int sum = 0;
            for (int i = 0; i < 12; i++)
            {
                sum += int.Parse(numericCNPJ[i].ToString()) * multiplier1[i];
            }

            int remainder = sum % 11;
            int digit1 = remainder < 2 ? 0 : 11 - remainder;

            sum = 0;
            for (int i = 0; i < 13; i++)
            {
                sum += int.Parse(numericCNPJ[i].ToString()) * multiplier2[i];
            }

            remainder = sum % 11;
            int digit2 = remainder < 2 ? 0 : 11 - remainder;

            return numericCNPJ.EndsWith(digit1.ToString() + digit2.ToString());
        }

        public bool ValidateCPF(string? cpf)
        {
            cpf = new string(cpf.Where(char.IsDigit).ToArray());

            if (cpf.Length != 11)
                return false;

            int[] digits = cpf.Select(c => int.Parse(c.ToString())).ToArray();

            if (digits.All(d => d == digits[0]))
                return false;

            int sum = 0;
            for (int i = 0; i < 9; i++)
                sum += digits[i] * (10 - i);

            int firstVerificationDigit = (sum * 10) % 11;
            if (firstVerificationDigit == 10)
                firstVerificationDigit = 0;

            sum = 0;
            for (int i = 0; i < 10; i++)
                sum += digits[i] * (11 - i);

            int secondVerificationDigit = (sum * 10) % 11;
            if (secondVerificationDigit == 10)
                secondVerificationDigit = 0;

            return firstVerificationDigit == digits[9] && secondVerificationDigit == digits[10];
        }

        public bool ValidateEmail(string? email)
        {
            string pattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            return Regex.IsMatch(email, pattern);
        }

        public bool ValidatePhone(string? Phonenumber)
        {
            Phonenumber = Regex.Replace(Phonenumber, @"[()\-\+]", "");
            if (long.TryParse(Phonenumber, out long number) && Phonenumber.Length <= 20 && Phonenumber.Length >= 8)
            {
                return true;
            }
            return false;
            /*Phonenumber = string.Format("{0:(###) ###-####}", number);

            string pattern = @"^\+\d{1,3}\s?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$";

            return Regex.IsMatch(Phonenumber, pattern);*/
        }

        private string? GenerateRandomPassword(int length, int numberOfNonAlphanumericCharacters)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+-=[]{}|;:,.<>?";
            Random random = new Random();

            char[] password = new char[length];
            for (int i = 0; i < length; i++)
            {
                password[i] = validChars[random.Next(validChars.Length)];
            }

            for (int i = 0; i < numberOfNonAlphanumericCharacters; i++)
            {
                int position = random.Next(length);
                if (Char.IsLetterOrDigit(password[position]))
                {
                    password[position] = validChars[random.Next(52, validChars.Length)];
                }
            }

            return new string(password);
        }
    }
}