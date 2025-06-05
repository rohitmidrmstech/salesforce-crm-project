/**
 * @description This class is used to manage QC and Claim
*/
public class WOD_UpdateQCStatus {
    /**
     * @description this method is used to update QC and Claim
     * @param qcId QC Id
     * @return Wrapper
    */
    // webservice static void statusChange(String qcId) {
    @Auraenabled
    public static ResponseWrapper statusChange(String qcId) {
        ResponseWrapper response = new ResponseWrapper('',false,'');
        try{
            WOD_QC__c qc=[Select Id,Name,Claim__c,Claim__r.Is_Fiberglass_Horizon_Class_Action__c,Is_Fiberglass_Horizon_Class_Action__c,Claim__r.Country_BL__c,Date_of_Installation__c,Date_of_Transfer__c,Defect_Details__c,Material__c,Ownership_Type__c,Plant__c,Plant__r.SAP_Plant__c,isClassAction__c,Status_of_third_party_appeal__c,
                        Claim__r.WOD_2__Claim_Type__c,Product_Group__c,Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Quantity__c,material_quantity__c,Primary_Defect_Code__c,Secondary_Defect_Code__c,Lab_Status__c
                        ,Reject_Reason__c,Other_Reason__c,Lab_Comments__c,Photo_Comments__c  from WOD_QC__c where Id=:qcId];
            List<WOD_QC__c> qcS=[Select Id,Active__c from WOD_QC__c where Id !=:qcId and Claim__c=:qc.Claim__c];
            for(WOD_QC__c q:qcS)
            {
                q.Active__c=false;
            }
            qc.Active__c=true;
            qcS.add(qc);
            update qcS;
            
            WOD_2__Claim__c claim=new WOD_2__Claim__c(Id=qc.Claim__c);
            claim.Country_BL__c = qc.Claim__r.Country_BL__c;
            if(qc.claim__r.WOD_2__Claim_Type__c !='Short Term'){
                claim.Install_Date__c=qc.Date_of_Installation__c;
                claim.Transferred_Date__c=qc.Date_of_Transfer__c;
                claim.Defect_Details__c=qc.Defect_Details__c;
                claim.WOD_2__Warranty_Product__c=qc.Material__c;
                claim.OwnershipType__c=qc.Ownership_Type__c;
                claim.Plant__c=qc.Plant__c;
                if(qc.Plant__c != null){
                    claim.Plant_Code__c=qc.Plant__r.SAP_Plant__c;
                }
                claim.Product_Group__c=qc.Product_Group__c;
                claim.Tape_Code_A__c=qc.Tape_Code_A__c;
                claim.Tape_Code_B__c=qc.Tape_Code_B__c;
                claim.Tape_Code_C__c=qc.Tape_Code_C__c;
                claim.Quantity__c=qc.Quantity__c;
                claim.material_quantity__c=qc.material_quantity__c;
                claim.Primary_Defect_Code__c=qc.Primary_Defect_Code__c;
                claim.Secondary_Defect_Code__c=qc.Secondary_Defect_Code__c;
                claim.Status_of_third_party_appeal__c=qc.Status_of_third_party_appeal__c;
                claim.Lab_Status__c=qc.Lab_Status__c;
                //12-Feb-2018 -- Copying over Reject Reason, Other Reason, Lab Comments, Photo Comments from Active QC to Related Claim
                claim.Reject_Reason__c = qc.Reject_Reason__c;
                claim.Other_Reason__c = qc.Other_Reason__c;
                claim.Lab_Comments__c = qc.Lab_Comments__c;
                claim.Photo_Comments__c = qc.Photo_Comments__c;
            }
            if(qc.claim__r.WOD_2__Claim_Type__c=='Short Term'){
                claim.Primary_Defect_Code__c=qc.Primary_Defect_Code__c;
                claim.Secondary_Defect_Code__c=qc.Secondary_Defect_Code__c;
                claim.Lab_Status__c=qc.Lab_Status__c;
                //12-Feb-2018 -- Copying over Reject Reason, Other Reason, Lab Comments, Photo Comments from Active QC to Related Claim
                claim.Reject_Reason__c = qc.Reject_Reason__c;
                claim.Other_Reason__c = qc.Other_Reason__c;
                claim.Lab_Comments__c = qc.Lab_Comments__c;
                claim.Photo_Comments__c = qc.Photo_Comments__c;
                //CERP-56 : Trigger TM Notification on change of Defect Code
                claim.IsShortTermClmUpd__c = true;
            }
            
            List<WOD_CT_SAP_Vendor_Number__mdt> vendorSAPNumberList=new List<WOD_CT_SAP_Vendor_Number__mdt>();
            Map<String,String> vendorMap=new Map<String,String>();
            vendorSAPNumberList =[Select Id,Label,WOD_SAP_Vendor_Number__c from WOD_CT_SAP_Vendor_Number__mdt];
            if(vendorSAPNumberList != null && vendorSAPNumberList.size()>0){
                for(WOD_CT_SAP_Vendor_Number__mdt vendorMt : vendorSAPNumberList){
                    vendorMap.put(vendorMt.Label,vendorMt.WOD_SAP_Vendor_Number__c);
                } 
                if(qc.is_Fiberglass_Horizon_Class_Action__c){
                    claim.SAP_Vendor_Number__c= vendorMap.get('ClassAction');
                    claim.is_Fiberglass_Horizon_Class_Action__c=qc.is_Fiberglass_Horizon_Class_Action__c;
                    //Setting Currency to USD for all Class Action claims.
                    claim.currency__c = 'USD';
                    claim.Sales_Org__c = '1501';
                }
                else if(qc.isClassAction__c ){
                    claim.SAP_Vendor_Number__c= vendorMap.get('ClassAction');
                    claim.isClassAction__c=qc.isClassAction__c;
                    claim.is_Fiberglass_Horizon_Class_Action__c=false;
                    //Setting Currency to USD for all Class Action claims.
                    claim.currency__c = 'USD';
                    claim.Sales_Org__c = '1501';
                }
                else{
                    claim.isClassAction__c=false;
                    claim.is_Fiberglass_Horizon_Class_Action__c=false;
                    //CT Multi currency changes
                    if(claim.Country_BL__c =='Canada'){
                        claim.SAP_Vendor_Number__c = vendorMap.get('Standard_CAN');
                    }
                    else {
                        claim.SAP_Vendor_Number__c = vendorMap.get('Standard');
                    }
                }
            }
            /*
                Map<string,CT_SAP_Vendor_Number__c> CTSAPVendorNumber = CT_SAP_Vendor_Number__c.getAll();
                if(qc.isClassAction__c ){
                claim.SAP_Vendor_Number__c= CTSAPVendorNumber.get('ClassAction').SAP_Vendor_Number__c;
                claim.isClassAction__c=qc.isClassAction__c;
                //Setting Currency to USD for all Class Action claims.
                claim.currency__c = 'USD';
                claim.Sales_Org__c = '1501';
                }
                else{
                claim.isClassAction__c=false;
                //CT Multi currency changes
                if(Claim.Country_BL__c =='Canada'){
                Claim.SAP_Vendor_Number__c = CTSAPVendorNumber.get('Standard_CAN').SAP_Vendor_Number__c;
                }
                else {
                Claim.SAP_Vendor_Number__c = CTSAPVendorNumber.get('Standard').SAP_Vendor_Number__c;
                }
                }
    */
            
            if(claim.Product_Group__c == 'Solar'){
                claim.WOD_2__Claim_Type__c = 'Solar';
                claim.Warranty_Registration_Type__c='Standard';
                claim.RecordTypeId = [Select id,DeveloperName from RecordType Where DeveloperName='Solar' LIMIT 1].Id;
            }
            update claim;
            /*
            claim = [SELECT Id,Account__c,Address_1_BL__c,Address_1_U__c,Address_1__c,Address_2_BL__c,Address_2_U__c,Address_2__c,Affected_Walls_Other__c,Affected_Walls__c,
            Alert_for_Inspection__c,Alternate_Mailing_Address__c,Amount_Paid__c,Applicant_Type__c,Approval_Status__c,Approved_Check_Settlement_Count__c,
            Approved_Claim_Amount__c,Approver__c,Authed_Material__c,BPCS_Ship_To__c,Building_State_Code__c,Building_Type__c,Business_Name_if_applicable__c,
            Business_Units__c,Case_Number__c,Cash_settlement_Figure__c,category_of_product__c,CertainTeed_s_EX_No__c,Certificate_Note__c,Check_Address__c,
            Check_Amount__c,Check_City__c,Check_Country__c,Check_Payable_to__c,Check_State__c,Check_Zip_Code_Postal_Code__c,Check_Zip_Code__c,Check__c,
            City_BL__c,City_U__c,City__c,ClaimType__c,Claim_Closing_Comment__c,Claim_External_Id__c,Claim_File_Number__c,Claim_Incident__c,Classification__c,
            colour_of_Products_to_be_Shipped__c,Colour__c,Comments__c,Complaint_Code__c,Complaint_Total__c,Contact_Email__c,Contact_Name_s__c,Contact_Name__c,
            Contact_Phone__c,Cost_Material_Comment__c,Country_BL__c,Country_U__c,Country__c,Coverage_Information__c,Coverage__c,Co_Owner_First_Name_Mailing__c,
            Co_Owner_First_Name__c,Co_Owner_Last_Name_Mailing__c,Co_Owner_Last_Name__c,CreatedById,CreatedDate,Credit_Amount__c,Credit_Date_of_Request__c,
            Credit_Order_For__c,Credit_Ship_To1__c,Credit_Ship_To__c,Credit_Sold_To__c,Credit__c,CT_Notified__c,Currency__c,Customer__c,Custom_Auto_Number__c,
            Custom_State__c,Cycle_Time_2_Letter__c,Cycle_Time_2_Payment_ST__c,Cycle_Time_2_Payment__c,Cycle_Time_2_QC__c,Cycle_Time_Letter__c,
            Cycle_Time_Payment_ST__c,Cycle_Time_Payment__c,Cycle_Time_QC__c,Date_Applied__c,Date_Investigated__c,Date_Issued__c,Date_of_App_Documentation__c,
            Date_of_Created_Date__c,Date_of_Request__c,Date_Reported__c,Debit_Amount__c,Debit_Order_For__c,Debit_Ship_To1__c,Debit_Ship_To__c,Debit_Sold_To__c,
            Defect_Details__c,Delivery_Fee__c,DiffTransferInstallDates__c,Distributor_Ref__c,Distributor_Sold_to_Ship_To__c,Distributor_s_PO__c,Documentation__c,
            Drawloop_field__c,Drawloop_Month__c,Drawloop_Total_Amount__c,Email__c,Estimated_Liability__c,Extended_Warranty_Registration_Number__c,
            FCA_Claim__c,First_Name_BL__c,First_Name__c,GELCO_Voucher_1__c,GELCO_Voucher_2__c,Hail_Speed__c,Home_Insurance_applicable__c,
            Inspection_already_initiated__c,Inspection_Comments__c,Inspection_Details__c,Inspection_Initiated_for_Reopen__c,Inspection__c,
            Installation_Location_other__c,Installation_Location__c,Installing_Contractor__c,Install_Date__c,Insurance_claimed_Amount__c,
            Insurance_Claimed_Date__c,Invoice_Number__c,Invoice_price__c,isClassAction__c,IsDeleted,isDuplicate__c,isLegal__c,isLocked__c,
            isReopen__c,IsShortTermClmUpd__c,Issued_to__c,Issue_as_stated_on_letter__c,Is_Migrated__c,Is_New_Construction_Mailing_Address__c,
            Is_New_Construction__c,JobCompletion_Date__c,Labor_Misc_Total_Amount__c,Labor_Payment__c,Labor_Rate__c,Labor_Reinstall_Squares__c,
            Labor_Reinstall_Sub_Total__c,Labor_Reinstall_Unit_Cost__c,Labor_Tear_off_Squares__c,Labor_Tear_off_Sub_Total__c,Labor_Tear_off_UnitCost__c,
            Lab_Comments__c,Lab_Status__c,Landmark_Case__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Last_Name_BL__c,
            Last_Name__c,Legal_Claim_Comment1__c,Legal_Claim_Comment__c,Letter_Date_2__c,Letter_Date__c,Mailing_State_Code__c,Manually_Approved__c,
            Material_Comment__c,material_quantity__c,Material_Squares__c,Material_Sub_Total__c,Material_Unit_Cost__c,Material_Vocher_Date_of_Request__c,
            Material_Voucher_Claim_Incident__c,Material__c,Misc1_cost_description__c,Misc2_cost_description__c,Misc3_cost_description__c,Misc4_cost_description__c,
            Misc5_cost_description__c,Miscellaneous_1__c,Miscellaneous_cost_2__c,Miscellaneous_cost_3__c,Miscellaneous_cost_4__c,Miscellaneous_cost_5__c,
            Name,Name_BL__c,Nature_of_Problem__c,Notes__c,No_Cost_Material__c,Number_of_sqs_Affected__c,Order_for__c,Organization_BL__c,Organization__c,
            Original_Order_Number__c,Original_PO_Number__c,Original_Product_Code__c,Original_Roofing_Contractor__c,Other_Reason__c,Outcome__c,Override_Comments__c,
            OwnerId,OwnershipType__c,Owner__c,Paper_File__c,Payment_Date_2__c,Payment_Date__c,Payment_Total__c,Payment_to__c,Pcs_Back__c,Pcs_Front__c,Pcs_Left__c,
            Pcs_Right__c,Phone_BL__c,Phone__c,Photos__c,Photo_Comments__c,Plant_Code__c,Plant__c,Postal_Code_BL__c,Postal_Code__c,Prepared_by__c,
            Primary_Defect_Code_Description__c,Primary_Defect_Code__c,Priority__c,Problem__c,Producing_plant_code__c,Producing_Plant__c,
            Products_to_be_Shipped_Quantity__c,Products_to_be_Shipped__c,Product_Colour_To_Be_Shipped__c,Product_Color__c,Product_Detail__c,Product_Group__c,
            Product_to_be_Shipped__c,Proof_of_Current_Ownership__c,Proof_of_Ownership__c,Proof_of_Purchase__c,Property_Name__c,Property_Type__c,Prorated_Y_N__c,
            QC_Date_2__c,QC_Date__c,Quality_RMA_Contact_Email__c,Quality_RMA_Contact_Name__c,Quality_RMA_Contact_Phone__c,Quality_RMA_Ship_To_Party__c,
            Quality_RMA_Sold_To_Party__c,Quality_RMA__c,Quantity__c,Reason_for_claim__c,Reason_for_Override__c,RecordTypeId,Registration_Comment__c,
            Reject_Reason__c,Replacement_Product_Code__c,Requested_Claim_Amount__c,Required_Fee__c,Resolution_Code__c,Resolution__c,Re_Open_Claim_Comment1__c,
            Re_Open_Comments__c,RMA_Number__c,Roofer_Email__c,Roofer_Name__c,Roofer_Phone__c,Roof_System_Application_Date__c,Rush_Claim__c,Rush__c,Sales_Org__c,
            Salutation__c,Samples__c,Sample_Date_2__c,Sample_Date__c,Sampling_Details__c,Sampling_Status__c,Sampling__c,SAP_Vendor_Number__c,
            Secondary_Defect_Code_Description__c,Secondary_Defect_Code__c,Send_Letter_to__c,Service_Fee__c,Settlement_Figure_Written__c,Settlement_Verification__c,
            Shingle_Color__c,Shingle_Name__c,Shipped_For__c,Shipping_Method__c,Shipping_Options__c,Shipping_Product__c,Ship_To_Info_Credit__c,
            Ship_To_Info_Debit__c,Ship_To_Party__c,Ship_to__c,Ship_w_PO_No__c,ShortTerm_Note__c,Sold_To_Info_Credit__c,Sold_To_Info_Debit__c,Sold_To_Party__c,
            Specification__c,Squares_Applied__c,Squares_In_Whse__c,Squares_Not_Applied__c,Squares_Paid__c,Square_Amt_Documentation__c,Standard_Claim_Form__c,
            Standard_Photos__c,Standard_Samples__c,Standard_Slope__c,State_BL__c,State_U__c,State__c,Status_of_third_party_appeal__c,Street_address__c,
            SureShort_Expiration__c,SystemModstamp,Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Tape_Code_D__c,Territory_Manager__c,Territory_Number__c,
            Territory__c,Total_Complaint_Quantity__c,Total_Payment__c,Total_Pcs__c,Total_Quantity_of_Complaint_Material__c,Total_Squares__c,Tracking_Number__c,
            Transferred_Date__c,Type_of_Applicator__c,Type__c,Undetermined_Settlement__c,Unit_of_Measure_for_Material_Quantity__c,Unit_of_Measure__c,Unit__c,
            UpdFrmDiffRec__c,Vendor__c,Voucher1_Amount__c,Voucher1_Issued_Date__c,Voucher1_Issued_To__c,Voucher1_No__c,Voucher2_Amount__c,Voucher2_Issued_Date__c,
            Voucher2_Issued_To__c,Voucher2_No__c,Voucher_Issued_To1__c,Voucher_Issued_To2__c,Warranted_Roof_Area__c,Warranty_Data_Link__c,
            Warranty_Registration_Type__c,Warranty_Status__c,Warranty_Years__c,Wind_Speed__c,WOD_2__Account__c,WOD_2__Appeal_By_Date__c,WOD_2__Appeal_Count__c,
            WOD_2__Appeal_Description__c,WOD_2__Appeal_Reason__c,WOD_2__Appeal_Status__c,WOD_2__Applicable_Policy__c,WOD_2__Approval_Comments__c,
            WOD_2__Approved_Rejected_Date__c,WOD_2__Auto_Approved__c,WOD_2__Batch_Log__c,WOD_2__BusinessCategory__c,WOD_2__Campaign_Members__c,
            WOD_2__CasualPart_Comments__c,WOD_2__Causal_Part_Description__c,WOD_2__Causal_Part_Number__c,WOD_2__Causal_Part_Serial_Number__c,WOD_2__Caused_By__c,
            WOD_2__ClaimTemplateID__c,WOD_2__Claim_Auto_Number__c,WOD_2__Claim_Parts_Pending_Approval__c,WOD_2__Claim_Pre_Appeal_Status__c,
            WOD_2__Claim_Record_Type__c,WOD_2__Claim_Status__c,WOD_2__Claim_Submission_Time__c,WOD_2__Claim_Template_Payment_Definition__c,WOD_2__Claim_Type__c,
            WOD_2__Comments__c,WOD_2__Date_Of_Failure__c,WOD_2__Date_Of_Purchase__c,WOD_2__Date_Of_Repair__c,WOD_2__Delay_Reason__c,WOD_2__Description__c,
            WOD_2__Duplicate_Claim__c,WOD_2__Fault_Code_Comment__c,WOD_2__Fault_Code__c,WOD_2__Fault_Found__c,WOD_2__Field_Modification_Edited__c,
            WOD_2__Host_NonHost__c,WOD_2__Internal_Comments__c,WOD_2__Inventory__c,WOD_2__Invoice_Number__c,WOD_2__In_Approval_Process__c,
            WOD_2__Is_Claim_Financial_Created__c,WOD_2__Is_Claim_Financial_Edited__c,WOD_2__Is_Pre_Authorization_Required__c,WOD_2__Is_Repair_Completed__c,
            WOD_2__Is_Template__c,WOD_2__Model_Number__c,WOD_2__Override_Part_Payment_Condition__c,WOD_2__Override_Policy__c,WOD_2__Part_Description__c,
            WOD_2__Part_Serial_Number__c,WOD_2__Part__c,WOD_2__Pre_Authorization_Comments__c,WOD_2__Pre_Authorization_Reason__c,
            WOD_2__Pre_Authorization_Status__c,WOD_2__Rate__c,WOD_2__Reopen_Description__c,WOD_2__Reopen_Reason__c,WOD_2__Request_SMR__c,WOD_2__Service_Ticket__c,
            WOD_2__SMR_Reason__c,WOD_2__Submitted_By__c,WOD_2__Submit_Date__c,WOD_2__Tr_Fault_Code_Comment__c,WOD_2__Tr_Probable_Cause__c,
            WOD_2__Tr_Work_Performed_Comments__c,WOD_2__Units_Usage__c,WOD_2__Upcoming_Completed_Schedule__c,WOD_2__Warranty_Product__c,WOD_2__Work_Order__c,
            WOD_2__Work_Performed_Comments__c,WOD_claimStatusTracking__c,Workmanship_Years__c,X2_Years_Installation_date__c,X30_Days_From_Date_Of_Letter__c,
            Zip_Code_Postal_Code_U__c,Zip_Code_Postal_Code__c ,
            Primary_Defect_Code__r.description__c,Ship_To_Party__r.Name,Sold_To_Party__r.Name,Plant__r.Name,Plant__r.Plant_code__c,
            Primary_Defect_Code__r.Name,Secondary_Defect_Code__r.Name,WOD_2__Warranty_Product__r.Name,WOD_2__Warranty_Product__r.Product_Colour__c,
            WOD_2__Warranty_Product__r.WOD_2__Product_Name__c
            FROM WOD_2__Claim__c where id =: claim.Id];
            */
            claim=[SELECT Id,Name,Rush_Claim__c,Rush__c,Warranty_Registration_Type__c,WOD_2__Claim_Type__c,
            WOD_2__Claim_Status__c,Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Tape_Code_D__c,
            Plant__c,Material_Sub_Total__c,Labor_Reinstall_Sub_Total__c,Labor_Tear_off_Sub_Total__c,Complaint_Total__c,Quality_RMA__c,
            Shipping_Method__c,Producing_Plant__c,ShortTerm_Note__c,Send_Letter_to__c,
            Total_Squares__c,Squares_Applied__c,Squares_In_Whse__c,Squares_Not_Applied__c,Voucher1_Amount__c,Voucher2_Amount__c,
            IsShortTermClmUpd__c,Property_Type__c,Home_Insurance_applicable__c,isClassAction__c,is_Fiberglass_Horizon_Class_Action__c,Product_Group__c,
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
            Installing_Contractor__c,Customer__c,Debit_Amount__c, //TECP-668
            Pcs_Front__c,Sq_Ft_Claimed_Front__c,Pcs_Right__c,Sq_Ft_Claimed_Right__c,Pcs_Back__c,Sq_Ft_Claimed_Back__c,Pcs_Left__c,Sq_Ft_Claimed_Left__c,
            Total_Pcs__c,Total_Square_Ft_Claimed__c,FCA_Claim__c,Lab_Status__c,Reject_Reason__c,Other_Reason__c,Lab_Comments__c,
            Photo_Comments__c,Status_of_third_party_appeal__c,SAP_Vendor_Number__c,currency__c,Sales_Org__c,RecordTypeId,CreatedDate
            FROM WOD_2__Claim__c WHERE id =: claim.Id];
        
            WOD_Claimhandler han=new WOD_Claimhandler();
            han.createClaim(claim,null,null);
            response.status=true;
        }catch(Exception ex){
            response.status=false;
            response.errormessage=ex.getMessage();
        }
        return response;
    }
    /**
     * @description this method is used to get All QC record Associated with claim
     * @param claimId Claim Id
     * @return List of QC records
    */
    @Auraenabled
    public static List<WOD_QC__c> getAllQCAssociatedWithClaim(String claimId){
        List<WOD_QC__c> qcList=[SELECT Id,Active__c,Name,Claim__c,Claim__r.Business_Units__c, Claim__r.WOD_2__BusinessCategory__r.Name,
                Date_of_Installation__c,Plant__c,Plant__r.Name,Material__c,Material__r.Name,Lab_Status__c,CreatedDate,
                Primary_Defect_Code__c,Primary_Defect_Code__r.Name FROM WOD_QC__c WHERE Claim__c=:claimId];
        return qcList;
    }
    /*
    @Auraenabled
    public static ResponseWrapper updateObsoleteProductSubmit(String productId){
        ResponseWrapper response=new ResponseWrapper('',false,'');
        try{
            List<WOD_Product_Creation__c> productList=[Select Id,Name,Status__c from WOD_Product_Creation__c Where Id =: productId LIMIT 1];
            if(productList != null && productList.size() > 0){
                productList[0].Status__c='Submitted';
                update productList[0];
                response.data=productList[0].Id;
                response.status=true;
            }
        }catch(Exception ex){
            response.status=false;
            response.errormessage=ex.getMessage();
        }
        return response;
    }
    */
    /**
     * @description Wrapper class
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
}