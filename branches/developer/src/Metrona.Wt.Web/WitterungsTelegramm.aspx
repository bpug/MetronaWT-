﻿<%@ Page Language="C#" Async="true" Title="Witterungstelegramm" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WitterungsTelegramm.aspx.cs" Inherits="Metrona.Wt.Web.WitterungsTelegramm" %>
<%@ Register Assembly="Infragistics45.WebUI.UltraWebChart.v14.2, Version=14.2.20142.2146, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<%@ Register Assembly="Infragistics45.WebUI.UltraWebChart.v14.2, Version=14.2.20142.2146, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.UltraChart.Resources.Appearance" tagprefix="igchartprop" %>
<%@ Register Assembly="Infragistics45.WebUI.UltraWebChart.v14.2, Version=14.2.20142.2146, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.UltraChart.Data" tagprefix="igchartdata" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="Scripts/custom/wt.js"></script>

    <div id="loadDialog" class="hidden">
        <div class="center height100per width100per">
            <img class="loadingImg height100per" 
                 src="<%= Page.ResolveUrl("~/img/712.gif") %>"
                 alt="Loading" />
        </div>
    </div>
    
    
    <asp:FormView ID="fwRequest" 
                  runat="server"
                  RenderOuterTable="False"
                  ItemType="Metrona.Wt.Web.Models.CalculateRequestViewModel"
                  SelectMethod="GetCalculateRequest"
                  DefaultMode="Edit"
                  UpdateMethod="Calculate"
                  InsertMethod="Calculate" >
        <EditItemTemplate>
            <div role="form" class="row">
                <div class="col-xs-3">
                    <div class="form-group">
                        <label for="txtDate" class="control-label">Ende Abz. (Stichtag)</label>
                        <asp:DynamicControl ID="txtDate" runat="server" DataField="Date" Mode="Edit" ValidationGroup="vgKlima" />
                        <%--<asp:CompareValidator ID="cvlStartDate" runat="server" ControlToValidate="txtDate"
                                              CssClass="text-danger" Display="Dynamic" ErrorMessage="Geben Sie bitte ein Startdatum ein" Operator="DataTypeCheck"
                                              SetFocusOnError="True" ToolTip="Geben Sie bitte ein Startdatum ein" Type="Date"
                                              ValidationGroup="vgKlima">
                        </asp:CompareValidator>--%>
                    </div>
                </div>
                <div class="col-xs-3">
                    <div class="form-group">
                        <label for="cmbRequestType" class="control-label">Auswahl Region</label>
                        <%--<asp:DynamicControl ID="DynamicControl1" runat="server" DataField="Date" Mode="Edit" ValidationGroup="vgKlima" />--%>
                        <asp:DropDownList ID="cmbRequestType" runat="server" CssClass="form-control chzn-select" ClientIDMode="Static"
                                          SelectMethod="GetRequestTypes"
                                          SelectedValue="<%# BindItem.RequestType %>"  
                                          DataTextField="Text"
                                          DataValueField="Value" />
                    </div>
                </div>
                <div class="col-xs-3" >
                    <div class="form-group" id="PLZ" >
                        <label for="txtPlz" class="control-label">PLZ</label>
                        <asp:TextBox ID="txtPlz" runat="server" CssClass="form-control" placeholder="PLZ"  Text='<%# BindItem.Plz %>'></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtPlz"
                                              CssClass="text-danger" Display="Dynamic" ErrorMessage="Geben Sie bitte ein PLZ ein" Operator="DataTypeCheck"
                                              SetFocusOnError="True" ToolTip="Geben Sie bitte ein PLZ ein" Type="Integer"
                                              ValidationGroup="vgKlima" />
                        <%-- <asp:RequiredFieldValidator ID="rvPlz" runat="server" ControlToValidate="txtPlz" Display="Dynamic"  CssClass="text-danger"
                                            ErrorMessage="Geben Sie bitte ein PLZ ein" ToolTip="Geben Sie bitte ein PLZ ein" ValidationGroup="vgKlima"></asp:RequiredFieldValidator>--%>
                        <%-- <asp:ModelErrorMessage ID="ModelErrorMessage1" runat="server" ModelStateKey="PLZ" AssociatedControlID="txtPlz"
                                       CssClass="text-danger" SetFocusOnError="true" />--%>
                    </div>
                    <div class="form-group" id="Bundesland">
                        <label for="cmbBundesland" class="control-label">Bundesland</label>
                        <asp:DropDownList ID="cmbBundesland" runat="server" 
                                          CssClass="form-control chzn-select"
                                          SelectMethod="GetBundeslands"
                                          SelectedValue="<%# BindItem.BundeslandId %>" 
                                          DataTextField = "Name"
                                          DataValueField = "Id"/>
                    </div>
                </div>
                <div class="col-xs-3">
                    <div class="form-group">
                        <asp:Button ID="btnShowCharts" runat="server" Text="Berechnen" 
                                    CssClass="btn btn-default wt" ValidationGroup="vgKlima" 
                                    CommandName="Update"  />
                    </div>
                </div>
            </div>
        </EditItemTemplate>
    </asp:FormView>
    <asp:UpdatePanel runat="server" id="UpdatePanel1" updatemode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger controlid="fwRequest" eventname="ItemUpdated" />
        </Triggers>
        <ContentTemplate>
            <div class="row">
                <asp:ValidationSummary ID="FormValidationSummary" ClientIDMode="Static" runat="server" ShowModelStateErrors="true" CssClass="text-danger" ValidationGroup="vgKlima" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    
    <div  class="row">
        <asp:UpdatePanel runat="server" id="upJahresbetrachtung" updatemode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger controlid="fwRequest" eventname="ItemUpdated" />
            </Triggers>
            <ContentTemplate>
                <h5>Einleitung</h5>
                <p>
                    Um Heizenergieverbräuche und die damit verbundenen Kosten beurteilen zu können muss die Witterung während der Erfassungsperiode als bedeutsamer Einflussfaktor berücksichtigt werden. Dabei sind sowohl starke regionale Unterschiede als auch Unterschiede im zeitlichen Verlauf von einer Heizperiode zur anderen möglich. 
                    Mit dem Witterungstelegramm erhalten Sie Informationen zum ortsgenauen Klimaverlauf  über mehrere Jahre bis hin zu tagesgenauen Temperaturwerten. 
                    Die Auswahl des Abrechnungszeitraums und der Region welche Sie betrachten möchten können Sie ganz individuell vornehmen.
                </p>
                <%--<strong>Hinweis:</strong>
                <p>
                    Der gewählte Zeitraum wird mit den Vorjahreszeiträumen und dem Langzeitmittel verglichen. 
                    Alle Angaben sind immer konkret bezogen auf die durch Sie getroffene Auswahl (Ende Abrechnungszeitraum und Region). 
                    Betrachtet werden immer die Heizperioden der ganzjährigen Abrechnungszeiträume.
                </p>--%>

                <asp:Panel ID="pnlJahresbetrachtung" runat="server" Visible="False">
                    <asp:Label ID="lblChartVergleichJahrTitle" runat="server" CssClass="h4 chart-title" />
                    <asp:Panel ID="pnlVergleichJahrChart" runat="server" />
                    <div>
                        <p>
                            <asp:Label ID="lblVorjahrBedarf" runat="server"  /> 
                        </p>
                        <p>
                            <asp:Label ID="lblLGTZBedarf" runat="server"  />
                        </p>
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel >

        <asp:UpdatePanel runat="server" id="upMonatsBetrachtung" updatemode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger controlid="fwRequest" eventname="ItemUpdated" />
            </Triggers>
            <ContentTemplate>
                <asp:Panel ID="pnlRelativeVerteilungJahr" runat="server" Visible="False">
                    <asp:Label ID="lblChartRelativeVerteilungJahrTitle" runat="server" CssClass="h4 chart-title" />
                    <asp:Panel ID="pnlMonatssbetrachtungChart" runat="server" />
                    
                    <h5>Erläuterung</h5>
                    <p>
                        Das Langzeitmittel stellt die Nulllinie dar.
                    </p>
                    <p>
                        Negativer Prozentwert (Balken zeigt nach unten) in dem jeweiligen Monat des Vorjahres / Aktuellen Jahres war es kälter als im gleichen Monats des Langzeitmittels.
                    </p>
                    <p>
                        Positiver Prozentwert (Balken zeigt nach oben) in dem jeweiligen Monat des Vorjahres / Aktuellen Jahres war es wärmer als im gleichen Monats des Langzeitmittels.
                    </p>
                    <p>
                        <h5>Beispiel</h5>
                        Für die gewählte Region war es - bezogen auf das Langzeitmittel im Monat <asp:Label ID="lblMonatBedarf" runat="server"  />
                        <ul style="margin: 0px 10px;">
                            <li>
                                <asp:Label ID="lblVorjahrBedarf2" runat="server"  />
                            </li>
                            <li>
                                <asp:Label ID="lblLGTZBedarf2" runat="server"  />
                            </li>
                        </ul>
                    </p>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel >

        <asp:UpdatePanel runat="server" id="upTemperatur" updatemode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger controlid="fwRequest" eventname="ItemUpdated" />
               
            </Triggers>
            <ContentTemplate>
                <asp:Panel ID="pnlChartTemperatur" runat="server" Visible="False">
                    <asp:Label ID="lblChartTemperaturTitle" runat="server" CssClass="h4 chart-title" />
                    <igchart:UltraChart ID="ChartTemperatur" runat="server" OnChartDataClicked="ChartOnChartDataClicked" Version="14.2" >
                        <Effects>
                            <Effects>
                                <igchartprop:GradientEffect />
                            </Effects>
                        </Effects>
                        <ColorModel AlphaLevel="150" ColorBegin="Pink" ColorEnd="DarkRed" ModelStyle="CustomLinear">
                        </ColorModel>
                        <Axis>
                            <PE ElementType="None" Fill="Cornsilk" />
                            <X LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="True">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="True">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </X>
                            <Y LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="True">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Center" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </Y>
                            <Y2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Center" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </Y2>
                            <X2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="False">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </X2>
                            <Z LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </Z>
                            <Z2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                    <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center" Visible="True">
                                        <Layout Behavior="Auto">
                                        </Layout>
                                    </SeriesLabels>
                                    <Layout Behavior="Auto">
                                    </Layout>
                                </Labels>
                            </Z2>
                        </Axis>
                    </igchart:UltraChart>
                    <asp:Button ID="btnDrillBack" runat="server" Text="Jahresansicht" Visible="False" CssClass="btn btn-default" onclick="OnBtnDrillBackClick" />
                    <%--<asp:Panel ID="pnlChartTemperaturChart" runat="server" />--%>
                </asp:Panel> 
            </ContentTemplate>
        </asp:UpdatePanel>
        
        <asp:UpdatePanel runat="server" id="upDescription" updatemode="Conditional" > 
            <Triggers>
                <asp:AsyncPostBackTrigger controlid="fwRequest" eventname="ItemUpdated" />
               <%-- <asp:PostBackTrigger ControlID="btnPrintPDF"/>--%>
               <%-- <asp:PostBackTrigger ControlID="btnExport"/>--%>
            </Triggers>
            <ContentTemplate> 
                <asp:Panel ID="pnlWDS" runat="server"  Visible="False" CssClass="wt-description">
                    <asp:Panel runat="server" ID="pnlReport">
                        <table style="width: 100%">
                            <tr>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="Berechnungsgrundlage" Font-Bold="True" ></asp:Label>&nbsp;
                                    <asp:ImageButton ID="btnExportExecl" runat="server" ClientIDMode="Static" ImageUrl="~/img/excel.gif" ToolTip="Excel export" />
                                </td>
                                <td style="width: 100px;">
                                </td>
                                <td style="vertical-align: middle">
                                    <asp:Label ID="Label3" runat="server" Text="PDF" Font-Bold="True" ></asp:Label>&nbsp;
                                    <asp:ImageButton ID="btnPrintPDF" runat="server" ClientIDMode="Static" ImageUrl="~/img/pdf.gif" ToolTip="PDF" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div>
                        <hr />
                        <h4>Erläuterungen</h4>
                        <p>
                            <h5><sup>1</sup> Langzeitmittel:</h5>
                            Beim Langzeitmittel werden die seit 1993 vorliegenden Klimadaten der gewählten Region in Abhängigkeit des jeweiligen Abrechnungszeitraums zugrunde gelegt.
                        </p>
                        <p>
                            <h5><sup>2</sup> Tagesmitteltemperatur:</h5> 
                            Die Tagesmitteltemperatur ist die Durchschnittstemperatur im Zeitraum von 0 bis 0 Uhr des jeweiligen Tages.
                        </p>
                        <p>
                            <h5><sup>3</sup> Heizgrenztemperatur:</h5> 
                            Die Heizgrenztemperatur liegt bei 15 ° C. Bei Unterschreitung von 15 ° C wird normativ davon ausgegangen, dass die Heizanlage in Betrieb genommen werden soll.
                        </p>
                        <p>
                            <h5><sup>4</sup> Gradtagszahlen:</h5>
                            Klimatische Grundlage für die Ermittlung sind jeweils die so genannten Gradtagszahlen der gewählten Region in Abhängigkeit des jeweiligen 
                            Abrechnungszeitraums. Diese dient zur Normierung (Witterungsbereinigung) von Heizenergieverbräuchen.
                            Die Gradtagzahl wird errechnet, sobald die Außentemperatur unter der Heizgrenztemperatur von 15 ° C liegt. 
                            Diese ist nach VDI 2067 die Summe aus den Differenzen einer angenommenen Rauminnentemperatur von 20 °C und dem jeweiligen Tagesmittelwert der 
                            Außentemperatur über alle Tage eines Zeitraums, an denen diese unter der Heizgrenztemperatur des Gebäudes liegt.
                        </p>
                    </div>
                </asp:Panel>     
            </ContentTemplate>
        </asp:UpdatePanel>

        <%--<ig:WebExcelExporter ID="WebExcelExporter1" runat="server"></ig:WebExcelExporter>--%>
    </div>
</asp:Content>