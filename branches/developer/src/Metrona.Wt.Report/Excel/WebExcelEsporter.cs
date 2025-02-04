﻿//  --------------------------------------------------------------------------------------------------------------------
//  <copyright file="WebExcelEsporterEx.cs" company="ip-connect GmbH">
//    Copyright (c) ip-connect GmbH. All rights reserved.
//  </copyright>
//  --------------------------------------------------------------------------------------------------------------------

namespace Metrona.Wt.Reports.Excel
{
    using Infragistics.Documents.Excel;
    using Infragistics.Web.UI.GridControls;

    public class WebExcelEsporter : WebExcelExporter
    {
        public virtual void Export(Worksheet worksheet, params WebDataGridExport[] grids)
        {
            //this._currentWorkbookFormat = worksheet.Workbook.CurrentFormat;
            var e = new ExcelExportingEventArgs(worksheet, grids[0].RowOffset, grids[0].ColumnOffset, 0);
            this.OnExporting(e);
            if (e.Cancel)
            {
                return;
            }
            int currentRowIndex = e.CurrentRowIndex;
            foreach (var grid in grids)
            {
                int rowExportIndex;
                int rowIndex = rowExportIndex = grid.RowOffset;
                //this.InitStyleSheet(grid.Grid.RunBot);
                this.ExportGrid(grid.Grid, worksheet, ref rowIndex, ref rowExportIndex, grid.ColumnOffset, 0);
                //this._currentStyleSheet = (StyleSheet)null;
                //currentRowIndex += this._gridsRowSpacing;
            }
            //this.OnExported(new ExcelExportedEventArgs(worksheet, currentRowIndex, columnOffset, 0));
            this.DownloadWorkbook(worksheet.Workbook);
        }
    }

    
}