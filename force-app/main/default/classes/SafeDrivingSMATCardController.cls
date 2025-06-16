/****************************************************************************************
* @Author       Dru Luce-Edwards
* @Date         March 18, 2016
* @Description  Controller for Driver Safety SMAT Card
* @Revision     
* ***************************************************************************************/
public class SafeDrivingSMATCardController{
    //Class Variables
    public String cObserverName {get;set;}
    public DateTime cTimeDate {get;set;}
    public String cRegion {get;set;}
    public String cLocation {get;set;}
    public String cPreparation {get;set;}
    public String cTravel {get;set;}
    public String cBreakingParking {get;set;}
    public String cArrival {get;set;}
    public String cImprovements {get;set;}
    public String cEmplyeeComments {get;set;}
    public String cAddComments {get;set;}
    public String cSEval {get;set;}
    
    /****************************************************************************************
    * @Author       Dru Luce-Edwards
    * @Date         March 18, 2016
    * @Description  Constructor - initializes data
    * @params       N/A
    * @return       N/A
    *****************************************************************************************/
    public static void SafeDrivingSMATCardController(){
        
    }
    
    
    /****************************************************************************************
    * @Author       Dru Luce-Edwards
    * @Date         March 18, 2016
    * @Description  Returns the list of Safety Options
    * @params       N/A
    * @return       List<SelectOption>
    *****************************************************************************************/
    public List<SelectOption> getSafetyOptions(){
        List<SelectOption> lstSO = new List<SelectOption>();
        lstSO.add(new SelectOption('Safe','Safe'));
        lstSO.add(new SelectOption('Concern','Concern'));
        return lstSO;
    }
    
    /****************************************************************************************
    * @Author       Dru Luce-Edwards
    * @Date         March 18, 2016
    * @Description  Returns the list of Confirmation Options
    * @params       N/A
    * @return       List<SelectOption>
    *****************************************************************************************/
    public List<SelectOption> getConfirmation(){
        List<SelectOption> lstSO = new List<SelectOption>();
        lstSO.add(new SelectOption('Yes','Yes'));
        lstSO.add(new SelectOption('No','No'));
        return lstSO;
    }
}