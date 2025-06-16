/* **********************************************************************************************************************************
* Class Name   : BatchToCalculateTransactionvalue
* Description  : Class to handle Recalculation of transaction values
* Author       : Dipen
* Created On   : Dec 18,2023
* Test Class   : BatchToCalculateTransactionvalueTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         18-12-20223           1000              Initial Development
* Dipen			         18-12-20223           1001              Modified for LURP-7
**************************************************************************************************************************************/

public class BatchToCalculateTransactionvalue implements Database.Batchable<sObject>{
   Set<String> accountlevelcategoryname=new Set<String>();   
set<string> maxPayoutPromo = new set<string>();
    Map<String,Boolean> maxPayoutPromomap = new Map<string,Boolean>();
    public BatchToCalculateTransactionvalue(){ 
        //Quering metadata configuratoin information of the producted category.
        for(DefineProductLevel__mdt dpd:[Select ID,Product_Category__c, Assigned_Credential_Level__c,No_Limit__c  From DefineProductLevel__mdt]){
            if(dpd.Assigned_Credential_Level__c == 'Account'){
                accountlevelcategoryname.add(dpd.Product_Category__c);
            }                        
            if(dpd.No_Limit__c){
                maxPayoutPromomap.put(dpd.Product_Category__c,true);  
            }
            
        }
    }
    public Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator([Select Id,Rebate_Claim_Item__r.Product_Category1__c,
                                         Rebate_Claim_Item__r.ProductId,
                                         Rebate_Claim_Item__r.Rebate_Claim__r.Submitted_By__r.AccountID,
                                         Rebate_Claim_Item__r.Rebate_Claim__r.Submitted_By__c 
                                         from DPE_Base_Calculation__c where IsRecalculate__c = true]);
    }
    
    public void execute(Database.BatchableContext BC, List<DPE_Base_Calculation__c> scope){
        try{            
            Set<ID> setidfordperecords = new Set<ID>();														  //Set of Rebate Claim Items Id											
            Set<Id> assignedcredsset = new Set<ID>();														 //Set of Contractor Id             
            Map<String,Assigned_Credential__c> assignedrecord = new Map<String,Assigned_Credential__c>();     //Map to prepare Assigned Credential with Contractor        
            map<id,id> mapOfRebateClaimItemAndTransactionId = new map<id,id>(); 								//Map to prepare Rebate Claim items id and TJs id
            map<id,decimal> mapOfRebateClaimItemAndTransactionAmount = new map<id,decimal>(); 				//Map to prepare Rebate Claim items id and Transaction amount
            Set<ID> productname = new Set<Id>();  																//Set of Product Id
            Set<String> productcategoryname = new Set<String>(); 											//Set of Product Category
            Map<String,Decimal> stonefacadamountmap = new Map<String,Decimal>(); 							//Map to prepare promotion amount from ProgramRebateTypeBenefit
            Map<String,Assigned_Credential_Account__c> assignedrecordaccount = new Map<String,Assigned_Credential_Account__c>();
            List<RebateClaim> rebateclaimItemrecords = new List<RebateClaim>();
            
            //Creating map based on DPE_Base_Calculation__c and based on the queried informaiton tjs going to calculated.
            If(scope.size() > 0){
                for(DPE_Base_Calculation__c dpeobj:scope){
                    setidfordperecords.add(dpeobj.Rebate_Claim_Item__c);
                    assignedcredsset.add(dpeobj.Rebate_Claim_Item__r.Rebate_Claim__r.Submitted_By__c);
                    /*Account Id*/
                    assignedcredsset.add(dpeobj.Rebate_Claim_Item__r.Rebate_Claim__r.Submitted_By__r.AccountId);
                    
                    productname.add(dpeobj.Rebate_Claim_Item__r.ProductId);
                    productcategoryname.add(dpeobj.Rebate_Claim_Item__r.Product_Category1__c);
                }
            }            
            //Quering account credentails and will be responsible for aggregated account level calculation.        
            for(Assigned_Credential_Account__c aca:[Select Id,Credential__r.Max_Payout_Quantity__c,Account__c,Max_Payout_Quantity_Claimed__c,
                                                    Credential_Category__c from Assigned_Credential_Account__c 
                                                    where Account__c In:assignedcredsset AND Status__c = 'Active'])
            {
                if(aca.Max_Payout_Quantity_Claimed__c == null){
                    aca.Max_Payout_Quantity_Claimed__c = 0.0;
                }
                assignedrecordaccount.put(aca.Account__c+''+aca.Credential_Category__c,aca);
            }            
            //Quering Assigned Credetails from contact level for each contractore.
            for(Assigned_Credential__c acobj:[Select Id,Max_Payout_Quantity_Remaining__c,Credential__r.Max_Payout_Quantity__c,Contact__c,Max_Payout_Quantity_Claimed__c,Credential_Category__c 
                                              from Assigned_Credential__c where Contact__c In: assignedcredsset AND Status__c = 'Active'])
            {
                if(acobj.Max_Payout_Quantity_Claimed__c == null)
                {
                    acobj.Max_Payout_Quantity_Claimed__c = 0.0;
                }
                assignedrecord.put(acobj.Contact__c+''+acobj.Credential_Category__c,acobj);
                
                
            }           
            
            Decimal claimedpayoutvalue = 0.0;
            Decimal remainingac = 0.0;
            Decimal stonefacadamount = 0.0;
            Decimal stonefacadamountfortj =0.0;
            Decimal transactionjournalamount = 0.0;
            Id Accountid;
            Decimal appliedvalue = 0.0;
            Decimal percentagevaluewithappliedvalue = 0.0;
            Decimal quantityconverted = 0.0;
            Map<Id,Decimal> mapofquantityconvertedoftj = new Map<Id,Decimal>();
            List<TransactionJournal> updatetjobject = new List<TransactionJournal>();
            Set<Id> successrecrodset = new Set<Id>();            
            List<String> categoryname = new List<String>();
            categoryname.addALL(accountlevelcategoryname);//Adding Certa Value here            
            

            boolean  byPassFlag= false; /* flag to use get info either product category process will be based on limit or not*/
            /**Start of loop to calculate transaction amount and update assigned credentials*****/
            for(TransactionJournal tjrecord:[Select Id,Regular_Applied_Benefit_Amount__c,PercentageBenefit__c,DollarBenefit__c,General_Promotion_Amount__c,Applied_Benefit_Value__c,ProductId,Quantity_Converted__c,Rebate_Claim_Item__r.Product_Category1__c,
                                             Stone_Facade_Rebate_Amount__c,Quantity,UOMConversionFactor__c,
                                             TransactionAmount,Product.Product_Category__c,Rebate_Claim__r.Submitted_By__r.AccountId,
                                             Rebate_Claim__r.Submitted_By__c,Rebate_Claim_Item__c  
                                             from TransactionJournal where Rebate_Claim_Item__r.Product_Category1__c IN:categoryname AND 
                                             Rebate_Claim_Item__c In :setidfordperecords ORDER By Rebate_Claim_Item__r.name ASC])
            {       
                byPassFlag = false;//Default value so that no impact on other category.                
                if(maxPayoutPromomap.containskey(tjrecord.Product.Product_Category__c)){
                    byPassFlag = maxPayoutPromomap.get(tjrecord.Product.Product_Category__c);
                }
                TransactionJournal tj_obj = new TransactionJournal();
                tj_obj.Id = tjrecord.Id;
                Assigned_Credential__c instanceobj;
                Assigned_Credential_Account__c accountinstanceobj;                                 
                Accountid                       = tjrecord.Rebate_Claim__r.Submitted_By__r.AccountId;
                stonefacadamountfortj           = tjrecord.General_Promotion_Amount__c;
                transactionjournalamount        = 0.0;
                stonefacadamount                = 0.0;
                 percentagevaluewithappliedvalue = 0.0;
                appliedvalue      = 0.0;
                quantityconverted = (tjrecord.Quantity * tjrecord.UOMConversionFactor__c);
                
                //Logic to check the category name
                if(accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c)){  //Account Level Permotion
                    if(assignedrecordaccount.containskey(Accountid+''+tjrecord.Product.Product_Category__c)){
                        accountinstanceobj = assignedrecordaccount.get(Accountid+''+tjrecord.Product.Product_Category__c);//Account Value
                    }
                    if(assignedrecord.containskey(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c)){
                        instanceobj = assignedrecord.get(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c);//Contact value
}
                }
                //Code to correct the applied value
                        appliedvalue = tjrecord.Applied_Benefit_Value__c;//Default value
                        if(tjrecord.DollarBenefit__c != null && tjrecord.DollarBenefit__c > 0.0){                            
                            appliedvalue =  tjrecord.Applied_Benefit_Value__c > 0.0? (tjrecord.Applied_Benefit_Value__c-tjrecord.DollarBenefit__c):0.0; 	
                        }else if(tjrecord.PercentageBenefit__c != null){                            
                            percentagevaluewithappliedvalue = tjrecord.PercentageBenefit__c/100; 
                            appliedvalue = tjrecord.Applied_Benefit_Value__c > 0.0?(tjrecord.Applied_Benefit_Value__c/(1+percentagevaluewithappliedvalue)):0.0;
                        }
                if(byPassFlag){
                    if(accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c)){
                        //Adding converted value in the map.
                        mapofquantityconvertedoftj.put(tjrecord.Rebate_Claim_Item__c,quantityconverted);                        
                        //PK-- assignedrecord.put(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c,instanceobj);
                        /*Code block responsible to calculate value*/
                        stonefacadamount         = (stonefacadamountfortj * quantityconverted).setScale(2);
                        transactionjournalamount = (appliedvalue * quantityconverted) + stonefacadamount;                                
                        tj_obj.TransactionAmount = transactionjournalamount;
                        tj_obj.Regular_Applied_Benefit_Amount__c = appliedvalue;
                        if(tjrecord.DollarBenefit__c != null && tjrecord.DollarBenefit__c >0.0){
                            tj_obj.TransactionAmount = transactionjournalamount + (quantityconverted * tjrecord.DollarBenefit__c);                                
                        }else if(tjrecord.PercentageBenefit__c != null){
                            tj_obj.TransactionAmount = transactionjournalamount + (transactionjournalamount * tjrecord.PercentageBenefit__c/100);
                        }
                        tj_obj.Stone_Facade_Rebate_Amount__c = stonefacadamount;
                        updatetjobject.add(tj_obj);
                        
                        accountinstanceobj.Max_Payout_Quantity_Claimed__c =  accountinstanceobj.Max_Payout_Quantity_Claimed__c + quantityconverted;
                        assignedrecordaccount.put(Accountid+''+tjrecord.Product.Product_Category__c,accountinstanceobj); 
                        
                        instanceobj.Max_Payout_Quantity_Claimed__c =  instanceobj.Max_Payout_Quantity_Claimed__c + quantityconverted;
                        assignedrecord.put(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c,instanceobj); 
                        
                        /****Updating amount on rebate claim line items*********/
                        RebateClaim rebateclaimsobj = new RebateClaim();
                        rebateclaimsobj.Id = tjrecord.Rebate_Claim_Item__c;
                        rebateclaimsobj.ClaimAmount = tj_obj.TransactionAmount;
                        rebateclaimItemrecords.add(rebateclaimsobj);
                    }
                }
                
                if(!byPassFlag){                  
                    
                    if(accountinstanceobj != null && instanceobj != null && accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c) 
                    &&  (accountinstanceobj.Credential__r.Max_Payout_Quantity__c - accountinstanceobj.Max_Payout_Quantity_Claimed__c) > 0.0)
                {                     
                        
                        if(accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c)){
                            claimedpayoutvalue = accountinstanceobj.Max_Payout_Quantity_Claimed__c + quantityconverted; 
                        }    
                        //If contractor is getting all the claimed value then this code block will calculate the value
                        if(claimedpayoutvalue <= instanceobj.Credential__r.Max_Payout_Quantity__c){   
                            /*Adding New Payout value in Map*/                           
                            if(accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c)){
//Adding converted value in the map.
                        		mapofquantityconvertedoftj.put(tjrecord.Rebate_Claim_Item__c,quantityconverted);
                                
                                accountinstanceobj.Max_Payout_Quantity_Claimed__c =  accountinstanceobj.Max_Payout_Quantity_Claimed__c + quantityconverted;
                                assignedrecordaccount.put(Accountid+''+tjrecord.Product.Product_Category__c,accountinstanceobj);
                                /*Contact level Update*/ 
                                instanceobj.Max_Payout_Quantity_Claimed__c =  instanceobj.Max_Payout_Quantity_Claimed__c + quantityconverted;
                                assignedrecord.put(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c,instanceobj);
                                                                /*Code block responsible to calculate value*/
                                stonefacadamount         = (stonefacadamountfortj * quantityconverted).setScale(2);
                                transactionjournalamount = (appliedvalue * quantityconverted) + stonefacadamount;                                
                                tj_obj.TransactionAmount = transactionjournalamount;
                                tj_obj.Regular_Applied_Benefit_Amount__c = appliedvalue;
                                if(tjrecord.DollarBenefit__c != null && tjrecord.DollarBenefit__c >0.0){
                                    tj_obj.TransactionAmount = transactionjournalamount + (quantityconverted * tjrecord.DollarBenefit__c);	
                                }else if(tjrecord.PercentageBenefit__c != null){
                                    tj_obj.TransactionAmount = transactionjournalamount + (transactionjournalamount * tjrecord.PercentageBenefit__c/100);
                                }
                            }
                        }else if(instanceobj.Credential__r.Max_Payout_Quantity__c > instanceobj.Max_Payout_Quantity_Claimed__c){ //Contractor is going to get some part of him calim/                           
                            /*Adding New Payout value in Map*/
                            if(accountlevelcategoryname.contains(tjrecord.Rebate_Claim_Item__r.Product_Category1__c)){//Certaplank
                                remainingac = accountinstanceobj.Credential__r.Max_Payout_Quantity__c - accountinstanceobj.Max_Payout_Quantity_Claimed__c;// remainingac used to get remaining portion of payout amount.

                                 //Adding converted value in the map.
                                mapofquantityconvertedoftj.put(tjrecord.Rebate_Claim_Item__c,remainingac);
                                
                                accountinstanceobj.Max_Payout_Quantity_Claimed__c =  accountinstanceobj.Max_Payout_Quantity_Claimed__c + remainingac;
                                assignedrecordaccount.put(Accountid+''+tjrecord.Product.Product_Category__c,accountinstanceobj); 
                                /*Contact level Update*/   
                                instanceobj.Max_Payout_Quantity_Claimed__c =  instanceobj.Max_Payout_Quantity_Claimed__c + remainingac;
                                assignedrecord.put(tjrecord.Rebate_Claim__r.Submitted_By__c+''+tjrecord.Product.Product_Category__c,instanceobj); 
                                
                                /*Code block responsible to calculate value*/
                                stonefacadamount = ((stonefacadamountfortj * remainingac)).setScale(2);
                                transactionjournalamount = (appliedvalue * quantityconverted) + stonefacadamount; 
                                tj_obj.TransactionAmount = transactionjournalamount;
                                tj_obj.Regular_Applied_Benefit_Amount__c = appliedvalue;
                                if(tjrecord.DollarBenefit__c != null && tjrecord.DollarBenefit__c >0.0){
                                    tj_obj.TransactionAmount = transactionjournalamount + (quantityconverted * tjrecord.DollarBenefit__c);	
                                }else if(tjrecord.PercentageBenefit__c != null){
                                    tj_obj.TransactionAmount = transactionjournalamount + (transactionjournalamount * tjrecord.PercentageBenefit__c/100);
                                }                                
                            }                            
                        }
                        }else{
                        tj_obj.TransactionAmount = transactionjournalamount + (appliedvalue * quantityconverted);
                    if(tjrecord.DollarBenefit__c != null && tjrecord.DollarBenefit__c >0.0){            //Modified for LURP-7
                        tj_obj.TransactionAmount = tj_obj.TransactionAmount + (quantityconverted * tjrecord.DollarBenefit__c);	
                    }else if(tjrecord.PercentageBenefit__c != null){
                        tj_obj.TransactionAmount = tj_obj.TransactionAmount + (tj_obj.TransactionAmount * tjrecord.PercentageBenefit__c/100);                        
                    }
                    }
                tj_obj.Stone_Facade_Rebate_Amount__c = stonefacadamount;
                updatetjobject.add(tj_obj);
                
                /****Updating amount on rebate claim line items*********/
                RebateClaim rebateclaimsobj = new RebateClaim();
                rebateclaimsobj.Id = tjrecord.Rebate_Claim_Item__c;
                rebateclaimsobj.ClaimAmount = tj_obj.TransactionAmount;
                rebateclaimItemrecords.add(rebateclaimsobj);
                
                mapOfRebateClaimItemAndTransactionId.put(tjrecord.Rebate_Claim_Item__c,tjrecord.id);
            }
                
            } 
            //Updating the assigned credentails and account assigned credentails value.
            List<sObject> updatesobject = new List<sObject>();
            updatesobject.addAll(assignedrecord.values());
            updatesobject.addAll(assignedrecordaccount.values());

            if(!updatesobject.isEmpty()){
                Database.update(updatesobject);
            }
            
            
            List<Database.SaveResult> saveresultlist =  Database.update(updatetjobject);
            for (Database.SaveResult sr: saveresultlist) {
                if (sr.isSuccess()) {
                    successrecrodset.add(sr.getId()); 
                } 
            }  

            //Change IsRecalculate__c false so that batch will not pick the same record again.
            List<DPE_Base_Calculation__c> dpebaserecords = new List<DPE_Base_Calculation__c>();
            for(DPE_Base_Calculation__c deprecrod:[Select Id,IsRecalculate__c,Rebate_Claim_Item__c,Transaction_Journal__c from DPE_Base_Calculation__c where Rebate_Claim_Item__c In (Select Rebate_Claim_Item__c From TransactionJournal where Id IN:successrecrodset)]){
                DPE_Base_Calculation__c dpeobj = new DPE_Base_Calculation__c();
                dpeobj.Id                     = deprecrod.Id;
                dpeobj.IsRecalculate__c       = false;
dpeobj.Quantity_Converted__c  = mapofquantityconvertedoftj.get(deprecrod.Rebate_Claim_Item__c);
                dpeobj.Transaction_Journal__c = mapOfRebateClaimItemAndTransactionId.get(deprecrod.Rebate_Claim_Item__c);
                dpebaserecords.add(dpeobj);
            }
            
            Database.update(dpebaserecords);           
            Database.update(rebateclaimItemrecords);           
            
        }catch(Exception ex){             
            HandleCustomLogsException.LogException(ex);
        }   
    }
    public void finish(Database.BatchableContext BC){
    } 
}