/**
 * @description This class has been used to hadle claim from Internal site which includes claim creation.
*/
public with sharing class WOD_InternalClaimController {
    public WOD_InternalClaimController() {
        
    }
    /**
     * @description This method used for get Claim Details
     * @param claimId Claim Id
     * @return Wrapper
    */
    @AuraEnabled
    public static ClaimResponseWrapper getClaimInformation(String claimId){
        ClaimResponseWrapper response=new ClaimResponseWrapper();
        WOD_Claim_Interested_Parties__c distributor=new WOD_Claim_Interested_Parties__c();
        if(claimId != null && claimId != ''){
            WOD_2__Claim__c claim=[SELECT Id,Name,Rush_Claim__c,Rush__c,Warranty_Registration_Type__c,WOD_2__Claim_Type__c,
                                   WOD_2__Claim_Status__c,Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Tape_Code_D__c,
                                   Plant__c,Material_Sub_Total__c,Labor_Reinstall_Sub_Total__c,Labor_Tear_off_Sub_Total__c,Complaint_Total__c,Quality_RMA__c,
                                   Shipping_Method__c,Producing_Plant__c,ShortTerm_Note__c,Send_Letter_to__c,
                                   Total_Squares__c,Squares_Applied__c,Squares_In_Whse__c,Squares_Not_Applied__c,Voucher1_Amount__c,Voucher2_Amount__c,
                                   IsShortTermClmUpd__c,Property_Type__c,Home_Insurance_applicable__c,isClassAction__c,Is_Fiberglass_Horizon_Class_Action__c,Product_Group__c,
                                   First_Name__c, Last_Name__c, Address_1__c, Address_2__c, City__c, Custom_State__c, Zip_Code_Postal_Code__c, Country__c,
                                   Co_Owner_First_Name__c, Co_Owner_Last_Name__c, Phone__c, Email__c, WOD_2__BusinessCategory__c,
                                   OwnershipType__c, Building_Type__c,Undetermined_Settlement__c,Plant__r.Name,WOD_2__Warranty_Product__r.Name,
                                   Distributor_s_PO__c, material_quantity__c, Invoice_Number__c, CertainTeed_s_EX_No__c, WOD_2__Warranty_Product__c,
                                   Install_Date__c, Quantity__c, Resolution__c, Comments__c,Credit_Sold_To__r.Name, Credit_Ship_To1__c,Credit_Ship_To1__r.Name,
                                   First_Name_BL__c, Last_Name_BL__c, Address_1_BL__c, Address_2_BL__c,City_BL__c, State_BL__c, Postal_Code_BL__c, Country_BL__c,
                                   Installation_Location__c, Co_Owner_First_Name_Mailing__c, Co_Owner_Last_Name_Mailing__c, Organization__c, State__c, Standard_Samples__c,
                                   Standard_Photos__c, Square_Amt_Documentation__c, Date_of_App_Documentation__c, Proof_of_Ownership__c, Proof_of_Current_Ownership__c,
                                   Standard_Claim_Form__c, Standard_Slope__c,Business_Units__c, Organization_BL__c,Installation_Location_other__c,
                                   Total_Quantity_of_Complaint_Material__c ,  Date_Reported__c , Date_Investigated__c , Type_of_Applicator__c ,  Property_Name__c ,
                                   Material__c , Material_Unit_Cost__c ,  Labor_Tear_off_Squares__c , Labor_Tear_off_UnitCost__c ,  Labor_Reinstall_Squares__c ,
                                   Labor_Reinstall_Unit_Cost__c ,  Miscellaneous_1__c , Miscellaneous_cost_2__c, Miscellaneous_cost_3__c , Miscellaneous_cost_4__c ,
                                   Miscellaneous_cost_5__c , Misc1_cost_description__c , Misc2_cost_description__c , Misc3_cost_description__c , Misc4_cost_description__c ,
                                   Misc5_cost_description__c ,  Inspection_Comments__c, Settlement_Verification__c , Samples__c , Photos__c , Documentation__c , WOD_2__Comments__c,
                                   Unit_of_Measure__c,Unit_of_Measure_for_Material_Quantity__c,Primary_Defect_Code__c,Primary_Defect_Code__r.Name,Secondary_Defect_Code__c,Secondary_Defect_Code__r.Name,
                                   Plant_Code__c, Affected_Walls__c, Defect_Details__c, Resolution_Code__c, Classification__c, Priority__c, Proof_of_Purchase__c,Territory__c,Territory__r.Name,

                                   No_Cost_Material__c,Credit__c,GELCO_Voucher_1__c,GELCO_Voucher_2__c,Check__c,Is_Migrated__c,
                                   Quality_RMA_Sold_To_Party__c,Quality_RMA_Ship_To_Party__c,Quality_RMA_Contact_Name__c,Quality_RMA_Contact_Phone__c,
                                   Quality_RMA_Contact_Email__c,Case_Number__c,RMA_Number__c,Original_Order_Number__c,Original_PO_Number__c,Sold_To_Party__c,
                                   Ship_To_Party__c,Contact_Name__c,Shipping_Options__c,Contact_Phone__c,Contact_Email__c,Ship_w_PO_No__c,Cost_Material_Comment__c,
                                   Order_for__c,Ship_to__c,Credit_Sold_To__c,Credit_Amount__c,Sold_To_Info_Credit__c,Ship_To_Info_Credit__c,
                                   Voucher1_No__c,Voucher1_Issued_Date__c,Voucher_Issued_To1__c,Voucher2_No__c,Voucher2_Issued_Date__c,
                                   Voucher_Issued_To2__c,Check_Payable_to__c,Check_Address__c,Check_City__c,Check_State__c,Check_Zip_Code_Postal_Code__c,
                                   Check_Country__c,Check_Amount__c,Quality_RMA_Sold_To_Party__r.Name,Quality_RMA_Ship_To_Party__r.Name,Sold_To_Party__r.Name,Ship_To_Party__r.Name,
                                   Extended_Warranty_Registration_Number__c,Paper_File__c,Alternate_Mailing_Address__c,Warranty_Years__c,Specification__c,Required_Fee__c,
                                   Installing_Contractor__c,Debit__c,Debit_Sold_To__c,Debit_Ship_To1__c,Debit_Amount__c,Sold_To_Info_Debit__c,Ship_To_Info_Debit__c,
                                   Debit_Sold_To__r.Name,Debit_Ship_To1__r.Name,
                                   Pcs_Front__c,Sq_Ft_Claimed_Front__c,Pcs_Right__c,Sq_Ft_Claimed_Right__c,Pcs_Back__c,Sq_Ft_Claimed_Back__c,Pcs_Left__c,Sq_Ft_Claimed_Left__c,
                                   Total_Pcs__c,Total_Square_Ft_Claimed__c,FCA_Claim__c,Is_New_Construction__c,Is_New_Construction_Mailing_Address__c,Transferred_Date__c,
                                   Insurance_claimed_Amount__c,Insurance_Claimed_Date__c,Affected_Walls_Other__c, Email_JS__c, Phone_JS__c,Carrier__c,Tracking_Numbers__c,Division_Code__c   
                                   FROM WOD_2__Claim__c WHERE Id =: claimId];
            
            response.claim=claim;
            if(claim.WOD_2__Claim_Type__c == 'International'){
               distributor= [SELECT Id,Claim__c,First_Name__c, Last_Name__c, Address_1__c, Address_2__c, City__c, Custom_State__c, Zip_Code__c, Country__c,
                 Organization__c, Phone__c , Email__c FROM WOD_Claim_Interested_Parties__c 
                 WHERE Claim__c =:claimId  AND Type__c = 'Distributor' ORDER BY CreatedDate ASC LIMIT 1];
               response.distributor=distributor;
            }
            response.status=true;    
            response.divOptions= WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Division_Code__c',false);
        }
        return response;
    }
    /**
     * @description This method used for create/update Claim.
     * @param claim Serialized Claim Record
     * @param distributor Serialized Claim Interested Parties Record.
     * @param shippingProductList Serialized List of Shipping Products Record.
     * @return Wrapper
    */
    @AuraEnabled
    public static ResponseWrapper saveClaim(String claim,String distributor,String shippingProductList){
        WOD_2__Claim__c objClaim=new WOD_2__Claim__c();
        ResponseWrapper response=new ResponseWrapper('',false,'');
        Id claimId;
        Boolean isPreClaim = true;
        Double totalAmt=0;
        List<WOD_Shipping_Products__c> productList=new List<WOD_Shipping_Products__c>();
        WOD_Claim_Interested_Parties__c objDistributor=new WOD_Claim_Interested_Parties__c();
        WOD_2__Business_Category_Configuration__c bu=new  WOD_2__Business_Category_Configuration__c ();
        List<WOD_CT_SAP_Vendor_Number__mdt> vendorSAPNumberList=new List<WOD_CT_SAP_Vendor_Number__mdt>();
        Map<String,String> vendorMap=new Map<String,String>();
        List<Plants__c> facilityCode = new List<Plants__c>();
        try{
            objClaim=(WOD_2__Claim__c)JSON.deserialize(claim, WOD_2__Claim__c.class);
            System.debug('Claim Data '+objClaim);
            if(distributor != null && distributor != ''){
                 objDistributor=(WOD_Claim_Interested_Parties__c)JSON.deserialize(distributor, WOD_Claim_Interested_Parties__c.class);
            }
           
            if(shippingProductList != null && shippingProductList != ''){
                 productList=(List<WOD_Shipping_Products__c>)JSON.deserialize(shippingProductList, WOD_Shipping_Products__c.class);
            }
            
            bu=[SELECT Id,Name FROM WOD_2__Business_Category_Configuration__c WHERE Id =: objClaim.WOD_2__BusinessCategory__c LIMIT 1];
            
            //objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get(recortype).getRecordTypeId();
            objClaim.WOD_2__BusinessCategory__c=bu.Id;
            // if(objClaim.OwnershipType__c != null && objClaim.OwnershipType__c != ''){
            //     objClaim.OwnershipType__c='<span style="color:red">'+objClaim.OwnershipType__c+'</span>';
            // }
           // objClaim.Business_Units__c=bu.Name;
           /* CER-211 Divya
            if(objClaim.WOD_2__Claim_Type__c=='Standard' && bu.Name=='Commercial Building & Infrastructure'){
                system.debug('--Passing---');
                if(objClaim.Extended_Warranty_Registration_Number__c != null  && objClaim.Extended_Warranty_Registration_Number__c != ''){
                    //objClaim.WOD_2__Claim_Type__c='Commercial NDL Limited Warranty';
                    system.debug('--Passing if---');
                }
                else{
                    //objClaim.WOD_2__Claim_Type__c='Commercial Limited Warranty';
                    system.debug('--Passing else---');
                }
            }
            
            if(objClaim.WOD_2__Claim_Type__c =='Commercial NDL Limited Warranty'){
                objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get('Commercial Extended Warranty(NDL)').getRecordTypeId();
            }
            else if(objClaim.WOD_2__Claim_Type__c =='Commercial Limited Warranty'){
                objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
            }
            else */
            if (objClaim.WOD_2__Claim_Status__c == 'Pre-Claim' || objClaim.WOD_2__Claim_Status__c == 'Need more Information') {
            	new WOD_ClaimTriggerHandler().calcSalesOrgonInsert(objclaim);//CER-211
            }
            {
                objclaim.RecordTypeId = [Select id from RecordType Where Name =: objClaim.WOD_2__Claim_Type__c OR  DeveloperName =: objClaim.WOD_2__Claim_Type__c LIMIT 1].Id;
            }
            if((objClaim.WOD_2__Claim_Status__c != 'Pre-Claim' && objClaim.WOD_2__Claim_Status__c != 'Need more Information' &&  objClaim.WOD_2__Claim_Status__c != 'Claim') || objClaim.isLocked__c){
                isPreClaim = false;
            }
            if((objClaim.WOD_2__Claim_Type__c =='Commercial_Extended_Warranty_NDL') /* CER-211|| (objClaim.WOD_2__Claim_Type__c =='Commercial Limited Warranty') || (objClaim.WOD_2__Claim_Type__c =='Commercial NDL Limited Warranty')) */ && objClaim.WOD_2__Claim_Status__c == 'Claim'){
                isPreClaim = true;
            } 
            //Added logic for plant
            if(bu.Name=='Roofing' || bu.Name=='Commercial Building & Infrastructure' || bu.Name=='Solar Solutions'){//CER-211
                if(String.isBlank(objClaim.WOD_2__Warranty_Product__c)){
                    objClaim.WOD_2__Warranty_Product__c=null;
                }
                if(objClaim.WOD_2__Warranty_Product__c != null && objClaim.Plant__c == null){
                    objClaim.Plant__c=WOD_WarrantyProductWrapper.getProductDetails(objClaim.WOD_2__Warranty_Product__c,true).get('PlantCode');
                }
            }
            //getting SAP vendor number from metadata
            vendorSAPNumberList =[Select Id,Label,DeveloperName,WOD_SAP_Vendor_Number__c from WOD_CT_SAP_Vendor_Number__mdt];
            if(vendorSAPNumberList != null && vendorSAPNumberList.size()>0){
                for(WOD_CT_SAP_Vendor_Number__mdt vendorMt:vendorSAPNumberList){
                    vendorMap.put(vendorMt.DeveloperName,vendorMt.WOD_SAP_Vendor_Number__c);
                } 
                //if(bu.Name=='Roofing'){
                    if(bu.Name=='Roofing' || bu.Name=='Commercial Building & Infrastructure' || bu.Name=='Solar Solutions'){//CER-211
                    if(objClaim.isClassAction__c == true || objClaim.Is_Fiberglass_Horizon_Class_Action__c==true){
                        objClaim.SAP_Vendor_Number__c = vendorMap.get('ClassAction');
                    }
                    else if(objClaim.Country_BL__c =='Canada'){
                        objClaim.SAP_Vendor_Number__c = vendorMap.get('Standard_CAN');
                    } else{
                        objClaim.SAP_Vendor_Number__c = vendorMap.get('Standard');
                    }
                }
                if(bu.Name=='Siding'){
                    if(objClaim.isClassAction__c == true)
                        objClaim.SAP_Vendor_Number__c = vendorMap.get('ClassAction_S');
                    else if(objClaim.isClassAction__c == false)
                        objClaim.SAP_Vendor_Number__c = vendorMap.get('Standard_S'); 
                }
            }
                        
            if(objClaim.Rush_Claim__c){
                objClaim.Rush__c='<b><span style="color:red;font-size:Medium;">RUSH</span></b>';
            }else{
                objClaim.Rush__c='';
            }
            if(objClaim.Warranty_Registration_Type__c == '' || objClaim.Warranty_Registration_Type__c == null){
                objClaim.Warranty_Registration_Type__c = 'Standard';
            }
            WOD_Claimhandler objhandler = new WOD_Claimhandler();
            
            if(objClaim.Plant__c != null){
                facilityCode=[Select Facility_Code__c,SAP_Plant__c,Plant_code__c from Plants__c where Id =: objClaim.Plant__c];
                if(facilityCode != null && facilityCode.size() > 0){
                    objClaim.Plant_Code__c=facilityCode[0].SAP_Plant__c;
                }
            }
            
            if(objClaim.WOD_2__Claim_Type__c !='International'){
                WOD_TerritoryManger ctTM=new WOD_TerritoryManger(); 
                String zipCode=objClaim.Postal_Code_BL__c;
                if(objClaim.Postal_Code_BL__c !=null && objClaim.Postal_Code_BL__c !=''){
                    if(objClaim.Postal_Code_BL__c.contains('-')){
                        String[] zip=objClaim.Postal_Code_BL__c.split('-');
                        zipCode=zip[0];
                    }
                }

                if(bu.Name=='Roofing' || bu.Name == 'Solar Solutions' || bu.Name == 'Commercial Building & Infrastructure'){
                    /*
                    string strPropertyType=''; //CER-211
                    if(bu.Name == 'Roofing' || bu.Name == 'Solar Solutions'){
                        strPropertyType ='Residential';
                    }else if(bu.Name == 'Commercial Building & Infrastructure'){
                        strPropertyType ='Commercial';
                    } 
                    */ //CER-211
                    List<String> resTM = new List<String>();
                    //List<String> resTM=ctTM.populateTM(objClaim.State_BL__c,zipCode,objClaim.Property_Type__c,objClaim.Country_BL__c, objClaim.City_BL__C /*TECP-731*/);
                    if(objClaim.Sales_Org__c!=null ){
                        resTM=ctTM.populateTM(objClaim.State_BL__c,zipCode,'',objClaim.Country_BL__c, objClaim.City_BL__C ,objClaim.Sales_Org__c, objClaim.Division_Code__c/*TECP-731*/);
                        if(resTM!=null && resTM.size()>0){
                            objClaim.Territory__c=resTM[0];
                            objClaim.Territory_Manager__c=resTM[1];
                        }
                    }
                    system.debug('resTM--' + resTM);
                }
                
            }
            
                        
            if(objClaim.WOD_2__Claim_Type__c == 'Short Term'){
                assignShipToInfo(objClaim);
                assignSoldToiInfo(objClaim);
                //CER-5 : Quality RMA changes
               // objClaim.Quality_RMA__c = rmaQuality;
               //Divya 
               if(objClaim.WOD_2__Warranty_Product__c!= null){
                   String fc= WOD_WarrantyProductWrapper.getProductDetails(objClaim.WOD_2__Warranty_Product__c, true).get('facilityCode');
                   if(fc !=null && fc !=''){
                      objClaim.Producing_plant_code__c=fc;
                   }
               }
            
            
            if(isPreClaim){
                system.debug('tapeB'+objClaim.Tape_Code_A__c+'-->B'+objClaim.Tape_Code_A__c+'-->C'+objClaim.Tape_Code_C__c+'-->D'+objClaim.Tape_Code_D__c);
                if(objClaim.Tape_Code_A__c !=null){
                    objClaim.Tape_Code_A__c=objClaim.Tape_Code_A__c.replace('&#160;',' ');
                }
                if(objClaim.Tape_Code_B__c !=null){
                    objClaim.Tape_Code_B__c=objClaim.Tape_Code_B__c.replace('&#160;',' ');
                }
                if(objClaim.Tape_Code_C__c !=null){
                    objClaim.Tape_Code_C__c=objClaim.Tape_Code_C__c.replace('&#160;',' ');
                }
                if(objClaim.Tape_Code_D__c !=null){
                    objClaim.Tape_Code_D__c=objClaim.Tape_Code_D__c.replace('&#160;',' ');
                }
                
                /*
                objClaim.Complaint_Total__c=double.valueof(complaintTotal);
                
                if(plant !='000000000000000'){
                    system.debug('aaa'+objClaim.Plant__c+'bbb'+plant);
                    system.debug('qwerty'+complaintTotal);
                    objClaim.Plant__c=plant;
                }
                */
                if(objClaim.Ship_to__c !=null && objClaim.Ship_to__c !=''){
                    String shipto=objClaim.Ship_to__c;
                    objClaim.Ship_to__c=shipto.remove('<br/>');
                }
                if(objClaim.Order_for__c !=null && objClaim.Order_for__c !=''){
                    String soldto=objClaim.Order_for__c;
                    objClaim.Order_for__c=soldto.remove('<br/>');
                }
                /*
                objClaim.Material_Sub_Total__c=totalmaterialCost;
                objClaim.Labor_Reinstall_Sub_Total__c=labourTotal1Cost2;
                objClaim.Labor_Tear_off_Sub_Total__c=labourTotal1Cost1;
                */
                
                /*
                if(objClaim.Plant__c != null){
                    // List<Plants__c> facilityCode=[Select Facility_Code__c,Plant_code__c from Plants__c where Id=:objClaim.Plant__c];
                    if(facilityCode.size()>0){
                        //if(facilityCode[0].Facility_Code__c !=null && facilityCode[0].Facility_Code__c !=''){
                        if(facilityCode[0].Plant_code__c !=null && facilityCode[0].Plant_code__c !=''){
                            objClaim.Producing_plant_code__c=facilityCode[0].Facility_Code__c;
                            //objClaim.Producing_Plant_Name__c = facilityCode[0].Plant_code__c;
                            objClaim.IsShortTermClmUpd__c  = true;
                        }
                    }
                }
                */
                //Commented by Divya 
                
                /*
                //objClaim.Shipping_Method__c=shippingMethod;
                objClaim.Shipping_Options__c=shippingoptions;
                // objClaim.Producing_Plant__c=plant;
                objClaim.ShortTerm_Note__c=note;
                Map<string,CertainTeed_ShortTerm_Period__c> validityPeriod = CertainTeed_ShortTerm_Period__c.getAll();
                objClaim.Send_Letter_to__c=sendLetterTo;
                */
                
                objClaim.Total_Squares__c=0;
                if(objClaim.Squares_Applied__c !=null){
                    objClaim.Total_Squares__c +=objClaim.Squares_Applied__c;
                }
                if(objClaim.Squares_In_Whse__c !=null){
                    objClaim.Total_Squares__c +=objClaim.Squares_In_Whse__c;
                }
                if(objClaim.Squares_Not_Applied__c !=null){
                    objClaim.Total_Squares__c +=objClaim.Squares_Not_Applied__c;
                }
                system.debug('squares total'+objClaim.Total_Squares__c);
                
                //objClaim.Complaint_Total__c=totalAmt;
                totalAmt=0;

                if(objClaim.Voucher1_Amount__c !=null){
                    totalAmt +=objClaim.Voucher1_Amount__c;
                }
                if(objClaim.Voucher2_Amount__c !=null){
                    totalAmt +=objClaim.Voucher2_Amount__c;
                }
                system.debug('total amount'+totalAmt);
                if(totalAmt ==0){
                    objClaim.ShortTerm_Note__c='';
                }
                
                if( totalAmt  >0 & totalAmt  <=150){
                    objClaim.ShortTerm_Note__c=System.Label.WOD_CT_Payment_Rule1;
                }
                if( totalAmt  > 150 && totalAmt  <= 1500){
                    objClaim.ShortTerm_Note__c=System.Label.WOD_CT_Payment_Rule;
                }
                if(totalAmt > 1500 && totalAmt  <= 2500 ){
                    objClaim.ShortTerm_Note__c=System.Label.WOD_CT_Payment_Rule3;
                }
                if( totalAmt  > 2500){
                    objClaim.ShortTerm_Note__c=System.Label.WOD_CT_Payment_Rule4;
                }
                
                /*
                List<Shipping_Products__c> deletingList=new List<Shipping_Products__c>();
                if(deleteList.size()>0){
                    for(Shipping_Products__c pd:deleteList){
                        if(pd.Id !=null){
                            deletingList.add(pd);
                        }
                    }
                    if(deletingList.size()>0){
                        delete deletingList;
                    }

                }
                */
                //Changes for Short Term claim email issue - Start
                objClaim.IsShortTermClmUpd__c = true; //Commented to Stop multiple mails - Uncommented on 02/18/2022- INC1006744
                //Changes for Short Term claim email issue - End
                claimId = objhandler.createClaim(objClaim,objDistributor,productList);
                }
            }else if(objClaim.WOD_2__Claim_Type__c =='International'){
                System.debug('@@@2 ' +objClaim.WOD_2__Claim_Type__c);
                //Setting Property type of All international claims to Residential
                //objClaim.Property_Type__c = 'Residential';
                claimId = objhandler.createClaim(objClaim,objDistributor,null);
            }else{
                System.debug('@@@3 ' +objClaim.WOD_2__Claim_Type__c);
                if(objClaim.WOD_2__Claim_Type__c =='Standard' || objClaim.WOD_2__Claim_Type__c =='Commercial_Extended_Warranty_NDL' || objClaim.WOD_2__Claim_Type__c =='Solar' /* || objClaim.WOD_2__Claim_Type__c =='Commercial Limited Warranty' || objClaim.WOD_2__Claim_Type__c =='Commercial NDL Limited Warranty' */){
                   // objClaim.Home_Insurance_applicable__c= insuranceApplicability;
                   // objClaim.isClassAction__c = isClassAction;
                    System.debug('@@@4 objClaim.WOD_2__Claim_Type__c '+objClaim.WOD_2__Claim_Type__c+' @@ objClaim.WOD_2__Claim_Status__c '+objClaim.WOD_2__Claim_Status__c +'@  objclaim.RecordTypeId '+ objclaim.RecordTypeId);
                    //CER-211 change
                    /*if(objClaim.Product_Group__c == 'Solar'){
                        objClaim.WOD_2__Claim_Type__c = 'Solar';
                        //objclaim.RecordTypeId = [Select id,DeveloperName from RecordType Where DeveloperName='Solar' LIMIT 1].Id;
                        objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get('Solar').getRecordTypeId();
                    }else*/
                    //CER-211 Change end
                     if(objClaim.WOD_2__Claim_Type__c =='Standard' && objClaim.Business_Units__c=='Commercial Building & Infrastructure' /*objClaim.Property_Type__c == 'Commercial' CER-211*/  && objClaim.Extended_Warranty_Registration_Number__c != ''  && objClaim.Extended_Warranty_Registration_Number__c != null){
                        objClaim.WOD_2__Claim_Type__c = 'Commercial_Extended_Warranty_NDL';
                        objClaim.WOD_2__Claim_Status__c = 'Claim';
                        //objclaim.RecordTypeId = [Select id,DeveloperName from RecordType Where DeveloperName='Commercial_Extended_Warranty_NDL' LIMIT 1].Id;
                        objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get('Commercial Extended Warranty(NDL)').getRecordTypeId();
                        System.debug('@@@5 objClaim.WOD_2__Claim_Type__c '+objClaim.WOD_2__Claim_Type__c+' @@ objClaim.WOD_2__Claim_Status__c '+objClaim.WOD_2__Claim_Status__c +'@  objclaim.RecordTypeId '+ objclaim.RecordTypeId);
                    }/*else if(objClaim.WOD_2__Claim_Type__c =='Commercial_Extended_Warranty_NDL' || objClaim.WOD_2__Claim_Type__c =='Commercial Limited Warranty' || objClaim.WOD_2__Claim_Type__c =='Commercial NDL Limited Warranty'/*&& objClaim.Property_Type__c == 'Residential' CER-211 ){
                        objClaim.WOD_2__Claim_Type__c = 'Standard';
                       
                        objclaim.RecordTypeId = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
                    }*/
                }
                if(vendorSAPNumberList != null && vendorSAPNumberList.size()>0){
                    if(bu.Name=='Roofing'){
                        system.debug('debug '+objClaim);
                        system.debug('test '+objClaim.isClassAction__c +' '+objClaim.ClaimType__c+' '+objClaim.Is_Fiberglass_Horizon_Class_Action__c);
                        //Added objClaim.Is_Fiberglass_Horizon_Class_Action__c condition 10/09/2023 
                        if(objClaim.isClassAction__c == true || objClaim.Is_Fiberglass_Horizon_Class_Action__c){
                            objClaim.SAP_Vendor_Number__c = vendorMap.get('ClassAction');
                        }
                        //CT Multi currency changes
                        //removed objClaim.isClassAction__c == false 
                        else if(objClaim.Country_BL__c =='Canada'){
                           objClaim.SAP_Vendor_Number__c = vendorMap.get('Standard_CAN');
                        }else{
                           objClaim.SAP_Vendor_Number__c = vendorMap.get('Standard');
                        }
                    }
                }
                system.debug('objClaim-----------'+objClaim);
                claimId = objhandler.createClaim(objClaim,null,null);
            }
            
        }catch(Exception ex){
            system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
            response.status=false;
            response.errormessage=ex.getMessage();
        }
        response.data=claimId;
        response.status=true;
        return response;
    }
    /**
     * @description To assign Ship To Party on Claim from Account
     * @param objClaim Claim Object
     * @return void
    */
    public static void assignShipToInfo(WOD_2__Claim__c objClaim){
        try{
            string info;
            system.debug('ship'+objClaim.Ship_To_Party__c);
            if(objClaim.Ship_To_Party__c !=null){
                Id objId=objClaim.Ship_To_Party__c;
                Schema.sObjectType entityType = objId.getSObjectType();
                if(objId !=null || objId.getSObjectType()==entityType){
                    Account objAcc=[SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Name FROM Account where id=:objClaim.Ship_To_Party__c];
                    info=string.valueof(objAcc.Name)+'<br/>'+objAcc.ShippingStreet+','+objAcc.ShippingCity+','+objAcc.ShippingState+','+objAcc.ShippingCountry+'-'+objAcc.ShippingPostalCode;
                    system.debug('info'+info);
                    objClaim.Ship_to__c=info;
                }
            }
            else{
                objClaim.Ship_to__c='';  
            }
        }
        catch(Exception ex){
              system.debug('Exception  Occured ::'+ex.getMessage());
        }
    }
    /**
     * @description To assign Sold To Party on Claim from Account
     * @param objClaim Claim Object
     * @return void
    */
    public static void assignSoldToiInfo(WOD_2__Claim__c objClaim){
        try{
            string info;
            system.debug('sold'+objClaim.Sold_To_Party__c);
            if(objClaim.Sold_To_Party__c !=null){
                Id objId=objClaim.Sold_To_Party__c;
                Schema.sObjectType entityType = objId.getSObjectType();
                if(objId !=null || objId.getSObjectType()== entityType ){
                    Account objAcc=[SELECT BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Name FROM Account where id=:objClaim.Sold_To_Party__c];
                    string street=objAcc.BillingStreet;
                    info=string.valueof(objAcc.Name)+'<br/>'+objAcc.BillingStreet+','+objAcc.BillingCity+','+objAcc.BillingState+','+objAcc.BillingCountry+'-'+objAcc.BillingPostalCode;
                    system.debug('info'+info);
                    objClaim.Order_for__c=info;
                }
            }
            else{
                objClaim.Order_for__c='';  
            }
        }
        catch(Exception ex){
             system.debug('Exception  Occured ::'+ex.getMessage());
        }
    }

    /**
     * @description To get Bcc records
     * @return List of BCCs
    */
    @AuraEnabled(cacheable=true)
    public static List<WOD_2__Business_Category_Configuration__c> getBCCRecords(){
        List<WOD_2__Business_Category_Configuration__c> lstBCC = new List<WOD_2__Business_Category_Configuration__c>();
        List<User> lstUsr = [Select Profile.Name,Sales_Org__c from user where id=:UserInfo.getUserId()];
        
        List<String> lstBccName = new List<String>();

        if(String.IsNotBlank(lstUsr[0].Sales_Org__c)){

            If(/*lstUsr[0].Profile.Name=='Warranty Admin Roofing' &&*/ (lstUsr[0].Sales_Org__c.contains('1102') || lstUsr[0].Sales_Org__c.contains('1501') || lstUsr[0].Sales_Org__c.contains('1111') || lstUsr[0].Sales_Org__c.contains('1021'))){
                lstBccName.add('Roofing');
            }
            //CER_211
            If(/*lstUsr[0].Profile.Name!='Warranty Admin Roofing' &&*/ (lstUsr[0].Sales_Org__c.contains('1102') || lstUsr[0].Sales_Org__c.contains('1501') || lstUsr[0].Sales_Org__c.contains('1111') || lstUsr[0].Sales_Org__c.contains('1021'))){
                lstBccName.add('Commercial Building & Infrastructure');
            }
            If(lstUsr[0].Sales_Org__c.contains('1502') || lstUsr[0].Sales_Org__c.contains('1018') || lstUsr[0].Sales_Org__c.contains('1019') ||lstUsr[0].Sales_Org__c.contains('1020')){//CER-230
                lstBccName.add('Siding');
            }
            //CER_211
            If(/*lstUsr[0].Profile.Name!='Warranty Admin Roofing' &&*/ lstUsr[0].Sales_Org__c.contains('1501')){
                lstBccName.add('Solar Solutions');
            }
            lstBCC = [select id,Name from WOD_2__Business_Category_Configuration__c where Name IN:lstBccName order by Name];
        }
       
        return lstBCC;
    }
    //--------CER-211- claim and warranty Sites--
        @AuraEnabled(cacheable=true)
        public static List<WOD_2__Business_Category_Configuration__c> getroofingBCCRecords() {
            List<WOD_2__Business_Category_Configuration__c> lstBCC = [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c WHERE Name != 'Siding' ORDER BY Name];
            System.debug('Fetched Records: ' + lstBCC);
            return lstBCC;
        }
  //---------**--END CER-211- claim and warranty Sites--**---
    /**
     * @description To get picklist values
     * @param objName Object Api Name
     * @param contfieldName Controlling field API Name
     * @param depfieldName Dependent field API Name
     * @param addUSCanadafilter Canada Filter condition
     * @return Map of picklist values
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,List<String>> getDependentOptions(String objName, String contfieldName, String depfieldName,Boolean addUSCanadafilter){
        return WOD_PicklistFieldController.getDependentOptions(objName,contfieldName,depfieldName,addUSCanadafilter);
    }
    /**
     * @description To get Shipping Material
     * @param claimId Claim Id
     * @return Wrapper
    */
    @AuraEnabled(cacheable=false)
    public static List<ShippingMaterialWrapper> getShippingMaterial (String claimId){
        
        List<ShippingMaterialWrapper> lstShippMatWrapper  = new List<ShippingMaterialWrapper>();
         for(WOD_Shipping_Products__c shippingMat :[SELECT Id,Claim__c,Quantity__c,UOM__c,Color__c,Warranty_Product__c,Warranty_Product__r.Name,Method_of_Settlement__c
                                                    FROM WOD_Shipping_Products__c where Claim__c =: claimId]){
                
                ShippingMaterialWrapper wrapObj = new ShippingMaterialWrapper();
                wrapObj.shipMaterialId = shippingMat.Id;
                wrapObj.warrantyProdId = shippingMat.Warranty_Product__c;
                wrapObj.warrantyProdName = shippingMat.Warranty_Product__r.Name;
                wrapObj.quantity = shippingMat.Quantity__c;
                wrapObj.uom = shippingMat.UOM__c;
                wrapObj.color = shippingMat.Color__c;
                wrapObj.methodOfSettlement = string.isBlank(shippingMat.Method_of_Settlement__c) ? 'Quality RMA' : shippingMat.Method_of_Settlement__c;

                lstShippMatWrapper.add(wrapObj);
            }
        return  lstShippMatWrapper; 
    }
    /**
     * @description To Create Shipping Product
     * @param claimId Claim Id
     * @param shippProdList list of hippingMaterialWrapper
     * @param shipProdToDel list of Shipping Products records
     * @param materialModified flag for modified
     * @return void
    */
    @AuraEnabled
    public static void createShippingProduct (String claimId,List<ShippingMaterialWrapper> shippProdList,List<WOD_Shipping_Products__c> shipProdToDel,Boolean materialModified){
        if(materialModified){
            List<WOD_Shipping_Products__c> lstShippProToUpsert = new List<WOD_Shipping_Products__c>();
            for(ShippingMaterialWrapper obj:shippProdList){
                WOD_Shipping_Products__c sp = new WOD_Shipping_Products__c();
                sp.Claim__c = claimId;

                if(String.IsNotBlank(obj.shipMaterialId)){
                    sp.Id = obj.shipMaterialId;
                }
               
                sp.Warranty_Product__c = obj.warrantyProdId;
                sp.UOM__c = obj.uom;
                sp.Color__c = obj.color;
                sp.Quantity__c = obj.quantity;
                sp.Method_of_Settlement__c = obj.methodOfSettlement;
                lstShippProToUpsert.add(sp);
            }
            if(lstShippProToUpsert.size() > 0){
                upsert lstShippProToUpsert;
            }
        }
      
        if(shipProdToDel.size()>0){
            delete shipProdToDel;
        }
    }
    
    /**
     * @description To get Account Details
     * @param accId Account Id
     * @return Address Wrapper
    */
    @AuraEnabled(cacheable=true)
    public static AddressWrapper getAccountInformation(String accId){
        String finalAdd='';
        AddressWrapper addWrap=new AddressWrapper();
       // List<Account> accList=[Select Id ,Name,Email__c,Phone,ShippingAddress from Account where Id =: accId ];
        List<Account> accList=[SELECT Id, Name,BillingAddress , BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude FROM Account where Id =: accId ];
         system.debug('accList '+accList );
      
        if(accList.size() > 0 ){
            //Address addr=accList[0].ShippingAddress;
            //finalAdd=addr.getStreet()+','+addr.getCity()+','+addr.getState()+','+addr.getCountry()+'-'+addr.getPostalCode();
            finalAdd=accList[0].BillingStreet+','+accList[0].BillingCity+','+accList[0].BillingState+','+accList[0].BillingCountry+'-'+accList[0].BillingPostalCode;
            addWrap.fullAddress=finalAdd;
            addWrap.accName=accList[0].Name;
        }
        return addWrap;
    }

    /**
     * @description Get short Term Validity details
     * @return Address Wrapper
    */
    @AuraEnabled(cacheable=true)
    public static ResponseWrapper getShortTermValidity (){
        ResponseWrapper response = new ResponseWrapper('',false,'');
  
        try{
            Id profileId = userinfo.getProfileId();
             Profile prof= [SELECT Id, name from Profile where Id =: profileId LIMIT 1];
            
            List<WOD_Bypass_ShortTerm_Warranty_Profile__mdt> shortTermPeriodByPass = [Select id  from WOD_Bypass_ShortTerm_Warranty_Profile__mdt where Profile_Id__c  =:prof.Name];
            //List<WOD_Bypass_ShortTerm_Warranty_Profile__mdt> shortTermPeriodByPass = [Select id  from WOD_Bypass_ShortTerm_Warranty_Profile__mdt where Profile_Id__c  =:profileId];

            if(shortTermPeriodByPass.size() == 0){
                WOD_CertainTeed_ShortTerm_Period__mdt shortTermPeriod = [Select Label,WOD_Validity_Period__c from WOD_CertainTeed_ShortTerm_Period__mdt where Label ='ShortTerm'];
                response.data = '{"isValidityPeriod":"true","validityPeriod":"'+shortTermPeriod.WOD_Validity_Period__c+'"}';
            }
            else{
                response.data = '{"isValidityPeriod":"false","validityPeriod":""}';
            }
            response.status = true;
        }
        
        catch(Exception ex){
            system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
            response.status = false;
            response.errormessage = ex.getMessage();
        }

        return response;
    }

    /**
     * @description Get Claim Interested Party RecordType
     * @param claimId Claim Id
     * @return Address Wrapper
    */
      @AuraEnabled
      public static ResponseWrapper getClaimInterestedPartiesRecordType (String claimId){
          ResponseWrapper response = new ResponseWrapper('',false,'');
          try{
              List<WOD_2__Claim__c> clmList = [Select id ,WOD_2__Claim_Status__c,Business_Units__c,WOD_2__Claim_Type__c,Division_Code__c,Name,RecordTypeId from WOD_2__Claim__c where Id  =:claimId];
              if(clmList != null && clmList.size() > 0){
                 response.errormessage=clmList[0].Business_Units__c+','+clmList[0].WOD_2__Claim_Status__c;
                  //response.errormessage=JSON.serialize(clmList[0]);
                  if(clmList[0].WOD_2__Claim_Type__c=='International'){
                    //response.data=[Select id from RecordType Where Name ='International'  AND sObjectType = 'WOD_Claim_Interested_Parties__c' LIMIT 1].Id;
                    response.data=Schema.SObjectType.WOD_Claim_Interested_Parties__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
                  }else{
                    //response.data=[Select id from RecordType Where Name ='Domestic'  AND sObjectType = 'WOD_Claim_Interested_Parties__c' LIMIT 1].Id;
                    response.data=Schema.SObjectType.WOD_Claim_Interested_Parties__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
                  }
                  response.status = true;
              }
              else{
                 response.status = false;
              }
          }
          catch(Exception ex){
              system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
              response.status = false;
              response.errormessage = ex.getMessage();
          }
          return response;
      }

    /**
     * @description Get Claim data
     * @param claimId Claim Id
     * @return Wrapper
    */
       @AuraEnabled
       public static ClaimResponseWrapper getClaimData (String claimId){
            ClaimResponseWrapper response = new ClaimResponseWrapper();
           try{
               List<WOD_2__Claim__c> clmList = [Select id ,WOD_2__Claim_Status__c,Resolution_Code__c,WOD_2__Claim_Type__c,Division_Code__c,Name,Business_Units__c,WOD_2__BusinessCategory__r.Name,
                    RecordTypeId from WOD_2__Claim__c where Id  =:claimId];
               if(clmList != null && clmList.size() > 0){
                   User usr=[Select id,Name,ProfileId,Profile.Name from User where id =: Userinfo.getUserId()];
                   response.claim=clmList[0];
                   response.status = true;
                   response.data=usr.Profile.Name;
               }
               else{
                  response.status = false;
                  response.errormessage = 'No Claim found.';
               }
           }
           catch(Exception ex){
               system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
               response.status = false;
               response.errormessage = ex.getMessage();
           }
           return response;
       }
    /**
     * @descriptionto To update Claim
     * @param claimId Claim Id
     * @param actionType Approved/Rejected
     * @return Wrapper
    */
       @AuraEnabled
       public static ResponseWrapper updateClaimAsApprovedOrReject (String claimId,String actionType){
        ResponseWrapper response = new ResponseWrapper();
           try{
               List<WOD_2__Claim__c> clmList = [Select id ,Outcome__c,WOD_2__Claim_Type__c,Division_Code__c,WOD_2__Claim_Status__c,Name,Claim_Closing_Comment__c,
                    Business_Units__c,WOD_2__BusinessCategory__r.Name,RecordTypeId from WOD_2__Claim__c where Id  =:claimId LIMIT 1];
               if(clmList != null && clmList.size() > 0){
                  if(actionType == 'Approved')
                     clmList[0].Outcome__c='<b><span style="color:green;font-size: small;">Approved</span></b><br/>';
                  if(actionType == 'Rejected')
                     clmList[0].Outcome__c='<b><span style="color:red;font-size: small;">Rejected</span></b><br/>';
                   update clmList[0];
                   response.data=clmList[0].Id;
                   response.status = true;
               }
               else{
                  response.status = false;
                  response.errormessage = 'No Claim found.';
               }
           }
           catch(Exception ex){
               system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
               response.status = false;
               response.errormessage = ex.getMessage();
           }
           return response;
       }
    /**
     * @descriptionto To update Claim
     * @param claimId Claim Id
     * @param comment Comments
     * @return Wrapper
    */
       @AuraEnabled
       public static ResponseWrapper updateClaim (String claimId,String comment){
        ResponseWrapper response = new ResponseWrapper();
           try{
               List<WOD_2__Claim__c> clmList = [Select id ,WOD_2__Claim_Type__c,Division_Code__c,WOD_2__Claim_Status__c,Name,Claim_Closing_Comment__c,
                    Business_Units__c,WOD_2__BusinessCategory__r.Name,RecordTypeId from WOD_2__Claim__c where Id  =:claimId LIMIT 1];
               if(clmList != null && clmList.size() > 0){
                   clmList[0].WOD_2__Claim_Status__c='Closed';
                   clmList[0].Claim_Closing_Comment__c=comment;
                   update clmList[0];
                   response.data=clmList[0].Id;
                   response.status = true;
               }
               else{
                  response.status = false;
                  response.errormessage = 'No Claim found.';
               }
           }
           catch(Exception ex){
               system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
               response.status = false;
               response.errormessage = ex.getMessage();
           }
           return response;
       }
    /**
     * @descriptionto To update Claim as Re-open
     * @param claimId Claim Id
     * @param comment Comments
     * @return Wrapper
    */
       @AuraEnabled
       public static ResponseWrapper updateClaimAsReOpened (String claimId,String comment){
        ResponseWrapper response = new ResponseWrapper();
           try{
               List<WOD_2__Claim__c> clmList = [Select id ,isReopen__c,Re_Open_Comments__c,WOD_2__Claim_Type__c,Division_Code__c,WOD_2__Claim_Status__c,Name,Claim_Closing_Comment__c,
                    Business_Units__c,WOD_2__BusinessCategory__r.Name,RecordTypeId from WOD_2__Claim__c where Id  =:claimId LIMIT 1];
               if(clmList != null && clmList.size() > 0){
                   clmList[0].WOD_2__Claim_Status__c='Pre-Claim';
                   clmList[0].isReopen__c=true;
                   clmList[0].Re_Open_Claim_Comment1__c=comment;
                   update clmList[0];
                   response.data=clmList[0].Id;
                   response.status = true;
               }
               else{
                  response.status = false;
                  response.errormessage = 'No Claim found.';
               }
           }
           catch(Exception ex){
               system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
               response.status = false;
               response.errormessage = ex.getMessage();
           }
           return response;
       }
    /**
     * @descriptionto To get Claim Record Type
     * @return List of Claim Record Type
    */
       @AuraEnabled(cacheable=true)
       public static List<String> getClaimRecordTypes(){
        List<String> lstRecTypeName = new List<String>();
        Map<String, Schema.RecordTypeInfo> recordTypesMap = Schema.getGlobalDescribe().get('WOD_2__Claim__c').getDescribe().getRecordTypeInfosByName();
        for(String s : recordTypesMap.keySet()){
            Schema.RecordTypeInfo rt = recordTypesMap.get(s);
            String recTypeName = rt.getName();
            if(rt.isAvailable() == true && (recTypeName == 'Short Term' || recTypeName == 'Standard' || recTypeName == 'International')){
                lstRecTypeName.add(recTypeName);
            }
            if(rt.isAvailable() == true && recTypeName == 'Solar'){
                lstRecTypeName.add(recTypeName);
            }
            if(rt.isAvailable() == true && recTypeName == 'Commercial Extended Warranty(NDL)'){
                lstRecTypeName.add('Commercial_Extended_Warranty_NDL');
            }
        }
        return lstRecTypeName;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues(String objectName, String fieldName) {
        List<String> picklistValues = new List<String>();
        
        // Query to fetch the picklist values dynamically
        String query = 'SELECT ' + fieldName + ' FROM ' + objectName + ' LIMIT 1';
        DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        system.debug('fieldDescribe: '+fieldDescribe);
        if (fieldDescribe.isAccessible() && fieldDescribe.isUpdateable()) {
            Schema.DescribeFieldResult fieldResult = fieldDescribe.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            system.debug('picklistEntries: '+picklistEntries);
            for (Schema.PicklistEntry entry : picklistEntries) {
                picklistValues.add(entry.getLabel());
            }
            system.debug('picklistValues: '+picklistValues);
        }
        
        return picklistValues;
    }
    @AuraEnabled
    public static void updateClaimWithDivision(Id claimId, String divisionCode) {
        // Retrieve the claim record
        WOD_2__Claim__c claimRecord = [SELECT Id, Division_Code__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        
        // Update the division code
        claimRecord.Division_Code__c = divisionCode;
        
        // Update the claim record
        update claimRecord;
    }
    /**
     * @descriptionto Wrapper Class
    */
      public class AddressWrapper{
        @AuraEnabled
        public String accName;
        @AuraEnabled
        public String fullAddress;
        @AuraEnabled
        public String errormessage;
        
        public AddressWrapper(){  
        }
    }
    /**
     * @descriptionto Wrapper Class
    */
    public class ResponseWrapper{
        @AuraEnabled
        public String data;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        
        public ResponseWrapper(){
            
        }
        public ResponseWrapper(String data, Boolean status, string errormessage) {
            this.data = data;
            this.status = status;
            this.errormessage = errormessage;
        }
    }
    /**
     * @descriptionto Wrapper Class
    */
    public class ClaimResponseWrapper{
        @AuraEnabled
        public WOD_2__Claim__c claim;
        @AuraEnabled
        public WOD_Claim_Interested_Parties__c distributor;
        @AuraEnabled
        public List<WOD_Shipping_Products__c> productList;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        @AuraEnabled
        public String data;
        
        @AuraEnabled
        public Map<String,List<String>> divOptions;

        public ClaimResponseWrapper(){
            divOptions= new Map<String,List<String>>();
            
        }

    }
    /**
     * @descriptionto Wrapper Class
    */
    public class ShippingMaterialWrapper{
        @AuraEnabled
        public String shipMaterialId {get;set;}
        @AuraEnabled
        public String warrantyProdId {get;set;}
        @AuraEnabled
        public String warrantyProdName {get;set;}
        @AuraEnabled
        public Decimal quantity {get;set;}
        @AuraEnabled
        public String uom {get;set;}
        @AuraEnabled
        public String color {get;set;}
        @AuraEnabled
        public String methodOfSettlement {get;set;}

    }
    
}