using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PetZoneApp.Models;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;

namespace PetZoneApp
{
    public partial class Reportes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFechaFin.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtFechaInicio.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
            }
        }

        protected void btnGenerar_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            int tipo = int.Parse(cboTipoReporte.SelectedValue);
            string nombreReporte = "Reporte";

            using (var db = new PetZoneEntities())
            {
                if (tipo == 1) // VENTAS
                {
                    nombreReporte = "Reporte_Ventas";
                    DateTime ini = DateTime.Parse(txtFechaInicio.Text);
                    DateTime fin = DateTime.Parse(txtFechaFin.Text).AddDays(1);

                    var ventas = db.Ordenes
                                   .Where(o => o.Fecha >= ini && o.Fecha < fin)
                                   .Select(o => new
                                   {
                                       ID = o.OrdenId,
                                       Fecha = o.Fecha,
                                       Cliente = o.Clientes.Nombre,
                                       Total = o.Total,
                                       Estado = o.Estado
                                   }).ToList();

                    dt.Columns.Add("ID Orden");
                    dt.Columns.Add("Fecha");
                    dt.Columns.Add("Cliente");
                    dt.Columns.Add("Total (S/)");
                    dt.Columns.Add("Estado");

                    foreach (var v in ventas)
                    {
                        dt.Rows.Add(v.ID, v.Fecha.ToString("dd/MM/yyyy HH:mm"), v.Cliente, v.Total, v.Estado);
                    }
                }
                else if (tipo == 2) // STOCK
                {
                    nombreReporte = "Reporte_Stock";
                    var productos = db.Productos
                                      .Select(p => new { p.Nombre, p.Precio, p.Stock }).ToList();

                    dt.Columns.Add("Producto");
                    dt.Columns.Add("Precio Unitario");
                    dt.Columns.Add("Stock Actual");

                    foreach (var p in productos)
                    {
                        dt.Rows.Add(p.Nombre, p.Precio, p.Stock);
                    }
                }
                else if (tipo == 3) // CLIENTES
                {
                    nombreReporte = "Reporte_Clientes";
                    var clientes = db.Clientes.ToList();
                    dt.Columns.Add("Nombre");
                    dt.Columns.Add("Documento");
                    dt.Columns.Add("Email");
                    dt.Columns.Add("Teléfono");

                    foreach (var c in clientes)
                    {
                        dt.Rows.Add(c.Nombre, c.Documento, c.Email, c.Telefono);
                    }
                }
            }

            if (dt.Rows.Count > 0)
            {
                ExportarExcel(dt, nombreReporte);
            }
            else
            {
                lblMensaje.Text = $"No se encontraron datos para '{nombreReporte}'.";
                lblMensaje.Visible = true;
            }
        }

        private void ExportarExcel(DataTable dt, string nombreArchivo)
        {
            IWorkbook workbook = new XSSFWorkbook();
            ISheet sheet = workbook.CreateSheet("Datos");

            // Estilo de cabecera
            ICellStyle headerStyle = workbook.CreateCellStyle();
            IFont headerFont = workbook.CreateFont();
            headerFont.IsBold = true;
            headerStyle.SetFont(headerFont);

            // CORRECCIÓN DEL ERROR DE AMBIGÜEDAD:
            // Usamos 'NPOI.SS.UserModel.BorderStyle' explícitamente
            headerStyle.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;

            // Llenar Cabecera
            IRow headerRow = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = headerRow.CreateCell(i);
                cell.SetCellValue(dt.Columns[i].ColumnName);
                cell.CellStyle = headerStyle;
            }

            // Llenar Datos
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row = sheet.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    string valor = dt.Rows[i][j] != null ? dt.Rows[i][j].ToString() : "";
                    row.CreateCell(j).SetCellValue(valor);
                }
            }

            for (int i = 0; i < dt.Columns.Count; i++) sheet.AutoSizeColumn(i);

            // Descarga segura para evitar archivo dañado
            using (MemoryStream exportData = new MemoryStream())
            {
                workbook.Write(exportData);
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", $"attachment;filename={nombreArchivo}_{DateTime.Now:HHmmss}.xlsx");
                Response.BinaryWrite(exportData.ToArray());

                // Método seguro para finalizar la respuesta sin excepciones ni corrupción
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
    }
}