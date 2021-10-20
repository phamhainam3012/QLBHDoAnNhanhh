using QLBHDoAnNhanh.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DAO
{
    public class TableDAO
    {
        private static TableDAO instance;

        public static TableDAO Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new TableDAO();
                }
                return instance;
            }
            private set { TableDAO instance = value; }
        }

        private TableDAO() { }

        public void SwitchTable(int id1, int id2)
        {
            DataProvider.Instance.ExecuteQuery("USP_SwitchTable @idTable1 , @idTabel2", new object[] { id1, id2 });
        }

        public List<Table> LoadTableList()
        {
            List<Table> tablesList = new List<Table>();

            DataTable data = DataProvider.Instance.ExecuteQuery("usp_GetTableList");

            foreach (DataRow item in data.Rows)
            {
                Table table = new Table(item);
                tablesList.Add(table);
            }

            return tablesList;
        }

        public static int TableWidth = 100;
        public static int TableHeight = 100;
    }
}
