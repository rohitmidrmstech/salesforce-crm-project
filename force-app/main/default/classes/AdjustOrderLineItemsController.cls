/* Kondal # 18/1/2019/ # Field has been updated */

public class AdjustOrderLineItemsController {
    public Id caseId {get; set;}
    public Case cse {get; set;}
    public Id orderId {get; set;}
    public List<OrderItem> olis {get; set;}
    public String rebillId {get; set;}
    public String creditId {get; set;}
    public Boolean nextButton {get; set;}
    public Boolean backButton {get; set;}
    public Boolean saveButton {get; set;}
    public Boolean firstPage {get; set;}
    public Boolean editCredits {get; set;}
    public Boolean editRebills {get; set;}
    public Map<String, OLIWrapperClass> wrapperMap {get; set;}
    public Map<String, OLIWrapperClass> creditWrapperMap {get; set;}
    public Map<String, OLIWrapperClass> rebillWrapperMap {get; set;}
    public List<OLIWrapperClass> wrapperList {get; set;}
    public List<OLIWrapperClass> wrappersWeCareAbout {get; set;}
    public List<OLIWrapperClass> creditWrappers {get; set;}
    public List<OLIWrapperClass> rebillWrappers {get; set;}
    public Set<Adjustment__c> newAdjustments {get; set;}
    public List<Adjustment__c> existingCreditAdjustmentsList {get; set;}
    public List<Adjustment__c> existingRebillAdjustmentsList {get; set;}
    public List<Adjustment__c> existingAdjustmentsList {get; set;}
    public final String MSG_CASEID_ERROR = 'No Case record found for Case with Id: ' + caseId;
    public Decimal totalCreditAdjustmentAmount {get; set;}
    public Decimal totalRebillAdjustmentAmount {get; set;}
    public Decimal totalAdjustmentAmount {get; set;}
    public Decimal totalExistingCreditAdjustmentAmount {get; set;}
    public Decimal totalExistingRebillAdjustmentAmount {get; set;}
    public Decimal totalExistingAdjustmentAmount {get; set;}
    public ApexPages.StandardController controller {get; set;}
    public Map<String, Product2> itemNumberToProductTypeMap2 {get; set;}
    public Map<String, Product2> itemNumberToProductTypeMap {get; set;}
    public Map<String, Product2> OLIItemNumberToProductTypeMap {get; set;}
    public List<String> adjustmentOLIItemNumber {get; set;}
    public List<String> wrapperListItemNumbers {get; set;}
    public List<String> OLIListItemNumbers {get; set;}
    public Map<Decimal, Decimal> OLIUnitPriceMap {get; set;}
    public Decimal OLIUnitPrice {get; set;}
    public List<Adjustment__c> oldExistingCreditAdjustmentsList {get; set;}
    public List<Adjustment__c> oldExistingRebillAdjustmentsList {get; set;}
    
    public AdjustOrderLineItemsController(ApexPages.StandardController sc){
        this.controller = sc;
        
        caseId = ((Adjustment__c)controller.getRecord()).Case__c;
        System.debug(caseId);
        
        nextButton = TRUE;
        saveButton = FALSE;
        backButton = FALSE;
        firstPage = TRUE;
        editCredits = FALSE;
        editRebills = FALSE;
        
        totalAdjustmentAmount = 0.00;
        totalCreditAdjustmentAmount = 0.00;
        totalRebillAdjustmentAmount = 0.00;
        totalExistingAdjustmentAmount = 0.00;
        totalExistingCreditAdjustmentAmount = 0.00;
        totalExistingRebillAdjustmentAmount = 0.00;
        
        newAdjustments = new Set<Adjustment__c>();
        
        existingCreditAdjustmentsList = new List<Adjustment__c>();
        existingRebillAdjustmentsList = new List<Adjustment__c>();
        existingAdjustmentsList = new List<Adjustment__c>();
        wrapperList = new List<OLIWrapperClass>();
        wrapperMap = new Map<String, OLIWrapperClass>();
        wrappersWeCareAbout = new List<OLIWrapperClass>();
        wrapperListItemNumbers = new List<String>();
        OLIListItemNumbers = new List<String>();
        creditWrappers = new List<OLIWrapperClass>();
        rebillWrappers = new List<OLIWrapperClass>();
        creditWrapperMap = new Map<String, OLIWrapperClass>();
        rebillWrapperMap = new Map<String, OLIWrapperClass>();
        itemNumberToProductTypeMap = new Map<String, Product2>();
        itemNumberToProductTypeMap2 = new Map<String, Product2>();
        OLIItemNumberToProductTypeMap = new Map<String, Product2>();
        OLIUnitPriceMap = new Map<Decimal, Decimal>();
        
        queryCreditAdjustments(caseId);
        queryRebillAdjustments(caseId);
        
        if(existingAdjustmentsList.size() > 0){
            
            firstPage = FALSE;
            editCredits = TRUE;
            editRebills = TRUE;
            saveButton = TRUE;
            
            adjustmentOLIItemNumber = new List<String>();
            
            oldExistingCreditAdjustmentsList = new List<Adjustment__c>();
            oldExistingRebillAdjustmentsList = new List<Adjustment__c>();
            
            oldExistingCreditAdjustmentsList = existingCreditAdjustmentsList.deepClone(true, true, true);
            oldExistingRebillAdjustmentsList = existingRebillAdjustmentsList.deepClone(true, true, true);
            
            for(Adjustment__c a : existingAdjustmentsList){
                if(a.Order_Line_Item__c != null && a.Order_Line_Item__r.Line_Type__c != null && !a.Order_Line_Item__r.Line_Type__c.startsWith('F')){
                   if(a.Order_Line_Item__r.Material__c!= null){
                       adjustmentOLIItemNumber.add(a.Order_Line_Item__r.Material__c); 
                   }
                }
                
                if(a.Type__c == 'Credit'){
                   totalExistingCreditAdjustmentAmount += a.Adjusted_Amount__c; 
                } else if(a.Type__c == 'Rebill'){
                    totalExistingRebillAdjustmentAmount += a.Adjusted_Amount__c;
                }
            }
            
            System.debug(adjustmentOLIItemNumber);
            itemNumberToProductTypeMap2 = queryProductType(adjustmentOLIItemNumber);
            totalExistingAdjustmentAmount = totalExistingCreditAdjustmentAmount + totalExistingRebillAdjustmentAmount;
            System.debug(itemNumberToProductTypeMap2);
            System.debug(totalExistingAdjustmentAmount);
        }else{
        	firstPage = FALSE;   
        }
        
        selectOLI(caseId);
    }
    
    /*
     * Query for existing Credit Adjustments
     */
    public boolean queryCreditAdjustments(Id caseId){
        existingCreditAdjustmentsList = [SELECT Id, Name, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                                   Adjusted_Discount__c, Adjusted_Amount__c, Order__c , Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                                   QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                                   Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                                   Order_Line_Item__r.Line_Type__c
                                   FROM Adjustment__c WHERE Case__c = :caseId AND Type__c = 'Credit'];
        SYSTEM.DEBUG('+++++ existingCreditAdjustmentsList.size(): ' + existingCreditAdjustmentsList.size());
        if(existingCreditAdjustmentsList.size() > 0){
            editCredits = TRUE;
            existingAdjustmentsList.addAll(existingCreditAdjustmentsList);
        }
        
        System.debug('+++++Existing Credit Adjustments List: ' + existingCreditAdjustmentsList);
        
        return editCredits;
    }
    
    /*
     * Query for existing Rebill Adjustments
     */
    public boolean queryRebillAdjustments(Id caseId){
        existingRebillAdjustmentsList = [SELECT Id, Name, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                                   Adjusted_Discount__c, Adjusted_Amount__c, Order__c, Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                                   QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                                   Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                                   Order_Line_Item__r.Line_Type__c
                                   FROM Adjustment__c WHERE Case__c = :caseId AND TYpe__c = 'Rebill'];
        
        if(existingRebillAdjustmentsList.size() > 0){
            editRebills = TRUE;
            existingAdjustmentsList.addAll(existingRebillAdjustmentsList);
        }
        
        System.debug('Existing Rebill Adjustments List: ' + existingRebillAdjustmentsList);
        
        return editRebills;
    }
    
    /*
     * Query for Products from JDE Order Line Item Item_Number__c
     */ 
    private Map<String, Product2> queryProductType(List<String> listItemNumbers){
        Map<String, Product2> tempMap = new Map<String, Product2>();
        
        //List<Product2> ptList = [SELECT Id, ProductCode, Stocking_to_Selling_Conversion_Factor__c FROM Product2 WHERE ProductCode IN :listItemNumbers];
        /*for(product2 pt : map_ptList.values())
        {
            //for(String itemNumber : wrapperListItemNumbers){
            
            for(String itemNumber : listItemNumbers){
                if(pt.ProductCode == itemNumber){
                    tempMap.put(itemNumber, pt);
                }
            }
        }*/
        
        for(String itemNumber : listItemNumbers)	if(map_ptList.containsKey(itemNumber))tempMap.put(itemNumber, map_ptList.get(itemNumber));
     
        
        System.debug(tempMap);
        return tempMap;
    }
    
    public static Map<String, Product2> map_ptList 
    {
        get 
        {
            if(map_ptList == null)
            {
                map_ptList = new Map<String, Product2>();
                for(Product2 prod : [SELECT Id, ProductCode, Stocking_to_Selling_Conversion_Factor__c FROM Product2 WHERE ProductCode != null and Stocking_to_Selling_Conversion_Factor__c  != null])
                {
                    map_ptList.put(prod.ProductCode, prod);
                }
            }
            return map_ptList;
        }
            
        set;
    }
    
    /*
    * Dynamically query for the Product Type Stocking to Selling Conversion Factor
    */
   @TestVisible private Decimal queryProductType(Id ptId){
        List<Product2> ptList = [SELECT Id, ProductCode, Stocking_to_Selling_Conversion_Factor__c FROM Product2 WHERE Id = :ptId LIMIT 1];
        
        return ptList[0].Stocking_to_Selling_Conversion_Factor__c;
    }
    
    /*
     * Retrieve all JDE_Order_Line_Item__c records that are children of the JDE_Order__c associated 
     * to the Case record
     */ 
    public void selectOLI(Id caseId){
        List<Case> caseWeCareAbout = [SELECT CaseNumber, Status, Description, Issue_Problem__c, Issue_Category__c, 
                                      Order__c, Order__r.Name 
                                      FROM Case WHERE Id = :caseId LIMIT 1];
        
        if(caseWeCareAbout.size() > 0){
            System.debug('Case We Care About: ' + caseWeCareAbout[0]);
            cse = caseWeCareAbout[0];
            System.debug('Case: ' + cse);
            orderId = caseWeCareAbout[0].Order__c;
            System.debug('Order Id: ' + orderId);
            //Remove AND Last_Order_Status__c != '984' JDE status and replaced with Item 
            //Modified by Gopi 2/1/2018 
            olis = [SELECT Id,Material_Desc__c, Qty_Ordered__c, Qty_Uom__c, OrderItemNumber,
                   Extended_Quantity__c, UnitPrice, List_Price__c, Extended_Amount__c, Weight_Uom__c, 
                   Material__c, Price_Uom__c, Line_Type__c,Item_Status__c 
                   FROM OrderItem WHERE Orderid = :orderId AND Item_Status__c != 'REJECTED'];
            System.debug('OLI\'s: ' + olis);
            
            for(OrderItem oli : olis){
                System.debug('Current OLI: ' + oli);
                OLIWrapperClass wrapper = new OLIWrapperClass();
                wrapper.wrapperid = oli.Id;
                wrapper.oli = oli;
                wrapperList.add(wrapper);
                System.debug(wrapper.oli.Material__c);
                OLIListItemNumbers.add(wrapper.oli.Material__c);
                if(!wrapper.oli.Line_Type__c.startsWith('F')){
                   if(wrapper.oli.Material__c!= null){
                       wrapperListItemNumbers.add(wrapper.oli.Material__c); 
                   }
                }
            }
            
            itemNumberToProductTypeMap = queryProductType(wrapperListItemNumbers);
            OLIItemNumberToProductTypeMap = queryProductType(OLIListItemNumbers);
            System.debug(itemNumberToProductTypeMap);
            
        } else {
            System.debug('No case record found for Case with Id: ' + caseId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, MSG_CASEID_ERROR));
        }
    }
    
    /*
     * Check if a JDE_Order_Line_Item__c selected from the first page has credit, rebill, or
     * both checked. If either or both is checked, add to the appropriate wrapper list.
     */ 
    public void getWrappersWeCareAbout(){ 
        System.debug('********** Divya'+wrapperList);
        
        for(OLIWrapperClass wrapper : wrapperList){
            System.debug('Wrapper Credit: ' + wrapper.credit);
            System.debug('Rebill: '+ wrapper.rebill);
            Decimal stockingToSellingConversionFactor = 1;
            
            if(wrapper.credit && wrapper.rebill){
                Decimal OLICreditUnitPrice = wrapper.oli.UnitPrice;
                OLIUnitPriceMap.put(wrapper.oli.UnitPrice, OLICreditUnitPrice );
                if(!creditWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Credit Wrapper Map');
                    creditWrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    OLIWrapperClass creditWrapper = new OLIWrapperClass(wrapper.oli, wrapper.credit, false, wrapper.oli.Id);
                    //Checking null for Quantity_Ordered
                    if(wrapper.oli.Qty_Ordered__c != null){
                       creditWrapper.adjustment.Adjusted_Quantity__c = -wrapper.oli.Qty_Ordered__c;
                    }                    
                    creditWrapper.adjustment.Adjusted_Price__c = wrapper.oli.List_Price__c;
                    //creditWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.Unit_Price__c/wrapper.oli.List_Price__c)) * 100).setScale(2);
                    if(wrapper.oli.List_Price__c != null && wrapper.oli.List_Price__c > 0){
                        creditWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.UnitPrice/wrapper.oli.List_Price__c)) * 100).setScale(2);
                        System.debug('Adjusted Discount: ' + creditWrapper.adjustment.Adjusted_Discount__c);
                    } else{
                        creditWrapper.adjustment.Adjusted_Discount__c = 0;
                        System.debug('Adjusted Discount: ' + creditWrapper.adjustment.Adjusted_Discount__c);
                    }
                    if(itemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                        stockingToSellingConversionFactor = itemNumberToProductTypeMap.get(wrapper.oli.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                    }
                    creditWrapper.adjustment.Conversion_Rate__c = stockingToSellingConversionFactor;                    
                    //Checking nulls for all the value used for calculating the Adjusted Amount                   
                    if(creditWrapper.adjustment.Adjusted_Quantity__c != null && wrapper.oli.UnitPrice != null && stockingToSellingConversionFactor != null){
                        creditWrapper.adjustment.Adjusted_Amount__c = creditWrapper.adjustment.Adjusted_Quantity__c * wrapper.oli.UnitPrice* stockingToSellingConversionFactor;    
                    }
                    else{ creditWrapper.adjustment.Adjusted_Amount__c = 0;                 }                                       
                    creditWrappers.add(creditWrapper);
                    System.debug(creditWrappers);
                    totalCreditAdjustmentAmount += (creditWrapper.adjustment.Adjusted_Amount__c).setScale(2);
                    System.debug(totalAdjustmentAmount);
                }
                
                if(!rebillWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to rebill Wrapper Map');
                    Decimal OLIRebillUnitPrice = wrapper.oli.UnitPrice;
                    OLIUnitPriceMap.put(wrapper.oli.UnitPrice, OLIRebillUnitPrice );
                    rebillWrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    OLIWrapperClass rebillWrapper = new OLIWrapperClass(wrapper.oli, false, wrapper.rebill, wrapper.oli.Id);
                    rebillWrapper.adjustment.Adjusted_Quantity__c = wrapper.oli.Qty_Ordered__c;
                    rebillWrapper.adjustment.Adjusted_Price__c = wrapper.oli.List_Price__c;
                    //rebillWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.Unit_Price__c/wrapper.oli.List_Price__c)) * 100).setScale(2);
                    if(wrapper.oli.List_Price__c != null && wrapper.oli.List_Price__c > 0){
                        rebillWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.UnitPrice/wrapper.oli.List_Price__c)) * 100).setScale(2);
                        System.debug('Adjusted Discount: ' + rebillWrapper.adjustment.Adjusted_Discount__c);
                    } else{
                        rebillWrapper.adjustment.Adjusted_Discount__c = 0;
                        System.debug('Adjusted Discount: ' + rebillWrapper.adjustment.Adjusted_Discount__c);
                    }
                    if(itemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                        stockingToSellingConversionFactor = itemNumberToProductTypeMap.get(wrapper.oli.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                    }
                    rebillWrapper.adjustment.Conversion_Rate__c = stockingToSellingConversionFactor;
                    //Checking nulls for all the value used for calculating the Adjusted Amount                  
                    if(rebillWrapper.adjustment.Adjusted_Quantity__c != null && wrapper.oli.UnitPrice!= null && stockingToSellingConversionFactor != null){
                        rebillWrapper.adjustment.Adjusted_Amount__c = rebillWrapper.adjustment.Adjusted_Quantity__c * wrapper.oli.UnitPrice* stockingToSellingConversionFactor;    
                    }
                    else{ rebillWrapper.adjustment.Adjusted_Amount__c = 0;                    }                   
                    rebillWrappers.add(rebillWrapper);
                    System.debug(rebillWrappers);
                    totalRebillAdjustmentAmount += (rebillWrapper.adjustment.Adjusted_Amount__c).setScale(2);
                }
                
                if(!wrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Wrapper Map');
                    wrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    wrappersWeCareAbout = wrapperMap.values();
                    System.debug('Wrappers We Care About: ' + wrappersWeCareAbout);
                }
            } else if(wrapper.credit && !wrapper.rebill){
                System.debug('Test1-->' + wrapper.credit);
                System.debug('Test2-->' + wrapper.rebill);
                Decimal OLIUnitPrice = wrapper.oli.UnitPrice;
                OLIUnitPriceMap.put(wrapper.oli.UnitPrice, OLIUnitPrice);
                if(!creditWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Credit Wrapper Map');
                    creditWrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    OLIWrapperClass creditWrapper = new OLIWrapperClass(wrapper.oli, wrapper.credit, false, wrapper.oli.Id);
                    creditWrapper.adjustment.Adjusted_Quantity__c = -wrapper.oli.Qty_Ordered__c;
                    creditWrapper.adjustment.Adjusted_Price__c = wrapper.oli.List_Price__c;
                    if(wrapper.oli.List_Price__c != null && wrapper.oli.List_Price__c > 0){
                        creditWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.UnitPrice/wrapper.oli.List_Price__c)) * 100).setScale(2);
                        System.debug('Adjusted Discount: ' + creditWrapper.adjustment.Adjusted_Discount__c);
                    } else{
                        creditWrapper.adjustment.Adjusted_Discount__c = 0;
                        System.debug('Adjusted Discount: ' + creditWrapper.adjustment.Adjusted_Discount__c);
                    }
                    if(itemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                        stockingToSellingConversionFactor = itemNumberToProductTypeMap.get(wrapper.oli.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                    }
                    creditWrapper.adjustment.Conversion_Rate__c = stockingToSellingConversionFactor;
                     //Checking nulls for all the value used for calculating the Adjusted Amount
                    if(creditWrapper.adjustment.Adjusted_Quantity__c != null && wrapper.oli.UnitPrice!= null && stockingToSellingConversionFactor != null){
                         creditWrapper.adjustment.Adjusted_Amount__c = creditWrapper.adjustment.Adjusted_Quantity__c * wrapper.oli.UnitPrice* stockingToSellingConversionFactor;
                    }
                    else{   creditWrapper.adjustment.Adjusted_Amount__c = 0;                    }
                    creditWrappers.add(creditWrapper);
                    System.debug(creditWrapper);
                    totalCreditAdjustmentAmount += (creditWrapper.adjustment.Adjusted_Amount__c).setScale(2);
                }
                
                if(!wrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Wrapper Map');
                    wrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    wrappersWeCareAbout = wrapperMap.values();
                    System.debug('Wrappers We Care About: ' + wrappersWeCareAbout);
                }
            } else if(!wrapper.credit && wrapper.rebill){
                System.debug('Rebill Wrapper Map: ' + rebillWrapperMap);
                Decimal OLIUnitPrice = wrapper.oli.UnitPrice;
                OLIUnitPriceMap.put(wrapper.oli.UnitPrice, OLIUnitPrice);
                if(!rebillWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Rebill Wrapper Map');
                    rebillWrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    OLIWrapperClass rebillWrapper = new OLIWrapperClass(wrapper.oli, false, wrapper.rebill, wrapper.oli.Id);
                    rebillWrapper.adjustment.Adjusted_Quantity__c = wrapper.oli.Qty_Ordered__c;
                    rebillWrapper.adjustment.Adjusted_Price__c = wrapper.oli.List_Price__c;
                    if(wrapper.oli.List_Price__c != null && wrapper.oli.List_Price__c > 0){
                        rebillWrapper.adjustment.Adjusted_Discount__c = ((1 - (wrapper.oli.UnitPrice/wrapper.oli.List_Price__c)) * 100).setScale(2);
                        System.debug('Adjusted Discount: ' + rebillWrapper.adjustment.Adjusted_Discount__c);
                    } else{
                        rebillWrapper.adjustment.Adjusted_Discount__c = 0;
                        System.debug('Adjusted Discount: ' + rebillWrapper.adjustment.Adjusted_Discount__c);
                    }
                    if(itemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                        stockingToSellingConversionFactor = itemNumberToProductTypeMap.get(wrapper.oli.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                    }
                    rebillWrapper.adjustment.Conversion_Rate__c = stockingToSellingConversionFactor;
                     //Checking nulls for all the value used for calculating the Adjusted Amount
                    if(rebillWrapper.adjustment.Adjusted_Quantity__c != null && wrapper.oli.UnitPrice!= null && stockingToSellingConversionFactor != null){
                        rebillWrapper.adjustment.Adjusted_Amount__c = rebillWrapper.adjustment.Adjusted_Quantity__c * wrapper.oli.UnitPrice* stockingToSellingConversionFactor;
                    }
                    else{    rebillWrapper.adjustment.Adjusted_Amount__c = 0;                    }
                    rebillWrappers.add(rebillWrapper);
                    System.debug(rebillWrappers);
                    totalRebillAdjustmentAmount += (rebillWrapper.adjustment.Adjusted_Amount__c).setScale(2);
                }
                
                if(!wrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Adding to Wrapper Map');
                    wrapperMap.put(wrapper.oli.OrderItemNumber, wrapper);
                    wrappersWeCareAbout = wrapperMap.values();
                    System.debug('Wrappers We Care About: ' + wrappersWeCareAbout);
                }
            } else if(!wrapper.credit && !wrapper.rebill){
                if(creditWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Removing this Credit Wrapper from the Map');
                    creditWrapperMap.remove(wrapper.oli.OrderItemNumber);
                }
                
                if(rebillWrapperMap.containsKey(wrapper.oli.OrderItemNumber)){
                    System.debug('Removing this Rebill from the Map');
                    rebillWrapperMap.remove(wrapper.oli.OrderItemNumber);
                }
            }
        }
        
        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
        System.debug(totalAdjustmentAmount);
    }
    
    /*
     * Initialize the values of the adjustment records to be inserted into the system.
     */ 
    public void createNewAdjustments(List<OLIWrapperClass> OLIWrapperList){
   
        for(OLIWrapperClass wrapper : OLIWrapperList){
            System.debug('Wrapper: ' + wrapper);
            if(wrapper.credit && wrapper.oli != NULL){
                System.debug('Wrapper to be creditted: ' + wrapper);
                wrapper.adjustment.Case__c = caseId;
                wrapper.adjustment.Order__c= orderId;
                if(OLIItemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                    wrapper.adjustment.Additional_Product1__c = OLIItemNumberToProductTypeMap.get(wrapper.oli.Material__c).Id; 
                }
                wrapper.adjustment.Order_Qty__c = String.valueOf(wrapper.oli.Qty_Ordered__c);
                wrapper.adjustment.EXT_QTY__c = wrapper.oli.Extended_Quantity__c;
                wrapper.adjustment.Ext_Amt__c = wrapper.oli.Extended_Amount__c;
                wrapper.adjustment.QTY_ORD__c = wrapper.oli.Qty_Ordered__c;
                wrapper.adjustment.Unit_PRC__c = wrapper.oli.UnitPrice;
                wrapper.adjustment.Order_Line_Item__c = wrapper.oli.Id;
                //MLS**
                //wrapper.adjustment.Conversion_Rate__c = wrapper.oli.Stocking_to_Selling_Conversion_Factor__c;
                wrapper.adjustment.Type__c = 'Credit';
                if(!newAdjustments.contains(wrapper.adjustment)){
                    newAdjustments.add(wrapper.adjustment);
                }
            } else if(wrapper.rebill && wrapper.oli != NULL){
                System.debug('Wrapper to be rebilled: ' + wrapper);
                wrapper.adjustment.Case__c = caseId;
                wrapper.adjustment.Order__c= orderId;
                if(OLIItemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){     wrapper.adjustment.Additional_Product1__c = OLIItemNumberToProductTypeMap.get(wrapper.oli.Material__c).Id;                 }
                wrapper.adjustment.Order_Qty__c = String.valueOf(wrapper.oli.Qty_Ordered__c);
                wrapper.adjustment.EXT_QTY__c = wrapper.oli.Extended_Quantity__c;
                wrapper.adjustment.Ext_Amt__c = wrapper.oli.Extended_Amount__c;
                wrapper.adjustment.QTY_ORD__c = wrapper.oli.Qty_Ordered__c;
                wrapper.adjustment.Unit_PRC__c = wrapper.oli.UnitPrice;
                wrapper.adjustment.Type__c = 'Rebill';
                wrapper.adjustment.Order_Line_Item__c= wrapper.oli.Id;
                //MLS**
                //wrapper.adjustment.Conversion_Rate__c = wrapper.oli.Stocking_to_Selling_Conversion_Factor__c;
                if(!newAdjustments.contains(wrapper.adjustment)){
                    newAdjustments.add(wrapper.adjustment);
                } 
            } else if(wrapper.credit && wrapper.oli == NULL){
                wrapper.adjustment.Case__c = caseId;
                wrapper.adjustment.Type__c = 'Credit';
                if(!newAdjustments.contains(wrapper.adjustment)){
                    newAdjustments.add(wrapper.adjustment);
                }            
            } else if(wrapper.rebill && wrapper.oli == NULL){
                wrapper.adjustment.Case__c = caseId;
                wrapper.adjustment.Type__c = 'Rebill';
                if(!newAdjustments.contains(wrapper.adjustment)){
                    newAdjustments.add(wrapper.adjustment);
                }
            }
        }
    }
    
    /*
     * Remove credit/rebill wrapper from the wrapper list passed in the params
     * Update the checkboxes on the first page if a credit/rebill wrapper removed from the 
     * wrapper list is associated with the id of a wrapper on the first page
     */ 
    public void remove(List<OLIWrapperClass> wrappers, Object id, String type){
        List<Integer> toRemove = new List<Integer>();
        for(Integer i = 0; i < wrappers.size(); i++){
            if(wrappers[i].wrapperid == id){
                System.debug('Removing this from the list: ' + wrappers[i]);
                toRemove.add(i);
                break;
            }
        }
        
        System.debug(toRemove);
        System.debug(wrappers);
        for(Integer i : toRemove){
            if(type == 'credit'){
                if(wrappers[i].oli.OrderItemNumber== NULL){
                    System.debug('Removing ' + wrappers[i] + ' from Credit Wrappers: ' + wrappers);
                    if(wrappers[i].adjustment.Adjusted_Amount__c != null){
                        totalCreditAdjustmentAmount -= (wrappers[i].adjustment.Adjusted_Amount__c).setScale(2);
                        System.debug(totalCreditAdjustmentAmount); 
                        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
                        System.debug(totalAdjustmentAmount);
                    }     
                    wrappers.remove(i);
                    break;
                }
                
                if(wrappers[i].adjustment.Adjusted_Amount__c != null){
                        totalCreditAdjustmentAmount -= (wrappers[i].adjustment.Adjusted_Amount__c).setScale(2);
                        System.debug(totalCreditAdjustmentAmount);totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
                        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
                        System.debug(totalAdjustmentAmount);
                } 
                System.debug('Removing ' + wrappers[i].oli.OrderItemNumber+ ' from Credit Wrapper Map');
                creditWrapperMap.remove(wrappers[i].oli.OrderItemNumber);
                if(rebillWrapperMap.size() > 0 && rebillWrapperMap.containsKey(wrappers[i].oli.OrderItemNumber) && rebillWrapperMap.get(wrappers[i].oli.OrderItemNumber).wrapperid == id){
                    System.debug('Found in rebillWrappers');
                    wrappers.remove(i);
                    break;
                }
            }
            else if(type == 'rebill'){
                if(wrappers[i].oli.OrderItemNumber== NULL){
                    System.debug('Removed ' + wrappers[i] + ' from Rebill Wrapper Map: ' + wrappers);
                    if(wrappers[i].adjustment.Adjusted_Amount__c != null){
                        totalRebillAdjustmentAmount -= (wrappers[i].adjustment.Adjusted_Amount__c).setScale(2);
                        System.debug(totalRebillAdjustmentAmount);
                        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
                        System.debug(totalAdjustmentAmount);
                    }
                    wrappers.remove(i);
                    break;
                }
                
                System.debug('Removing ' + wrappers[i].oli.OrderItemNumber+ ' from Rebill Wrapper Map');
                if(wrappers[i].adjustment.Adjusted_Amount__c != null){
                        totalRebillAdjustmentAmount -= (wrappers[i].adjustment.Adjusted_Amount__c).setScale(2);
                        System.debug(totalRebillAdjustmentAmount);
                        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
                        System.debug(totalAdjustmentAmount);
                }
                rebillWrapperMap.remove(wrappers[i].oli.OrderItemNumber);
                if(creditWrappers.size() > 0 && creditWrapperMap.containsKey(wrappers[i].oli.OrderItemNumber) && creditWrapperMap.get(wrappers[i].oli.OrderItemNumber).wrapperid == id){
                    System.debug('Found in creditWrappers');
                    wrappers.remove(i);
                    break;
                }
            } 
            
            //Only remove from wrapperMap if the wrapper exists in both creditWrapperMap and rebillWrapperMap
            wrapperMap.remove(wrappers[i].oli.OrderItemNumber); 
            wrappers.remove(i);
            
            totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;
            System.debug(totalAdjustmentAmount);
        }
        
        System.debug(wrappers);
        wrappersWeCareAbout = wrapperMap.values();
        System.debug(wrappersWeCareAbout);
        
        //Modify the checkbox of the wrapper list on the first page
        List<Integer> toUpdate = new List<Integer>();
        for(Integer i = 0; i < wrapperList.size(); i++){
            if(wrapperList[i].wrapperid == id){
                System.debug('Modifying this checkbox: ' + wrapperList[i].wrapperid);
                toUpdate.add(i);
            }
        }
        
        System.debug(toUpdate);
        System.debug(wrapperList);
        for(Integer i : toUpdate){
            if(type == 'credit'){
                wrapperList[i].credit = FALSE;
            }
            else if(type == 'rebill'){
                wrapperList[i].rebill = FALSE;
            }
        }
        System.debug(wrapperList);
    }
    
    /*
     * Recalculate object formulas fields dynamically
     */ 
    /*public void recalculateFormulas(List<OLIWrapperClass> wrappers){
        System.debug(wrappers);
            
        for(OLIWrapperClass wrapper : wrappers){
            wrapper.adjustment.recalculateFormulas();
            System.debug(wrapper.adjustment);
            //totalAdjustmentAmount += wrapper.adjustment.Adjusted_Amount__c;
            //System.debug(totalAdjustmentAmount);
        }
        
        recalculateAdjustmentAmount();
    }*/
    
    /*
     * Recalculate Adjustment Amount 
     */ 
    public void recalculateAdjustmentAmount(List<OLIWrapperClass> wrappers){
        System.debug(wrappers);
        
        for(OLIWrapperClass wrapper : wrappers){
            Decimal stockingToSellingConversionFactor = 1;
            //2-9-2017 Dru: If the discount is null, set it to 0
            if(wrapper.adjustment != null && wrapper.adjustment.Adjusted_Discount__c == null) wrapper.adjustment.Adjusted_Discount__c = 0;
            if(wrapper.oli == null){ //Manual Credit/Rebill
                if(wrapper.adjustment.Additional_Product1__c != null && wrapper.adjustment.Adjusted_Quantity__c != null && wrapper.adjustment.Adjusted_Price__c != null && wrapper.adjustment.Adjusted_Discount__c != null){
                    System.debug('Recalculating Adjustment Amount');
                    stockingToSellingConversionFactor = queryProductType(wrapper.adjustment.Additional_Product1__c);
                    //MLS
                    wrapper.adjustment.Conversion_Rate__c = stockingToSellingConversionFactor;
                    //wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * math.ceil(wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));
                     //Checking null value used for calculating the Adjusted Amount
                    if(stockingToSellingConversionFactor != null){
                        wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * (wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));    
                    }
                    else{    wrapper.adjustment.Adjusted_Amount__c = 0;                    }
                    System.debug('Recalculated Adjustment Amount: ' + wrapper.adjustment.Adjusted_Amount__c);
                }
                else if(wrapper.adjustment.Adjusted_Quantity__c != null && wrapper.adjustment.Adjusted_Price__c != null && wrapper.adjustment.Adjusted_Discount__c != null){
                    System.debug('Recalculating Adjustment Amount');
                    //wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * math.ceil(wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));
                    //Checking null value used for calculating the Adjusted Amount
                    if(stockingToSellingConversionFactor != null){
                        wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * (wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));
                     }
                    else{        wrapper.adjustment.Adjusted_Amount__c = 0;                     }
                    System.debug('Recalculated Adjustment Amount: ' + wrapper.adjustment.Adjusted_Amount__c);
                }
            } else if(wrapper.oli.Material__c!= null){ //OLI associated Credit/Rebill
                System.debug('Recalculating Adjustment Amount');
                //wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * OLIUnitPriceMap.get(wrapper.oli.Unit_Price__c) * itemNumberToProductTypeMap.get(wrapper.oli.Item_Number__c).Stocking_to_Selling_Conversion_Factor__c;
                if(itemNumberToProductTypeMap.containsKey(wrapper.oli.Material__c)){
                    stockingToSellingConversionFactor = itemNumberToProductTypeMap.get(wrapper.oli.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                }
                //wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * math.ceil(wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));
                 //Checking nulls for all the value used for calculating the Adjusted Amount
                if(wrapper.adjustment.Adjusted_Quantity__c != null && stockingToSellingConversionFactor != null && wrapper.adjustment.Adjusted_Price__c != null && wrapper.adjustment.Adjusted_Discount__c != null){
                    wrapper.adjustment.Adjusted_Amount__c = wrapper.adjustment.Adjusted_Quantity__c * stockingToSellingConversionFactor * (wrapper.adjustment.Adjusted_Price__c - (wrapper.adjustment.Adjusted_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100)));    
                }
                else{       wrapper.adjustment.Adjusted_Amount__c = 0;                }
                
                System.debug('Recalculated Adjustment Amount: ' + wrapper.adjustment.Adjusted_Amount__c);
            } 
        }
    }
    
    /*
     * Recalculate Adjustment Discount
     */ 
    public void recalculateAdjustmentDiscount(List<OLIWrapperClass> wrappers){
        System.debug(wrappers);
        
        recalculateOLIUnitPrice(wrappers);
        
        for(OLIWrapperClass wrapper : wrappers){
            if(wrapper.oli != null){
                System.debug('Recalculating Adjustment Discount');
                wrapper.adjustment.Adjusted_Discount__c = ((1 - (OLIUnitPriceMap.get(wrapper.oli.UnitPrice)/wrapper.oli.List_Price__c)) * 100).setScale(2);
                System.debug('Recalculated Adjustment Discount: ' + wrapper.adjustment.Adjusted_Discount__c);
            }
        }
        
        //recalculateAdjustmentAmount(wrappers);
    }
    
    /*
     * Call recalculateAdjustmentDiscount() to recalculate discounts for credits
     */
    public PageReference recalculateCreditAdjustmentDiscount(){
        recalculateAdjustmentDiscount(creditWrappers);
        
        return null;
    }
    
    /*
     * Call recalculateAdjustmentDiscount() to recalculate discounts for rebills
     */
    public PageReference recalculateRebillAdjustmentDiscount(){
        recalculateAdjustmentDiscount(rebillWrappers);
        
        return null;
    }
    
    /*
     * Call recalculateAdjustmentAmount() to recalculate the adjustment amount
     */ 
    public PageReference recalculateCreditAdjustmentAmount(){
        recalculateAdjustmentAmount(creditWrappers);
        
        totalCreditAdjustmentAmount = 0.00; 
        for(OLIWrapperClass wrapper : creditWrappers){
            if(wrapper.adjustment.Adjusted_Amount__c != null){
                totalCreditAdjustmentAmount += (wrapper.adjustment.Adjusted_Amount__c).setScale(2);
            }
        }
        
        totalAdjustmentAmount = 0.00;
        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;

        return null;
    }
    
    /*
     * Call recalculateAdjustmentAmount() to recalculate the adjustment amount
     */ 
    public PageReference recalculateRebillAdjustmentAmount(){
        recalculateAdjustmentAmount(rebillWrappers);

        totalRebillAdjustmentAmount = 0.00;
        for(OLIWrapperClass wrapper : rebillWrappers){
            if(wrapper.adjustment.Adjusted_Amount__c != null){
                totalRebillAdjustmentAmount += (wrapper.adjustment.Adjusted_Amount__c).setScale(2);
            }
        }
        
        totalAdjustmentAmount = 0.00;
        totalAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;

        return null;
    }
    
    /*
     * Recalculate Adjustment Price 
     */ 
    public void recalculateOLIUnitPrice(List<OLIWrapperClass> wrappers){
        System.debug(wrappers);
        
        for(OLIWrapperClass wrapper : wrappers){
            if(wrapper.adjustment.Adjusted_Discount__c != null && wrapper.oli.List_Price__c != null){
                OLIUnitPrice = OLIUnitPriceMap.get(wrapper.oli.UnitPrice);
                System.debug('Recalculating Current OLI Unit Price: ' + OLIUnitPrice);
                OLIUnitPrice = (wrapper.oli.List_Price__c - (wrapper.oli.List_Price__c * (wrapper.adjustment.Adjusted_Discount__c / 100))).setScale(2);
                System.debug('Updated OLI Unit Price: ' + OLIUnitPrice);
                OLIUnitPriceMap.put(wrapper.oli.UnitPrice, OLIUnitPrice);
                System.debug('Updating OLI Unit Price Map: ' + OLIUnitPriceMap.get(wrapper.oli.UnitPrice));
            } 
        }
    }
    
    /*
     * Recalculate Credit Adjustment Price
     */
    public PageReference recalculateCreditUnitPrice(){
        recalculateOLIUnitPrice(creditWrappers);
        return null;
    }
    
    /*
     * Recalculate Rebill Adjustment Price
     */
    public PageReference recalculateRebillUnitPrice(){
        recalculateOLIUnitPrice(rebillWrappers);
        return null;
    }
    
    public PageReference recalculateAllAdjustmentAmounts(){
        recalculateRebillAdjustmentAmount();
        recalculateCreditAdjustmentAmount();
        
        return null;
    }
     
    public void recalculateExistingAdjustmentAmount(List<Adjustment__c> existingAdjustmentsList){
        for(Adjustment__c a : existingAdjustmentsList){
            //2-9-2017 Dru: If discount is blank set it to 0
            if(a.Adjusted_Discount__c == null) a.Adjusted_Discount__c = 0;
            Decimal stockingToSellingConversionFactor = 1;
            if(a.Order_Line_Item__c == null){ //Manual Credit/Rebill
                if(a.Additional_Product1__c != null && a.Adjusted_Quantity__c != null && a.Adjusted_Price__c != null && a.Adjusted_Discount__c != null){
                    System.debug('Recalculating Adjustment Amount');
                    stockingToSellingConversionFactor = queryProductType(a.Additional_Product1__c);
                    //MLS
                    a.Conversion_Rate__c = stockingToSellingConversionFactor;                   
                        a.Adjusted_Amount__c = a.Adjusted_Quantity__c * stockingToSellingConversionFactor * (a.Adjusted_Price__c - (a.Adjusted_Price__c * (a.Adjusted_Discount__c / 100)));                        
                    System.debug('Recalculated Adjustment Amount: ' + a.Adjusted_Amount__c);
                }
                else if(a.Adjusted_Quantity__c != null && a.Adjusted_Price__c != null && a.Adjusted_Discount__c != null){
                    System.debug('Recalculating Adjustment Amount');
                    a.Adjusted_Amount__c = a.Adjusted_Quantity__c * stockingToSellingConversionFactor * (a.Adjusted_Price__c - (a.Adjusted_Price__c * (a.Adjusted_Discount__c / 100)));
                    System.debug('Recalculated Adjustment Amount: ' + a.Adjusted_Amount__c);
                }
            } else if(a.Order_Line_Item__r.Material__c!= null){ //OLI associated Credit/Rebill
                System.debug('Recalculating Adjustment Amount');
                if(itemNumberToProductTypeMap2.containsKey(a.Order_Line_Item__r.Material__c)){
                    stockingToSellingConversionFactor = itemNumberToProductTypeMap2.get(a.Order_Line_Item__r.Material__c).Stocking_to_Selling_Conversion_Factor__c;
                }
                 //Checking nulls for all the value used for calculating the Adjusted Amount
                if(a.Adjusted_Quantity__c != null && stockingToSellingConversionFactor != null && a.Adjusted_Price__c != null && a.Adjusted_Discount__c != null){
                    a.Adjusted_Amount__c = a.Adjusted_Quantity__c * stockingToSellingConversionFactor  * (a.Adjusted_Price__c - (a.Adjusted_Price__c * (a.Adjusted_Discount__c / 100)));
                }
                System.debug('Recalculated Adjustment Amount: ' + a.Adjusted_Amount__c);
            } 
        }
    }
    
    /*
     * Recalculate Existing Adjustment Price 
     */ 
    public void recalculateOLIUnitPrice(List<Adjustment__c> existingAdjustmentsList){
        System.debug(existingAdjustmentsList);
        
        for(Adjustment__c a : existingAdjustmentsList){
            if(a.Adjusted_Discount__c != null && a.Order_Line_Item__r.List_Price__c != null){
                OLIUnitPrice = a.Order_Line_Item__r.UnitPrice;
                System.debug('Recalculating Current OLI Unit Price: ' + OLIUnitPrice);
                OLIUnitPrice = (a.Order_Line_Item__r.List_Price__c - (a.Order_Line_Item__r.List_Price__c * (a.Adjusted_Discount__c / 100))).setScale(2);
                System.debug('Updated OLI Unit Price: ' + OLIUnitPrice);
                OLIUnitPriceMap.put(a.Order_Line_Item__r.UnitPrice, OLIUnitPrice);
                System.debug('Updating OLI Unit Price Map: ' + OLIUnitPriceMap.get(a.Order_Line_Item__r.UnitPrice));
            } 
        }
    }
    
    /*
     * Recalculate Existing Credit Adjustment Price
     */
    public PageReference recalculateExistingCreditUnitPrice(){
        recalculateOLIUnitPrice(existingCreditAdjustmentsList);
        return null;
    }
    
    /*
     * Recalculate Existing Rebill Adjustment Price
     */
    public PageReference recalculateExistingRebillUnitPrice(){
        recalculateOLIUnitPrice(existingRebillAdjustmentsList);
        return null;
    }
    
    public void recalculateExistingAdjustmentDiscount(List<Adjustment__c> existingAdjustmentsList){
        recalculateOLIUnitPrice(existingAdjustmentsList);
        
        for(Adjustment__c a : existingAdjustmentsList){
            if(a.Order_Line_Item__c!= null){
                System.debug('Recalculating Adjustment Discount');
                a.Adjusted_Discount__c = ((1 - a.Unit_PRC__c/a.Order_Line_Item__r.List_Price__c) * 100).setScale(2);
                System.debug('Recalculated Adjustment Discount: ' + a.Adjusted_Discount__c);
            }
        }
    }
    
    public PageReference recalculateExistingCreditAdjustmentAmount(){
        recalculateExistingAdjustmentAmount(existingCreditAdjustmentsList);
        
        totalCreditAdjustmentAmount = 0.00; 
        for(Adjustment__c a : existingCreditAdjustmentsList){
            if(a.Adjusted_Amount__c != null){
                totalCreditAdjustmentAmount += (a.Adjusted_Amount__c).setScale(2);
            }
        }
        
        totalExistingAdjustmentAmount = 0.00;
        totalExistingAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;

        return null;
    }
     
    public PageReference recalculateExistingRebillAdjustmentAmount(){
        recalculateExistingAdjustmentAmount(existingRebillAdjustmentsList);

        totalRebillAdjustmentAmount = 0.00;
        for(Adjustment__c a : existingRebillAdjustmentsList){
            if(a.Adjusted_Amount__c != null){
                totalRebillAdjustmentAmount += (a.Adjusted_Amount__c).setScale(2);
            }
        }
        
        totalExistingAdjustmentAmount = 0.00;
        totalExistingAdjustmentAmount = totalCreditAdjustmentAmount + totalRebillAdjustmentAmount;

        return null;
    }
    
    public PageReference recalculateAllExistingAdjustmentAmounts(){
        recalculateExistingRebillAdjustmentAmount();
        recalculateExistingCreditAdjustmentAmount();
        
        return null;
    }
    
    /*
     * Insert new adjustment records once the Save button has been clicked
     */ 
    public Boolean insertNewAdjustments(){
        Boolean inserted = false;
        Savepoint sp = Database.setSavepoint();
        System.debug('Inserted ' + newAdjustments.size() + ' adjustments.');
        
        if(newAdjustments.size() > 0){
            System.debug('Adjustments to insert!');
            try{
                List<Adjustment__c> adjustmentsToInsert = new List<Adjustment__c>();
                adjustmentsToInsert.addAll(newAdjustments);
                Database.insert(adjustmentsToInsert);
                System.debug('Inserted new Adjustments: ' + adjustmentsToInsert);
                inserted = true;
            } catch(DMLException e){
                Database.rollback(sp);
                for(Integer i = 0; i < e.getNumDml(); i++){
                    System.debug(e.getDmlMessage(i));
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
                }
            }
        } else {
            System.debug('No Adjustments to insert!');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Adjustments were selected to be created.'));
        }
        
        return inserted;
    }
    
    /*
     * Update existing adjustment records once the Update button has been clicked
     */
    public PageReference updateExistingAdjustments(){
        Savepoint sp = Database.setSavepoint();
        
        try{
            if(existingAdjustmentsList.size() > 0){
                Database.update(existingAdjustmentsList);
                System.debug('Updated Existing Adjustments');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Adjustment(s) updated successfully!'));
            }
        } catch(Exception e){
            Database.rollback(sp);
            System.debug(e.getMessage() + ' @ ' + e.getStackTraceString());  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
        return null;
    }
    
    
    /*
     * Add a new credit to the creditWrappers list
     */ 
    public PageReference addNewCredit(){
        OLIWrapperClass creditWrapper = new OLIWrapperClass(TRUE, FALSE, String.valueOf(creditWrappers.size()));
        creditWrapper.adjustment.Adjusted_Quantity__c = -1;
        creditWrapper.adjustment.Adjusted_Discount__c = 0;
        
        creditWrappers.add(creditWrapper);
        
        return NULL;
    }
    
    /*
     * Add a new rebill to the rebillWrappers list
     */ 
    public PageReference addNewRebill(){
        OLIWrapperClass rebillWrapper = new OLIWrapperClass(FALSE, TRUE, String.valueOf(rebillWrappers.size()));
        rebillWrapper.adjustment.Adjusted_Quantity__c = 1;
        rebillWrapper.adjustment.Adjusted_Discount__c = 0;
        rebillWrappers.add(rebillWrapper);
        
        return NULL;
    }
    
    public PageReference cancel(){
        return new PageReference('/' + caseId);
    }
    
    public PageReference next(){
        if(editCredits || editRebills){
            nextButton = TRUE;
            firstPage = TRUE;
            backbutton = TRUE;
            saveButton = FALSE;
            editCredits = FALSE;
            editRebills = FALSE;
            
            System.debug('First Page: ' + firstPage);
            System.debug('Next Button: ' + nextButton);
            System.debug('Save Button: ' + saveButton);
            System.debug('Back Button: ' + backButton);
            System.debug('Edit Credits: ' + editCredits);
            System.debug('Edit Rebills: ' + editRebills);
        } else{
            nextButton = FALSE;
            saveButton = TRUE;
            firstPage = FALSE;
            backbutton = TRUE;
            editCredits = FALSE;
            editRebills = FALSE;
            
            getWrappersWeCareAbout();
            wrappersWeCareAbout = wrapperMap.values();            
            System.debug('First Page: ' + firstPage);
            System.debug('Next Button: ' + nextButton);
            System.debug('Save Button: ' + saveButton);
            System.debug('Back Button: ' + backButton);
            System.debug('Edit Credits: ' + editCredits);
            System.debug('Edit Rebills: ' + editRebills);
        } 
        
        return null;
    }
    
    public PageReference back(){
        if(firstPage){
            firstPage = FALSE;
            nextButton = TRUE;
            saveButton = TRUE;
            backButton = TRUE;
            
            if(existingCreditAdjustmentsList.size() > 0 || existingRebillAdjustmentsList.size() > 0){
                editCredits = TRUE;
                editRebills = TRUE;
            }
            
            System.debug('First Page: ' + firstPage);
            System.debug('Next Button: ' + nextButton);
            System.debug('Save Button: ' + saveButton);
            System.debug('Back Button: ' + backButton);
            System.debug('Edit Credits: ' + editCredits);
            System.debug('Edit Rebills: ' + editRebills);
        } else{
            nextButton = TRUE;
            saveButton = FALSE;
            firstPage = TRUE;
            backButton = existingCreditAdjustmentsList.size() > 0 || existingRebillAdjustmentsList.size() > 0 ? TRUE : FALSE;
               
            
            System.debug('First Page: ' + firstPage);
            System.debug('Next Button: ' + nextButton);
            System.debug('Save Button: ' + saveButton);
            System.debug('Back Button: ' + backButton);
            System.debug('Edit Credits: ' + editCredits);
            System.debug('Edit Rebills: ' + editRebills);
        }
        
        return null;
    }
    
    public PageReference save(){
        PageReference pgReturn = null;
        SavePoint sp = Database.setSavePoint();
        try{
            recalculateAllAdjustmentAmounts();
            if(existingCreditAdjustmentsList.size() > 0 || existingRebillAdjustmentsList.size() > 0){
                updateExistingAdjustments();
            }
            
            //if(wrappersWeCareAbout.size() > 0){
                if(creditWrappers.size() > 0){
                    createNewAdjustments(creditWrappers);
                }
                
                if(rebillWrappers.size() > 0){
                    createNewAdjustments(rebillWrappers);
                }
                
                insertNewAdjustments();
            //}
            //throw new UtilityClass.UtilException(''+creditWrappers);
            pgReturn = new PageReference('/' + caseId);
        }catch(Exception e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return pgReturn;
    }
    
    public PageReference removeCredit(){
        System.debug(creditId);
        System.debug(creditWrappers);
        if(creditId != NULL){
           remove(creditWrappers, creditId, 'credit'); 
        }
        
        return NULL;
    }
    
    public PageReference removeRebill(){
        System.debug(rebillId);
        System.debug(rebillWrappers);
        if(rebillId != NULL){
           remove(rebillWrappers, rebillId, 'rebill'); 
        }
        
        return NULL;
    }
    
    /*
     * Wrapper Class
     */ 
    public class OLIWrapperClass{
        public Boolean credit {get; set;}
        public Boolean rebill {get; set;}
        public OrderItem oli {get; set;}
        public Adjustment__c adjustment {get; set;}
        //MLS
        //public Stocking_to_Selling_Conversion_Factor__c conversionFactor {get; set;}
        public String wrapperid {get; set;}
        public Boolean rendered {get; set;}
        
        public OLIWrapperClass(){
            credit = FALSE;
            rebill = FALSE;
            rendered = FALSE;
            adjustment = new Adjustment__c();
        }
        
        public OLIWrapperClass(OrderItem oli, Boolean credit, Boolean rebill, String wrapperid){
            this.wrapperid = wrapperid;
            this.credit = credit;
            this.rebill = rebill;
            //this.conversionFactor = conversionFactor;
            rendered = FALSE;
            adjustment = new Adjustment__c();
            this.oli = oli;
        }
        
        public OLIWrapperClass(Boolean credit, Boolean rebill, String wrapperid){
            this.wrapperid = wrapperid;
            this.credit = credit;
            this.rebill = rebill;
            //this.conversionFactor = conversionFactor;
            rendered = TRUE;
            adjustment = new Adjustment__c();
        }
    }
}