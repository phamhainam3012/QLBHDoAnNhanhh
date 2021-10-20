using QLBHDoAnNhanh.DAO;
using QLBHDoAnNhanh.DTO;
using System;
using System.Windows.Forms;

namespace QLBHDoAnNhanh
{
    public partial class fLogin : Form
    {
        public fLogin()
        {
            InitializeComponent();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txbUserName.Text;
            string password = txbPassword.Text;

            if (Login(username, password))
            {
                Account loginAccount = AccountDAO.Instance.GetAccountByUserName(username);
                fTableManager f = new fTableManager(loginAccount);
                this.Hide(); // ẩn form login
                f.ShowDialog(); // hiện form f và ẩn form login (phải xử lý xong form f thì mới quay lại form login), nếu đóng form f thì sẽ hiện form login
                this.Show(); // phải đợi form f xử lý xong mới được hiển thị lên
            }
            else
            {
                MessageBox.Show("Sai tên tài khoản hoặc mật khẩu");
            }
        }

        bool Login(string username, string password)
        {
            return AccountDAO.Instance.Login(username, password);
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit(); // cũng sẽ kích hoạt event FormClosing
        }

        private void fLogin_FormClosing(object sender, FormClosingEventArgs e) // Cứ mỗi khi chương trình muốn thoát
        {
            if (MessageBox.Show("Bạn có thật sự muốn thoát chương trình ?", "Thông báo!", MessageBoxButtons.OKCancel) != DialogResult.OK)
            {
                e.Cancel = true; // không thực thi event này
            }
        }
    }
}
