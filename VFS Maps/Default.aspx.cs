using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Configuration;

namespace VFSMaps
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetCountryCodeList()
        {
            try
            {
                VFSMaps.VFSMapsService.Service1 sc = new VFSMaps.VFSMapsService.Service1();
                sc.Url = WebConfigurationManager.AppSettings["WebServiceURL"].ToString();
                string retVal = sc.GetCountryCodeList();
                return retVal;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetCountryMaster()
        {
            try
            {
                VFSMaps.VFSMapsService.Service1 sc = new VFSMaps.VFSMapsService.Service1();
                sc.Url = WebConfigurationManager.AppSettings["WebServiceURL"].ToString();
                string retVal = sc.GetCountryMaster();
                return retVal;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetLocationSummaryJson(int CountryID)
        {
            try
            {
                VFSMaps.VFSMapsService.Service1 sc = new VFSMaps.VFSMapsService.Service1();
                sc.Url = WebConfigurationManager.AppSettings["WebServiceURL"].ToString();
                string retVal = sc.GetLocationSummaryJson(CountryID);
                return retVal;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTATSummary(int CountryID)
        {
            try
            {
                VFSMaps.VFSMapsService.Service1 sc = new VFSMaps.VFSMapsService.Service1();
                sc.Url = WebConfigurationManager.AppSettings["WebServiceURL"].ToString();
                string retVal = sc.GetTATSummary(CountryID);
                return retVal;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetLocationSummaryXml(int CountryID)
        {
            try
            {
                VFSMaps.VFSMapsService.Service1 sc = new VFSMaps.VFSMapsService.Service1();
                sc.Url = WebConfigurationManager.AppSettings["WebServiceURL"].ToString();
                string retVal = sc.GetLocationSummaryXml(CountryID);
                return retVal;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }
    }
}
