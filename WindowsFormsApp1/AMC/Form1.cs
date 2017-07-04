﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AMC
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void button4_Click(object sender, EventArgs e)
        {

        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            sidebarPanelCBU.Visible = false;
            sidebarPanelLoans.Visible = false;
            sidebarPanelSavings.Visible = false;
            sidebarPanelMembers.Visible = false;
        }

        private void sidebarBtnMembers_Click(object sender, EventArgs e)
        {
            if(sidebarPanelMembers.Visible == false)
                sidebarPanelMembers.Visible = true;
            else
                sidebarPanelMembers.Visible = false;

            sidebarPanelCBU.Visible = false;
            sidebarPanelLoans.Visible = false;
            sidebarPanelSavings.Visible = false;
        }

        private void sidebarBtnLoans_Click(object sender, EventArgs e)
        {
            if (sidebarPanelLoans.Visible == false)
                sidebarPanelLoans.Visible = true;
            else
                sidebarPanelLoans.Visible = false;

            sidebarPanelCBU.Visible = false;
            sidebarPanelMembers.Visible = false;
            sidebarPanelSavings.Visible = false;
        }

        private void sidebarBtnSavings_Click(object sender, EventArgs e)
        {
            if (sidebarPanelSavings.Visible == false)
                sidebarPanelSavings.Visible = true;
            else
                sidebarPanelSavings.Visible = false;

            sidebarPanelCBU.Visible = false;
            sidebarPanelMembers.Visible = false;
            sidebarPanelLoans.Visible = false;
        }

        private void sidebarBtnCBU_Click(object sender, EventArgs e)
        {
            if (sidebarPanelCBU.Visible == false)
                sidebarPanelCBU.Visible = true;
            else
                sidebarPanelCBU.Visible = false;

            sidebarPanelSavings.Visible = false;
            sidebarPanelMembers.Visible = false;
            sidebarPanelLoans.Visible = false;
        }
    }
}