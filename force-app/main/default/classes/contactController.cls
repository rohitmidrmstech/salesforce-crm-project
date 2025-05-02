public class contactController {
    @AuraEnabled
    public static List<contact> getcontacts(){
        List<contact> conlist = new List<contact>();
        conlist = [SELECT Id,Name ,Phone FROM contact Limit 10];
        return conlist;
    }
}