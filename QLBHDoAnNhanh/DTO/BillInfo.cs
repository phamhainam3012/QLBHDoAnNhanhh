using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DTO
{
    class BillInfo
    {
        public BillInfo(int id, int billID, int foodID, int count)
        {
            ID = id;
            BillID = billID;
            FoodID = foodID;
            Count = count;
        }

        public BillInfo(DataRow row)
        {
            ID = (int)row["id"];
            BillID = (int)row["IDBill"];
            FoodID = (int)row["IDfood"];
            Count = (int)row["count"];
        }

        private int id;

        public int ID
        {
            get { return id; }
            set { id = value; }
        }

        private int billID;

        public int BillID
        {
            get { return billID; }
            set { billID = value; }
        }

        private int foodID;

        public int FoodID
        {
            get { return foodID; }
            set { foodID = value; }
        }

        private int count;

        public int Count
        {
            get { return count; }
            set { count = value; }
        }

    }
}
