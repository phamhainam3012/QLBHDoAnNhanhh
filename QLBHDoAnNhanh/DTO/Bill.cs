using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DTO
{
    public class Bill
    {
        public Bill(int id, DateTime? dateCheckIn, DateTime? dateCheckOut, int status, int discount = 0)
        {
            ID = id;
            DateCheckIn = this.dateCheckIn;
            DateCheckOut = this.dateCheckOut;
            Status = status;
            Discount = discount;
        }

        public Bill(DataRow row)
        {
            ID = (int)row["id"];
            DateCheckIn = (DateTime?)row["DateCheckIn"];

            var dateCheckOutTemp = row["DateCheckOut"];
            if (dateCheckOutTemp.ToString() != "")
                DateCheckOut = (DateTime?)dateCheckOutTemp;

            Status = (int)row["status"];
            if (row["discount"].ToString() != "")
                Discount = (int)row["discount"];
        }

        private int status;

        public int Status
        {
            get { return status; }
            set { status = value; }
        }

        private DateTime? dateCheckOut;

        public DateTime? DateCheckOut
        {
            get { return dateCheckOut; }
            set { dateCheckOut = value; }
        }

        private DateTime? dateCheckIn;

        public DateTime? DateCheckIn
        {
            get { return dateCheckIn; }
            set { dateCheckIn = value; }
        }

        private int id;

        public int ID
        {
            get { return id; }
            set { id = value; }
        }

        private int discount;

        public int Discount
        {
            get { return discount; }
            set { discount = value; }
        }

    }
}
