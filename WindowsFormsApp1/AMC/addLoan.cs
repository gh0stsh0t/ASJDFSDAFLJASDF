﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using MySql.Data.MySqlClient;


namespace AMC
{
    public partial class AddLoan : Form
    {
        public int memid;
        private DatabaseConn _addloanconn;
        public DataTable loanmems;
        public MySqlConnection conn;
        public string memname;
        public int comakercount;
        private Form popup;
        private MainForm reftomain;
        private double intrate = 5.00; //DO THIS SHIT GUYS      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


        public AddLoan(int x, MainForm parents)
        {
            InitializeComponent();
            memid = x;
            cbLoan.SelectedIndex = 0;
            cbRequest.SelectedIndex = 0;
            _addloanconn = new DatabaseConn();
            conn = new MySqlConnection("Server=localhost;Database=amc;Uid=root;Pwd=root;");
            tbInterest.Text = intrate.ToString();
            this.ActiveControl = label3;
            reftomain = parents;
        }

        private void AddLoan_Load(object sender, EventArgs e)
        {
        }

        public void namerfrsh()
        {
            name.Text = memname;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void cbBorrower_KeyDown(object sender, KeyEventArgs e)
        {
           
        }

        private void cbBorrower_Leave(object sender, EventArgs e)
        {
           
        }

        private void breaker()
        {
            try
            {
                popup.Close();
                popup.Dispose();
            }
            catch
            {
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            breaker();
            popup = new addLoanM(this);
            popup.ShowDialog();
        }

        private void cbLoan_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (validation())
            {
                comakercnt();
                try
                {
                    conn.Open();
                    string[] loanStrings = {"member_id", memid.ToString(), "loan_type", cbLoan.SelectedIndex.ToString(), "request_type"
                            , cbRequest.SelectedIndex.ToString(), "orig_amount", tbAmount.Text, "term", tbTerm.Text.ToString()
                            , "interest_rate", tbInterest.Text, "purpose", tbPurpose.Text, "loan_status", "0", "outstanding_balance", tbAmount.Text};
                    _addloanconn = new DatabaseConn();
                    _addloanconn.Insert("loans", loanStrings)
                                .GetQueryData();
                    string id = _addloanconn.lastID();
                    //MessageBox.Show(id);
                    string[] comakers = { "loan_id", id, "name", tbName1.Text, "address", tbAddress1.Text, "company_name", tbCompany1.Text
                        , "position", tbPosition1.Text};
                    _addloanconn.Insert("comakers", comakers);
                    if (comakercount == 2)
                    {
                        string[] comakers2 = { "loan_id", id, "name", tbName2.Text, "address", tbAddress2.Text, "company_name", tbCompany2.Text
                            , "position", tbPosition2.Text};
                        _addloanconn.Insert("comakers", comakers2);
                    }
                    MessageBox.Show("Success");
                    reftomain.innerChild(new AddLoan(-1, reftomain));
                    conn.Close();
                }
                catch (Exception ee)
                {
                    ////MessageBox.Show(ee.ToString());
                    conn.Close();
                }
            } 
        }

        public void comakercnt()
        {
            if (tbName2.Text == "")
                comakercount = 1;
            else
                comakercount = 2; 
        }

        private bool validation()
        {
            if (memid == -1)
            {
                MessageBox.Show("Please select a member.");
                return false;
            }
            else if (tbAmount.Text == "")
            {
                MessageBox.Show("Please input an amount.");
                return false;
            }
            else if (tbInterest.Text == "")
            {
                MessageBox.Show("Please input an interest rate.");
                return false;
            }
            else if (tbAddress1.Text == "" || tbCompany1.Text == "" || tbName1.Text == "" || tbPosition1.Text == "")
            {
                MessageBox.Show("Please input details for Comaker 1.");
                return false;
            }
            else if (co2check())
            {
                MessageBox.Show("Please either input complete details for Comaker 2 or clear the text.");
                return false;
            }
            else
                return true;   
        }

        private bool co2check()
        {
            if ((tbAddress2.Text == "" || tbCompany2.Text == "" || tbName2.Text == "" || tbPosition2.Text == "") 
                && (tbAddress2.Text != "" || tbCompany2.Text != "" || tbName2.Text != "" || tbPosition2.Text != ""))
                return true;
            return false;
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            name.Text = "";
            memid = -1;
            cbLoan.SelectedIndex = 0;
            cbRequest.SelectedIndex = 0;
            tbAddress1.Clear();
            tbAddress2.Clear();
            tbAmount.Clear();
            tbCompany1.Clear();
            tbCompany2.Clear();
            tbInterest.Clear();
            tbName1.Clear();
            tbName2.Clear();
            tbPosition1.Clear();
            tbPosition2.Clear();
            tbPurpose.Clear();
            tbTerm.Clear();
        }

        private void tbAmount_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!(char.IsDigit(e.KeyChar) || e.KeyChar == (char)Keys.Back || e.KeyChar == '.'))
            { e.Handled = true; }
            TextBox txtDecimal = sender as TextBox;
            if ((e.KeyChar == '.') && ((sender as TextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }
        public static Boolean isNum(string strToCheck)
        {
            Regex rg = new Regex(@"^[0-9]+\.?[0-9]{1,2}$");
            return rg.IsMatch(strToCheck);
        }

        private void tbInterest_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!(char.IsDigit(e.KeyChar) || e.KeyChar == (char)Keys.Back || e.KeyChar == '.'))
            { e.Handled = true; }
            TextBox txtDecimal = sender as TextBox;
            if ((e.KeyChar == '.') && ((sender as TextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }
        public static Boolean isAlphaNum(string strToCheck)
        {
            Regex rg = new Regex(@"^([a-zA-Z0-9]+[\s,\-\.]?)+$");
            return rg.IsMatch(strToCheck);
        }

        private void ctrlLeave(TextBox txtbox)
        {
            bool flag = (txtbox.Text == "");
            if (!flag)
            {
                if (!isAlphaNum(txtbox.Text))
                {
                    MessageBox.Show("Please make sure this field contains the valid format");
                    txtbox.Focus();
                }
            }
        }

        private void tbPurpose_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbPurpose);
        }

        private void tbName1_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbName1);
        }

        private void tbAddress1_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbAddress1);
        }

        private void tbCompany1_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbCompany1);
        }

        private void tbPosition1_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbPosition1);
        }

        private void tbName2_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbName2);
        }

        private void tbAddress2_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbAddress2);
        }

        private void tbCompany2_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbCompany2);
        }

        private void tbPosition2_Leave(object sender, EventArgs e)
        {
            ctrlLeave(tbPosition2);
        }

        private void tbAmount_Leave(object sender, EventArgs e)
        {
            if(!isNum(tbAmount.Text))
            {
                MessageBox.Show("Please make sure the amount contains no special characters and has no more than 2 decimal points.");
                tbAmount.Focus();
            }
        }

        private void tbInterest_Leave(object sender, EventArgs e)
        {
            if (!isNum(tbInterest.Text))
            {
                MessageBox.Show("Please make sure the interest contains no special characters and has no more than 2 decimal points.");
                tbInterest.Focus();
            }
            else if (float.Parse(tbInterest.Text) >= 100)
            {
                MessageBox.Show("Please make sure the interest is less than or equal to 100%.");
                tbInterest.Focus();
            }
        }

        private void tbTerm_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!(char.IsDigit(e.KeyChar) || e.KeyChar == (char)Keys.Back))
                e.Handled = true;
           
        }

        private void tbTerm_Leave(object sender, EventArgs e)
        {
            if (!isNum(tbTerm.Text))
            {
                MessageBox.Show("Please make sure the term is a number.");
                tbTerm.Focus();
            }
            else if (int.Parse(tbTerm.Text) <= 0 || int.Parse(tbTerm.Text) > 730)
            {
                MessageBox.Show("Please make sure the term is between 1 day and 730 days (2 years).");
                tbTerm.Focus();
            }
        }
    }
   
}