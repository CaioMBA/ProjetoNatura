using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Models
{
    public class ProductInfo
    {
        public long? PRODUCTID { get; set; }
        public string? NAME { get; set; }
        public string? TYPE { get; set; }
        public DateTime? DATEINSERT { get; set; }
        public double? VALUE { get; set; }
        public string? PHOTO { get; set; }
    }
}
