using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DTO
{
    public class Table
    {
        private int iD;

        public int ID
        {
            get { return iD; }
            set { iD = value; }
        }

        private string name;

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        private string status;

        public string Status
        {
            get { return status; }
            set { status = value; }
        }

        public Table(int id, string name, string status)
        {
            ID = id;
            Name = name;
            Status = status;
        }

        public Table(DataRow row)
        {
            ID = (int)row["id"];
            Name = row["name"].ToString();
            Status = row["status"].ToString();
        }
    }
}
