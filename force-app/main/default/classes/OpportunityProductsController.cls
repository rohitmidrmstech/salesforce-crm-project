/****************************************************************************************
* @Author       Dru Luce-Edwards
* @Date         August 1, 2016
* @Description  Controller for OpportunityProducts
*****************************************************************************************/
public class OpportunityProductsController {

   
    //public String OpportunityLineItem { get; set; }

    public PageReference cancel() {
      //PageReference returnPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
      return null;
}

    public Opportunity cOpp {get;set;}
    public Integer selectedRowNum {get;set;}
    public String selectedRowProdId {get;set;}
    public String selectedRowProdName {get;set;}
    public List<OpportunityLineItem> clstOppProds {get;set;}
    public List<OpportunityLineItem> clstDelOppProds {get;set;}
    public String getJDEProductRTId(){
        return [SELECT Id FROM RecordType WHERE SObjectType = 'Product2' AND Name = 'New Products' LIMIT 1].get(0).Id;
        
    }
    
    /****************************************************************************************
     * @Author       Dru Luce-Edwards
     * @Date         August 1, 2016
     * @Description  Contructor
     *****************************************************************************************/
    /*public OpportunityProductsController(ApexPages.StandardSetController ssc) {
       
    }*/
    
     public OpportunityProductsController() {
    
        selectedRowNum = null;
        selectedRowProdId = null;
        selectedRowProdName = null;
        String oppId = ApexPages.currentPage().getParameters().get('id');
        //cOpp = null;
        for(Opportunity o : [SELECT Id,Name FROM Opportunity WHERE Id = :oppId]) 
        cOpp = o;
        system.debug('@@@@'+cOpp);
        clstOppProds = new List<OpportunityLineItem>();
        clstDelOppProds = new List<OpportunityLineItem>();
        if(oppId != null) 
        clstOppProds = [SELECT Id,Opportunityid,Include_In_Next_Quote__c,Product2id,Product2.Name,Quantity,Requested_Price__c FROM OpportunityLineItem WHERE Opportunityid = :oppId];
        system.debug('@@@@'+clstOppProds);
        
       
    }
    
    /****************************************************************************************
     * @Author       Dru Luce-Edwards
     * @Date         August 1, 2016
     * @Description  Adds the product name to the opp product so it won't display as blank on rerenders
     *****************************************************************************************/
     public PageReference setProd(){
         PageReference pg = null;
         OpportunityLineItem op = clstOppProds.get(selectedRowNum);
         Product2 pt = new Product2(id=selectedRowProdId,name=selectedRowProdName);
         op.Product2id = selectedRowProdId;
         op.Product2.Name = pt.Name;
         return pg;
     }
    
    /****************************************************************************************
     * @Author       Dru Luce-Edwards
     * @Date         August 1, 2016
     * @Description  Removes a row and adds the id if exists to the delete list
     *****************************************************************************************/
     public PageReference removeRow(){
         PageReference pg = null;
         OpportunityLineItem op = clstOppProds.remove(selectedRowNum);
         if(op.Id != null) clstDelOppProds.add(op);
         return pg;
     }
     
     /************************************	****************************************************
     * @Author       Dru Luce-Edwards
     * @Date         August 1, 2016
     * @Description  Add a new row with default values
     *****************************************************************************************/
     public PageReference addNew(){
         PageReference pg = null;
         clstOppProds.add(new OpportunityLineItem(Opportunityid= cOpp.id));
         system.debug('@@@@'+clstOppProds);
         return pg;
         
     }
    
    /****************************************************************************************
     * @Author       Dru Luce-Edwards
     * @Date         August 1, 2016
     * @Description  Saves the new or changed opp prods and deletes the removed ones
     *****************************************************************************************/
     public PageReference doSave(){
         PageReference pg = null;
         SavePoint sp = Database.setSavePoint();
         try{
             delete clstDelOppProds;
             upsert clstOppProds;
             pg = new PageReference('/'+cOpp.Id);
             system.debug('@@@@'+pg);
         }catch(Exception e){
             Database.rollback(sp);
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
         }
         return pg;
     }
}