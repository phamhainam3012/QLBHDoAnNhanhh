using QLBHDoAnNhanh.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBHDoAnNhanh.DAO
{
    class MenuDAO
    {
        private static MenuDAO instance;

        public static MenuDAO Instance
        {
            get { if (instance == null) instance = new MenuDAO(); return instance; }
            set { instance = value; }
        }

        private MenuDAO() { }

        public List<DTO.Menu> GetListMenuByTable(int id)
        {
            List<DTO.Menu> listMenu = new List<DTO.Menu>();

            string query = $"SELECT f.name, bi.count, f.price, f.price*bi.count AS totalPrice FROM dbo.BillInfo bi, dbo.Bill b, dbo.Food f WHERE bi.idBill = b.id AND bi.idFood = f.id AND b.status = 0 and b.idTable = {id}";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                DTO.Menu menu = new DTO.Menu(item);
                listMenu.Add(menu);
            }

            return listMenu;
        }
    }
}
