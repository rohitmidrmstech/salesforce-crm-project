/****************************************************************************************************************************************
*    @description     : The Aims_Customer Wrapper class that handles the conversion of customer data received from a Java SQL server into Salesforce Account objects. 
It encapsulates both the data and the logic for creating Salesforce records based on that data
*    @ date           : 06-OCT-2023
*    @ Created By     : Sujata p. Galinde
*****************************************************************************************************************************************/
global class Aims_Customer {   
    public List<Map<String, Object>> customers;
    global Aims_Customer(){
        customers = new List< Map<String, Object>> ();
    } 
    global Account getAccount(){ 
        String pattern = '[0-9]+$';
        Account ac = new Account();
        /*ac.Name= Name?.replaceAll(pattern, '').trim();
        ac.AIMS_Customer__c =custCode;
        ac.Address_Description__c =  address1;
        ac.BillingStreet = address2;
        ac.BillingCity =address3;
        ac.BillingPostalCode = postCode;
        ac.Phone = phone;         
        ac.Type = custType;  */     
        return ac;       
    }   
}