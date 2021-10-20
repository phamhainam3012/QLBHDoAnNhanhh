using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBHDoAnNhanh.DAO
{
    public class DataProvider
    {
        private static DataProvider instance;

        public static DataProvider Instance
        {
            get { if (instance == null) instance = new DataProvider(); return DataProvider.instance; }
            private set { DataProvider instance = value; }
        }

        private DataProvider()
        {

        }

        private string _connectionString = @"Data Source=.\SQLExpress; Initial Catalog=QLBHDoAnNhanh; Integrated Security=True";

        // cac phuong thuc co kieu tra ve DataTable duoc dung de do du lieu len DataGridView
        public DataTable ExecuteQuery(string query, object[] parameters = null)
        {
            // neu truy van khong thanh cong se tra ve mang rong
            var dataTable = new DataTable();

            try
            {
                // cau truc using se giup tu Close(connection)
                using (var connection = new SqlConnection(_connectionString))
                {
                    using (var command = new SqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            // lay danh sach tham so o cau truy van. VD: @username @password
                            string[] listPara = query.Split(' ');

                            int i = 0;

                            foreach (string item in listPara)
                            {
                                if (item.Contains('@'))
                                {
                                    // VD: AddWithValue('@username', 'admin')
                                    command.Parameters.AddWithValue(item, parameters[i]);

                                    i++;
                                }
                            }
                        }

                        // thanh phan trung gian giua Connect va Disconnect
                        // thanh phan DataAdapter lam viec voi thanh phan Connect
                        var adapter = new SqlDataAdapter(command);

                        connection.Open();

                        // thanh phan DataAdapter lam viec voi thanh phan Disconnect
                        adapter.Fill(dataTable);
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            return dataTable;
        }

        public int ExecuteNonQuery(string query, object[] parameters = null)
        {
            int data = 0;

            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    using (var command = new SqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            string[] listPara = query.Split(' ');

                            int i = 0;

                            foreach (string item in listPara)
                            {
                                if (item.Contains('@'))
                                {
                                    command.Parameters.AddWithValue(item, parameters[i]);

                                    i++;
                                }
                            }
                        }

                        connection.Open();

                        data = command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            return data;
        }

        public object ExecuteScalar(string query, object[] parameters = null)
        {
            object data = 0;

            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    using (var command = new SqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            string[] listPara = query.Split(' ');

                            int i = 0;

                            foreach (string item in listPara)
                            {
                                if (item.Contains('@'))
                                {
                                    command.Parameters.AddWithValue(item, parameters[i]);

                                    i++;
                                }
                            }
                        }

                        connection.Open();

                        data = command.ExecuteScalar();
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            return data;
        }
    }
}
