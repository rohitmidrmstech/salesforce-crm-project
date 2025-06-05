@isTest
private class CT_IssuesListController_Test {
    
    static testMethod void testIssues(){
        
        List<CT_Issues_Problem_Code__c> custSett = new List<CT_Issues_Problem_Code__c>();
        CT_Issues_Problem_Code__c probCode1 = new CT_Issues_Problem_Code__c();
        probCode1.Name = '317';
        probCode1.Category__c = 'Bead';
        probCode1.Problem__c = 'Paper Delamination';
        probCode1.Code__c = 'DEL';
        
        CT_Issues_Problem_Code__c probCode2 = new CT_Issues_Problem_Code__c();
        probCode2.Name = '308';
        probCode2.Category__c = 'Cove and Cornice';
        probCode2.Problem__c = 'Paper Color';
        probCode2.Code__c = 'QLT';
        
        custSett.add(probCode1);
        custSett.add(probCode2);
        insert custSett;
        
        Id caseRecordTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        Id caseRecordTypeId1 =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        
        Id creditRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
        
        account a = new account();
        a.name ='Test Acc';
        insert a;
        
        Case c = new Case();
        c.RecordTypeId = caseRecordTypeId;
        c.Origin = 'Web';
        c.Status = 'Draft';
        c.AccountId = a.Id;
        c.Portal_Subject__c = 'Invoice Discrepancy';
        c.Product_Category__c = 'Board';
        insert c;
        
        Case c1 = new Case();
        c1.RecordTypeId = caseRecordTypeId1;
        c1.Origin = 'Web';
        c1.Status = 'Draft';
        c1.AccountId = a.Id;
        c1.Portal_Subject__c = 'Invoice Discrepancy';
        c.Product_Category__c = 'Board';
        insert c1;
        
        Plants__c  Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324123';
        Testingplant1.SAP_Plant__c = '0410';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        insert Testingplant1;        
        
        
        product2 p = new product2();
        p.name='TestProduct';
        p.productCode = 'labor3456';
        p.ApprovingPlant__c = Testingplant1.Id;
        Test.startTest();
        insert p; 
        Test.stopTest();
        
        //product2 p = [Select Id from product2 LIMIT 1];
                        
        case_order_items__c coi = new case_order_items__c();
        coi.case__c = c.id;
        coi.currency__c = 'USD';
        coi.product__c = p.id;
        insert coi;
        
        Issues__c issue = new Issues__c();
        issue.Case__c = c.Id;
        issue.Category__c = 'Cove and Cornice';
        issue.Problem__c = 'Paper Color';
        issue.RecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Issues').getRecordTypeId();
        issue.QTY__c = 20.0;
        issue.UOM2__c = 'MSF';
        insert issue;
        
        
        issue.Category__c = 'Bead';
        issue.Problem__c = 'Paper Delamination';
        update issue;
        
       CT_Common_Settings__c config = CT_Common_Settings__c.getOrgDefaults();
        config.Pricing_Endpoint__c = 'http://sap-wddev.certainteed.com/saper/EQX100/SFDCPricingRequest';
        config.Pricing_Username__c = 'timrl';
        config.Pricing_Password__c = 'P@ido!';
        upsert config;
        
        CT_PricingWebService obj = new CT_PricingWebService();
        obj.requestMaterialPrice();
        obj.requestPriceInfo();
        
        CT_IssuesListController.fetchIssuesData(c.Id, 'Issues');
        String issuesJson = '[{"caseOrderItem":"'+coi.Name+'","insertedFromTrigger":true,"isEdit":false,"isNewIssue":false,"isSave":true,"issueId":"'+issue.Id+'","issueNumber":"'+issue.Name+'","problemPickVals":["--None--","Area Price Used, S/B Exception","Customer Category Codes Wrong","Customer Error","Ellenton Discount","Exception pricing","Exception used S/B Area Price","Face of Invoice Incorrect","Incorrect Product/Quantity","Incorret Area Price","Job pricing","Negotiated Discount","No Area price","Plant Shipping Problem (Delay)","Pre-increase price","Price Changed Since Ship Date","Pricing Data Entered Late or Submitted Late","Proofing Error","Rebate discount/rebate error","Rep/Customer Misunderstanding","Sales Quote","System Problem","Top loading fee","Unknown"],"product":"Dummy Ref Product","productId":"01t0j000000POuaAAG","productName":"Dummy Ref Product","category":"Pricing","problem":"Customer Error"}]';
        String fetchPricesJson = '['+
    '{'+
        '"caseId": "'+c.Id+'",'+
        '"caseStatus": "Pending VP",'+
        '"discount": "8.00",'+
        '"exactAmount_2": "-22.08",'+
        '"insertedFromTrigger": false,'+
        '"isEdit": true,'+
        '"isNewIssue": false,'+
        '"isSave": false,'+
        '"issueId": "a1h0j0000001EufAAE",'+
        '"issueNumber": "00002889",'+
        '"price": "6.00",'+
        '"problemPickVals": [],'+
        '"productCode": "640193",'+
        '"productDescription": "FIBAFUSE ROLL 250\' TAPE 20/CTN",'+
        '"productId": "01t0j000000POoXAAW",'+
        '"productName": "FIBAFUSE ROLL 250\' TAPE 20/CTN",'+
        '"quantity": "-4.000",'+
        '"recordTypeId": "0120j0000004RyBAAU",'+
        '"uom_1": "CAR",'+
        '"uom_2": "CAR",'+
        '"category": "Promotions/Allowances"'+
    '}'+
']';
        
        
        String insertIssuesJson = '[{"quantityOrdered":"","uom_1":"EA","exactQuantity":"","price":"2","uom_2":"EA","unitPrice":"","discount":"5","isNewIssue":false,"exactAmount_1":"","quantity":"4","exactAmount_2":"","isEdit":false,"caseId":"'+c.Id+'","productId":"'+p.Id+'","recordTypeName":"Credit","uniqueId":909,"productDescription":"PALLET 45X45 4 WAY HEAT TRT","productCode":"126690","isSave":true}]';
        CT_IssuesListController.updateIssuesListData(issuesJson);
        CT_IssuesListController.getPickListEntries((String)c.id);
        CT_IssuesListController.getRecordtypeMap((String)c.id);
        CT_IssuesListController.getCaseDetails(c.Id);
        CT_IssuesListController.insertNewIssue('Order Entry', 'Incorrect Order Type', c.Id, 'Issues');
        //CT_IssuesListController.insertCreditRebillIssue(issue, c.Id, 'Credit', p.Id);
        //CT_IssuesListController.updateIssuesPrice(c.Id,'Credit');
        CT_IssuesListController.creditRebillTotal(c.Id);
        CT_IssuesListController.getUserProfileName();
        CT_IssuesListController.fetchIssuesPrice(c.Id, fetchPricesJson);
        CT_IssuesListController.insertIssues(insertIssuesJson);
        CT_IssuesListController.getWrapper(c.Id);
        
    }
    
}