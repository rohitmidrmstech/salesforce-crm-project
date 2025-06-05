@isTest
private class WOD_QCControllerTest {
    
    Private static testMethod void testCreateGetQC(){
        WOD_2__Business_Category_Configuration__c bcc = WOD_TestDataFactory.createBusinessCategoryConfig('Roofing');
        bcc.WOD_Class_Action_Defect_Code__c = 'PREM';
        insert bcc;
        
        // Create Account record
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount2','','Warranty Account');
        insert acc;
        
        //Create claim record
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        clm.Business_Units__c = 'Roofing';
        insert clm;

        //Create plant record
        Plants__c plant = WOD_TestDataFactory.createPlant('test plant','123');
        plant.SOrg__c = '1501';
        plant.Obsolete__c = false;
       // plant.Business_Units__c = 'Roofing';
        insert plant;
        
            
        // Create warranty product
        WOD_2__Warranty_Product__c wp = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        wp.Producing_Plant__c = plant.id;
        wp.Sales_Org__c = '1501';
        wp.WOD_2__Business_Units__c = 'Roofing';
        insert wp;
        
        // Create warranty code
        WOD_2__Warranty_Code__c wcCode = WOD_TestDataFactory.createWarrantyCode('SEAL',wp.id);
        insert wcCode;
        
        WOD_QC__c objQC = new WOD_QC__c();
        objQC.Claim__c = clm.id;
        objQC.Primary_Defect_Code__c = wcCode.id;
        objQC.Lab_Status__c = 'Settle';
        objQC.Other_Reason__c = 'test';
        objQC.Lab_Comments__c = 'test';
        objQC.Photo_Comments__c = 'test';
        objQC.Product_Group__c = 'Roofing';
        objQC.Plant__c = plant.id;
        objQC.Material__c = wp.id;
        objQC.Ownership_Type__c = 'Second';
        objQC.Date_of_Installation__c = date.today();
        objQC.material_quantity__c= 2;
        objQC.Quantity__c= 2;
        objQC.Class_Action_Form_Received__c = 'Yes';
        objQC.Date_of_Transfer__c = date.today();
        objQC.Defect_Details__c = 'test';
        objQC.Tape_Code_A__c = '(AA) 1990 AA 123 123';
        objQC.Tape_Code_B__c = '(AA) 1990 AA 123 123';
        objQC.Tape_Code_C__c = '(AA) 1990 AA 123 123';
        objQC.Tape_Code_D__c = '(AA) 1990 AA 123 123';

        
            
        List<WOD_QCController.DynaControl> lstObjDyna = new List<WOD_QCController.DynaControl>();
        WOD_QCController.DynaControl objDyna = new WOD_QCController.DynaControl();
        WOD_QCController.DynaControl objDyna2 = new WOD_QCController.DynaControl();
        
        List<WOD_Claim_Question__c> lstQues = new List<WOD_Claim_Question__c>();
        WOD_Claim_Question__c	 cq1 = new WOD_Claim_Question__c	(Warranty_Code__c=wcCode.Id,Control_Type__c='Text',Options__c='abc',Order__c=1);
        WOD_Claim_Question__c	 cq2 = new WOD_Claim_Question__c	(Warranty_Code__c=wcCode.Id,Control_Type__c='Textarea',Options__c='def',Order__c=22);
        WOD_Claim_Question__c	 cq3 = new WOD_Claim_Question__c	(Warranty_Code__c=wcCode.Id,Control_Type__c='TextMask',Options__c='xyz',Order__c=3);
        WOD_Claim_Question__c	 cq4 = new WOD_Claim_Question__c	(Warranty_Code__c=wcCode.Id,Control_Type__c='Radio',Options__c='123',Order__c=4);

        lstQues.add(cq1);
        lstQues.add(cq2);
        lstQues.add(cq3);
        lstQues.add(cq4);
        insert lstQues; 
        
        List<String> lstOptions = new List<String>{'abc','xyz'};
        objDyna.controlType = 'ab';
        objDyna.controlLabel = 'Wind Speed';
        objDyna.inputTextLabel = 'abcd';
        objDyna.helpText = 'xyz';
        objDyna.controlVal = '1';
        objDyna.cqId = lstQues[0].id;
        objDyna.isText = true;
        objDyna.required = false;
        objDyna.showReqErrorMsg = false;
        objDyna.isTextArea = false;
        objDyna.isTextMask = false;
        objDyna.isRadio = false;
        objDyna.controlOrder = 1;
        objDyna.controlOptions = lstOptions;
        
        objDyna2.controlType = 'ab';
        objDyna2.controlLabel = 'test';
        objDyna2.inputTextLabel = 'abcd';
        objDyna2.helpText = 'xyz';
        objDyna2.controlVal = '2';
        objDyna2.cqId = lstQues[1].id;
        objDyna2.isText = false;
        objDyna2.required = false;
        objDyna2.showReqErrorMsg = false;
        objDyna2.isTextArea = true;
        objDyna2.isTextMask = false;
        objDyna2.isRadio = false;
        objDyna2.controlOrder = 2;
        objDyna2.controlOptions = lstOptions;
        
        lstObjDyna.add(objDyna);                                   
 
        //Create QC
        WOD_QCController.ResponseWrapper res = WOD_QCController.createQC(objQC,'SEAL',lstObjDyna,'Roofing');
        System.assertEquals(true,res.status);
        
        WOD_Defect_Detail__c DD = new WOD_Defect_Detail__c(Claim_Question__c=lstQues[0].Id,Value__c='abcd',Claim__c=clm.Id,QC__c=objQC.Id);
        insert DD;
        
        //Get QC method
        List<WOD_QC__c> lstQC = WOD_QCController.getQC(objQC.Id);
        System.assertEquals(1,lstQC.size());
        
        WOD_QCController.loadDynamicControls(wcCode.id,objQC.Id);
       
    }
}