global with sharing class IncentiveLoadToSAP {
    
    global final static String APPROVED = 'Approved';        
    
    global with sharing class IncentiveDetails{
        
        //webservice String Id;
        webservice String IncentiveName;
        webservice String SAPContactNumber;
        webservice String SalesOrg;
        webservice String Hierarchy;        
        webservice DateTime StartDate;
        webservice DateTime EndDate;
        webservice String ApprovalStatus;
        webservice List<IncentiveProductDetails> IncentiveProducts;
    }
    
    global with sharing class IncentiveProductDetails{
        
        webservice String IncentiveProductId;
        webservice String IncentiveProductName;
        webservice String ConditionType;
        webservice String ConditionTable;
        webservice String Division;
        webservice String PriceGroup;
        webservice String IDC;
        webservice String CorporateClass;
        webservice String MarketFamily;
        webservice String RebateGroupType;
        webservice String ProductType;
        webservice String Amount;
        webservice String AccuralRate;
        webservice String Unit;
        webservice String SoldToParty;
        webservice List<IncentiveGateDetails> IncentiveGates;
    
    }
    
    global with sharing class IncentiveGateDetails{
    
        webservice String BaselineAmount;
        webservice List<GateDetails> Gate;
    
    }
    global with sharing class GateDetails{
           
        webservice String LowerAmount;
        webservice String UpperAmount;
        webservice String PerOfRebateSales;
    
    }
  
    webservice static List<IncentiveDetails> getIncentiveDetails() {

        List<IncentiveDetails> incentiveDetailsList = new List<IncentiveDetails>();                 
        
//-----------
List<IncentiveProductDetails> incentiveProdDetailsList;
        List<IncentiveGateDetails> incentiveGateDetailsList;        
        
        IncentiveDetails incentiveDetail;
        IncentiveProductDetails incentiveProductDetail;
        IncentiveGateDetails incentiveGateDetail; 
        //Map<Id, Incentive__c> incentiveMap = new Map<Id, Incentive__c>();
      //  Map<Id, List<Incentive_Product__c>> incProductMap = new Map<Id, List<Incentive_Product__c>>();
      //  Map<Id,List<Incentive_Gate__c>> incGateMap = new Map<Id,List<Incentive_Gate__c>>();
       // List<Incentive__c> incentiveList;
      //  List<Incentive_Product__c> incentiveProdList;
        
         // reteriving incentive details
      //incentiveList = [SELECT Id, Name, SAP_Contract_Number__c, Sales_Org__c, Hierarchy__c, Start_Date__c, End_Date__c, Status__c FROM Incentive__c WHERE Status__c = :APPROVED];                                             
         
        //adding incetive id into set
        Set<Id> incentiveId = new Set<Id>();
      /*  if(incentiveList != null ){
            for(Incentive__c inc : incentiveList){
                incentiveId.add(inc.Id);
                incentiveMap.put(inc.Id, inc);
            }
            incentiveProdList = [SELECT Id, Name, Condition_Type__c, Condition__c, Division__c, Price_Group__c, Incentive__c, IDC__c, Sold_to_Party__c, Corp_Class__c, Market_Family__c, Rebate_Group_Type__c, Product_Type__c, Amount__c, Unit__c, (SELECT Id, Baseline_Amount__c, Amount__c, Upper_Amount__c, Percent_of_Rebate_Sales__c FROM Incentive_Gates__r WHERE active_gate__c=True ORDER BY Percent_of_Rebate_Sales__c ASC NULLS last) FROM Incentive_Product__c WHERE Incentive__c In :incentiveId AND Send_to_SAP__c= True AND Sent_to_SAP__c= False];
            system.debug('Incentive product List is ' + incentiveProdList);
        }
        
        if(incentiveProdList != null){
            
            for(Incentive_Product__c incProduct : incentiveProdList){
                
                if(!incProductMap.containsKey(incProduct.Incentive__c)){
                    incProductMap.put(incProduct.Incentive__c, new List<Incentive_Product__c>());
                }
                incProductMap.get(incProduct.Incentive__c).add(incProduct);
                
                List<Incentive_Gate__c> gateList = new List<Incentive_Gate__c>();
                for(Incentive_Gate__c gate : incProduct.Incentive_Gates__r){                    
                    gateList.add(gate);
                }
                if(!gateList.isEmpty()){
                    incGateMap.put(incProduct.id ,gateList);
                }
            }
        }
                /*for(Id incId : incProductMap.keySet()){
                    Incentive__c incentive = incentiveMap.get(incId);
                    incentiveDetail = new IncentiveDetails();

                    incentiveDetail.IncentiveName = incentive.Name;
                    incentiveDetail.SAPContactNumber = incentive.SAP_Contract_Number__c;
                    incentiveDetail.SalesOrg = incentive.Sales_Org__c;
                    incentiveDetail.Hierarchy = incentive.Hierarchy__c;
                    incentiveDetail.StartDate = incentive.Start_Date__c;
                    incentiveDetail.EndDate = incentive.End_Date__c;
                    incentiveDetail.ApprovalStatus = incentive.Status__c;

                    incentiveProdDetailsList = new List<IncentiveProductDetails>();
                    if(incProductMap.containsKey(incId)){
                        for(Incentive_Product__c product : incProductMap.get(incId)){
                            incentiveProductDetail = new IncentiveProductDetails();
                            incentiveProductDetail.IncentiveProductId = product.Id;
                            incentiveProductDetail.IncentiveProductName = product.Name;
                            incentiveProductDetail.ConditionType = product.Condition_Type__c;
                            incentiveProductDetail.ConditionTable = product.Condition__c;
                            incentiveProductDetail.Division = product.Division__c;
                            incentiveProductDetail.PriceGroup = product.Price_Group__c;
                            incentiveProductDetail.IDC = product.IDC__c;
                            incentiveProductDetail.CorporateClass = product.Corp_Class__c;
                            incentiveProductDetail.MarketFamily = product.Market_Family__c;
                            //incentiveProductDetail.RebateGroupType = product.Rebate_Group_Type__c;
                            incentiveProductDetail.RebateGroupType = product.Corp_Class__c;
                            incentiveProductDetail.ProductType = product.Product_Type__c;
                            incentiveProductDetail.Amount = String.ValueOf(product.Amount__c);
                            incentiveProductDetail.AccuralRate = String.ValueOf(product.Amount__c);
                            incentiveProductDetail.Unit = product.Unit__c;
                            incentiveProductDetail.SoldToParty = product.Sold_to_Party__c;

                            incentiveGateDetailsList = new List<IncentiveGateDetails>();
                            if(incGateMap.containsKey(product.id)){
                                for(Incentive_Gate__c incGate : incGateMap.get(product.id)){                     
                                    incentiveGateDetail = new IncentiveGateDetails();                           
                                    incentiveGateDetail.BaselineAmount = String.ValueOf(incGate.Baseline_Amount__c);
                                    List<GateDetails> gateDetailsList = new List<GateDetails>();
                                        //for(Integer i= 0 ; i <= 4; i++){
                                            GateDetails gateDetail = new GateDetails();
                                            gateDetail.LowerAmount = String.ValueOf(incGate.Amount__c);
                                            gateDetail.UpperAmount = String.ValueOf(incGate.Upper_Amount__c);
                                            gateDetail.PerOfRebateSales = String.ValueOf(incGate.Percent_of_Rebate_Sales__c);
                                            gateDetailsList.add(gateDetail);
                                       // }
                                    incentiveGateDetail.Gate = gateDetailsList;                                                                 
                                    incentiveGateDetailsList.add(incentiveGateDetail);
                                                   
                                }
                            }
                            incentiveProductDetail.IncentiveGates = incentiveGateDetailsList;
                            incentiveProdDetailsList.add(incentiveProductDetail);                           
                        }
                    }
                    incentiveDetail.IncentiveProducts = incentiveProdDetailsList;       
                    incentiveDetailsList.add(incentiveDetail);         
                                        
                }*/ 
//-----------
        return incentiveDetailsList;
    }   
}