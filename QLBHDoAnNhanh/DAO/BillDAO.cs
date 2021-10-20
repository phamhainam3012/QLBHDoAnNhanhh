using QLBHDoAnNhanh.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DAO
{
    class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get { if (instance == null) instance = new BillDAO(); return instance; }
            private set { instance = value; }
        }

        private BillDAO() { }

        /// <summary>
        /// Thanh cong: Bill ID
        /// That bai: -1
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int GetUncheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery($"select * from Bill where IDTable = {id} and status = 0");
            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1;
        }

        public void CheckOut(int id, int discount, float totalPrice)
        {
            string query = $"UPDATE dbo.Bill SET dateCheckOut = GetDate(), totalPrice = {totalPrice}, status = 1, discount = {discount} WHERE id = {id}";
            DataProvider.Instance.ExecuteNonQuery(query);
        }

        public void InsertBill(int id)
        {
            DataProvider.Instance.ExecuteNonQuery("exec usp_insertbill @idtable", new object[] { id });
        }

        public int GetMaxIDBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("SELECT MAX(id) FROM dbo.Bill");
            }
            catch
            {
                return 1;
            }
        }

        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });
        }
    }
}
