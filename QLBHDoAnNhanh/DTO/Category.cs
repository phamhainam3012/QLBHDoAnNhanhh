using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DTO
{
    public class Category
    {
        public Category(int id, string name)
        {
            ID = id;
            Name = name;
        }
        public Category(DataRow row)
        {
            ID = (int)row["id"];
            Name = row["name"].ToString();
        }
        public int ID { get; set; }
        public string Name { get; set; }
    }
}
