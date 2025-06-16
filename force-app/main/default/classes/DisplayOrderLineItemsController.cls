/* Kondal # 18/1/2019/ # Field has been updated */

public class DisplayOrderLineItemsController {
    public Id caseId {get; set;}
    public Case cse {get; set;}
    public Id orderId {get; set;}
    public List<OrderItem> olis {get; set;}
    public List<OLIWrapperClass> wrapperList {get; set;}
    public final String MSG_CASEID_ERROR = 'No Case record found for Case with Id: ' + caseId;
    public ApexPages.StandardController controller {get; set;}
    
    public DisplayOrderLineItemsController(ApexPages.StandardController sc){
        this.controller = sc;
        
        caseId = controller.getId();
        System.debug(caseId);
        
        wrapperList = new List<OLIWrapperClass>();
        
        selectOLI(caseId);
    }
    
    /*
     * Retrieve all JDE_Order_Line_Item__c records that are children of the JDE_Order__c associated 
     * to the Case record
     */ 
    public void selectOLI(Id caseId){
        List<Case> caseWeCareAbout = [SELECT CaseNumber, Description, Issue_Problem__c, Issue_Category__c, 
                                      Order__c,Order__r.Name 
                                      FROM Case WHERE Id = :caseId LIMIT 1];
        
        if(caseWeCareAbout.size() > 0){
            System.debug('Case We Care About: ' + caseWeCareAbout[0]);
            cse = caseWeCareAbout[0];
            System.debug('Case: ' + cse);
            orderId = caseWeCareAbout[0].Order__c;
            System.debug('Order Id: ' + orderId);
            //Remove AND Last_Order_Status__c != '984' JDE status and replaced with Item 
            //Modified by Gopi 2/1/2018
            olis = [SELECT Id, Material_Desc__c, Qty_Ordered__c, Qty_Uom__c,
                   Extended_Quantity__c,UnitPrice, List_Price__c, Extended_Amount__c,  Weight_Uom__c, 
                    Material__c, Price_Uom__c, Line_Type__c,Item_Status__c,OrderItemNumber
                   FROM OrderItem WHERE Orderid= :orderId AND Item_Status__c != 'REJECTED'];
            System.debug('OLI\'s: ' + olis);
            
            for(OrderItem oli : olis){
                System.debug('Current OLI: ' + oli);
                OLIWrapperClass wrapper = new OLIWrapperClass();
                wrapper.oli = oli;
                wrapperList.add(wrapper);
            }
            
        } else {
            System.debug('No case record found for Case with Id: ' + caseId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, MSG_CASEID_ERROR));
        }
    }
    
    /*
     * Wrapper Class
     */ 
    public class OLIWrapperClass{
        public OrderItem oli {get; set;}
        
        public OLIWrapperClass(){}
    }
}