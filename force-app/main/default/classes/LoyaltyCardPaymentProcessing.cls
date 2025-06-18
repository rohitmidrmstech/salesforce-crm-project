/****************************************************************************************
* @Author       Sandip Patel / Lou Bui
* @Date         08/02/2023
* @Description  
Webservice Methods to retrieve and update loyalty rebate claim records for Contractor Cash Back (CCB)
and Change Pays (CP) Program.

Change Log:
2/15/2024 - Lou Bui - Added automation controller to enable / disable records from being created/queried/updated.
06/05/2025 - Hithesh Ravuri - Modified the batch class to handle the for the BP Canada Contractor Cashback program.
06/06/2025 - Hithesh Ravuri - Modified the class to provide list of contacts which needs to be updated if wrong method is 
called by the external system.
*****************************************************************************************/

global with sharing class LoyaltyCardPaymentProcessing {
    
    global with sharing class PaymentDetails{
        webservice Decimal RebateAmount;
        webservice String ContractorId; 
        webservice String RebateClaimNo;
        webservice String PaymentRecordName;
    }
    global with sharing class NewCardDetails{
        webservice String ContractorId; //Contractor Id
        webservice String FirstName; //FirstName
        webservice String LastName; //LastName
        webservice String Phone; //Phone
        webservice String Email; //Email
        Address MailingAddress; //MailingAddress
        webservice String MailingStreet; //MailingAddress.street
        webservice String MailingCity; //MailingAddress.city
        webservice String MailingPostalCode; //MailingAddress.postalCode
        webservice String MailingState; //MailingAddress.state
        webservice String MailingCountry; //MailingAddress.country
        webservice Decimal RebateAmount; //RebateAmount
        webservice String PaymentRecordName;
        webservice String SFRequestId; //SF_RequestId__c => This is a unique Id that will be used to check if an order is incomplete.
    }
    global with sharing class NewCardRequest{
        webservice String MerchantId; //Blackhawk CT MerchantId
        webservice String SFRequestId; //SF_RequestId__c
        webservice String ProgramId; //ProgramId
        webservice List<NewCardDetails> newCardDetails; 
    }
    global with sharing class PaymentRequest{
        webservice String MerchantId; //Blackhawk CT MerchantId
        webservice String SFRequestId; //SF_RequestId__c
        webservice String ProgramId; //ProgramId
        webservice List<PaymentDetails> paymentDetails; //List of payment details.
    }
    global with sharing class IncompleteRequest{
        webservice String MerchantId; //Blackhawk CT MerchantId
        webservice String ProgramId; //ProgramId
        webservice List<String> SFRequestId; //List of SFRequestIds
    }
    global with sharing class OpenOrderRequest{
        webservice String MerchantId; //Blackhawk CT MerchantId
        webservice String ProgramId; //Blackhawk CT Card ProgramId
        webservice List<Order> Orders;
    }
    global with sharing class Loyalty_Card_Payment_Detail{
        webservice String BH_Order_Number; 
        webservice String BH_Order_Status;
        webservice String SF_CardRequestId;
    }
    global with sharing class Order{
        webservice String OrderNumber;
    }
    global with sharing class OrderInfo{
        webservice String MerchantId;
        webservice String RequestId; //Unique requestId for call our, required by Blackhawk to track calls.
        webservice List<Loyalty_Card_Payment_Detail> details; //List of SFRequestIds
    }
    global with sharing class CompleteOrderInfo{
        webservice String Name;
        webservice Date CompleteDate;
    }
    
    //Step 1 => Get Records for New Plastic Card Order
    //Method for creating New Customer => Reloadable Card Orders - aka Plastic
    webservice static NewCardRequest getNewCardUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<NewCardDetails> lstPaymentDetails = new List<NewCardDetails>();   
            NewCardRequest paymentRequest = new NewCardRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT 
                                                                         Name,
                                                                         Contact__r.FirstName,
                                                                         Contact__r.LastName,
                                                                         Contact__r.MailingStreet,
                                                                         Contact__r.MailingCity,
                                                                         Contact__r.Zip_Code_Bank_Report__c,
                                                                         Contact__r.MailingState,
                                                                         Contact__r.Mailing_Country_Bank_Report__c,
                                                                         Rebate_Amount__c,
                                                                         Contact__r.Contractor_ID__c,
                                                                         Contact__r.Phone_Bank_Report__c,
                                                                         Contact__r.Email,
                                                                         Sent_To_PO__c,
                                                                         SF_Batch_Number__c,
                                                                         SF_RequestId__c,
                                                                         BH_TransactionId__c,
                                                                         BH_Order_Number__c,
                                                                         BH_Order_Status__c,
                                                                         SF_Card_RequestId_Date__c,
                                                                         SF_CardRequestId__c,
                                                                         Contact__r.Id
                                                                         FROM Loyalty_Card_Payment_Detail__c
                                                                         WHERE ((Contact_Card_Active__c = FALSE)
                                                                                OR
                                                                                (Contact_Card_Expiration__c != NULL AND 
                                                                                 Contact_Card_Expiration__c < TODAY))
                                                                         AND Claim_Currency__c = 'USD' AND BH_Order_Status__c = NULL AND Hold_Payment__c = FALSE];
            
            
            system.debug('lstCardPaymentDetail => ' + lstCardPaymentDetail);
            //Start logic for make list of unique customer
            
            Map<String,Loyalty_Card_Payment_Detail__c> mapStrByLoyaltyCard=new Map<String,Loyalty_Card_Payment_Detail__c>();
            for(Loyalty_Card_Payment_Detail__c lcp:lstCardPaymentDetail){
                mapStrByLoyaltyCard.put(lcp.Contact__r.Contractor_ID__c,lcp);//This is map and hence it will always have unique values 
            }
            system.debug('mapStrByLoyaltyCard count => '+ mapStrByLoyaltyCard.size());
            system.debug('mapStrByLoyaltyCard List return'+mapStrByLoyaltyCard.values());
            
            //End logic for make list of unique customer
            
            if(mapStrByLoyaltyCard.values().size() > 0){
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBNCUSD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : mapStrByLoyaltyCard.values()){
                    NewCardDetails payment = new NewCardDetails();
                    payment.RebateAmount = 0;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.FirstName = item.Contact__r.FirstName;
                    payment.LastName = item.Contact__r.LastName;
                    payment.Phone = item.Contact__r.Phone_Bank_Report__c;
                    payment.Email = item.Contact__r.Email;
                    payment.MailingStreet = item.Contact__r.MailingStreet;
                    payment.MailingCity = item.Contact__r.MailingCity;
                    payment.MailingPostalCode = item.Contact__r.Zip_Code_Bank_Report__c;
                    payment.MailingState = item.Contact__r.MailingState;
                    payment.MailingCountry = item.Contact__r.Mailing_Country_Bank_Report__c;
                    payment.PaymentRecordName = item.Name;
                    payment.SFRequestId = sfRequestId;
                    lstPaymentDetails.add(payment);
                }
                for(Loyalty_Card_Payment_Detail__c item :lstCardPaymentDetail){
                    item.SF_CardRequestId__c = sfRequestId;
                    item.SF_Card_RequestId_Date__c = datetime.now(); 
                }
                paymentRequest.SFRequestId = sfRequestId;
                paymentRequest.MerchantId = System.Label.BH_USD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_USD_ProgramId;
                paymentRequest.newCardDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_CardRequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
                
            }
            return paymentRequest;
        }
        else{
            NewCardRequest paymentRequest = new NewCardRequest();
            return paymentRequest;
        }
        
    } 
    webservice static NewCardRequest getNewCardCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<NewCardDetails> lstPaymentDetails = new List<NewCardDetails>();   
            NewCardRequest paymentRequest = new NewCardRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT 
                                                                         Name,
                                                                         Contact__r.FirstName,
                                                                         Contact__r.LastName,
                                                                         Contact__r.MailingStreet,
                                                                         Contact__r.MailingCity,
                                                                         Contact__r.Zip_Code_Bank_Report__c,
                                                                         Contact__r.MailingState,
                                                                         Contact__r.Mailing_Country_Bank_Report__c,
                                                                         Rebate_Amount__c,
                                                                         Contact__r.Contractor_ID__c,
                                                                         Contact__r.Phone_Bank_Report__c,
                                                                         Contact__r.Email,
                                                                         Sent_To_PO__c,
                                                                         SF_Batch_Number__c,
                                                                         SF_RequestId__c,
                                                                         BH_TransactionId__c,
                                                                         BH_Order_Number__c,
                                                                         BH_Order_Status__c,
                                                                         SF_Card_RequestId_Date__c,
                                                                         SF_CardRequestId__c,
                                                                         Contact__r.Id
                                                                         FROM Loyalty_Card_Payment_Detail__c
                                                                         WHERE ((Contact_Card_Active__c = FALSE)
                                                                                OR
                                                                                (Contact_Card_Expiration__c != NULL AND 
                                                                                 Contact_Card_Expiration__c < TODAY))
                                                                         AND Claim_Currency__c = 'CAD' AND BH_Order_Status__c = NULL AND Hold_Payment__c = FALSE];
            
            //Start logic for make list of unique customer
            
            Map<String,Loyalty_Card_Payment_Detail__c> mapStrByLoyaltyCard=new Map<String,Loyalty_Card_Payment_Detail__c>();
            for(Loyalty_Card_Payment_Detail__c lcp:lstCardPaymentDetail){
                mapStrByLoyaltyCard.put(lcp.Contact__r.Contractor_ID__c,lcp);//This is map and hence it will always have unique values 
            }
            system.debug('List return'+mapStrByLoyaltyCard.values());
            
            //End logic for make list of unique customer
            
            if(mapStrByLoyaltyCard.values().size() > 0){
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBNCCAD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : mapStrByLoyaltyCard.values()){
                    NewCardDetails payment = new NewCardDetails();
                    payment.RebateAmount = 0;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.FirstName = item.Contact__r.FirstName;
                    payment.LastName = item.Contact__r.LastName;
                    payment.Phone = item.Contact__r.Phone_Bank_Report__c;
                    payment.Email = item.Contact__r.Email;
                    payment.MailingStreet = item.Contact__r.MailingStreet;
                    payment.MailingCity = item.Contact__r.MailingCity;
                    payment.MailingPostalCode = item.Contact__r.Zip_Code_Bank_Report__c;
                    payment.MailingState = item.Contact__r.MailingState;
                    payment.MailingCountry = item.Contact__r.Mailing_Country_Bank_Report__c;
                    payment.PaymentRecordName = item.Name;
                    payment.SFRequestId = sfRequestId;
                    lstPaymentDetails.add(payment);
                }
                for(Loyalty_Card_Payment_Detail__c item :lstCardPaymentDetail){
                    item.SF_CardRequestId__c = sfRequestId;
                    item.SF_Card_RequestId_Date__c = datetime.now(); 
                }
                paymentRequest.SFRequestId = sfRequestId;
                paymentRequest.MerchantId = System.Label.BH_CAD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_CAD_ProgramId;
                paymentRequest.newCardDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_CardRequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
                
            }
            return paymentRequest;  
        }
        else{
            NewCardRequest paymentRequest = new NewCardRequest();
            return paymentRequest;  
        }
        
    }
    
    //Step 2 => Update Records
    //			If response for createNewCard(USD or CAD) is 201 and orderNumber != null => call updateCardOrderInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus = 'ORDERSUBMITTED')
    //			If response for createNewCard(USD or CAD) is 202 => updateCardOrderInfo(string sfRequestId, string bhOrderNumber = '', string bhOrderStatus = 'INCOMPLETE')
    //			If response for createNewCard(USD or CAD) is 4XX or 5XX => Send error to SFDC Team.
    //Method for updating SF with Blackhawk Order Number and Status.
    webservice static string updateCardOrderInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            if(!String.isBlank(sfRequestId))
            {
                List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT 
                                                                             SF_RequestId__c,
                                                                             BH_Order_Number__c,
                                                                             BH_Order_Status__c
                                                                             FROM Loyalty_Card_Payment_Detail__c
                                                                             WHERE SF_CardRequestId__c = :sfRequestId];
                
                if(lstCardPaymentDetail.size() > 0){
                    for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                        item.BH_Order_Number__c = bhOrderNumber;
                        item.BH_Order_Status__c = bhOrderStatus;
                    }
                    
                    
                    //update lstCardPaymentDetail;   
                    //return 'SUCCESS: ' + lstCardPaymentDetail.size() + ' UPDATED';
                    try {
                        //Update the Loyalty Card Payment Details
                        update lstCardPaymentDetail;   
                        return 'SUCCESS: ' + lstCardPaymentDetail.size() + ' UPDATED';
                        
                    } catch(Exception e) {
                        
                        System.debug(e);
                        
                        String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                            String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                        String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateCardOrderInfo. Error: ' + e;
                        
                        if(!Test.isRunningTest()){
                            EmailUtil.sendMessage(toAddress, body,subject);
                        }
                        
                    }
                    
                }
                
                return 'ERROR: NO RECORDS UPDATED';  
            }
            
            return 'ERROR: NO RECORDS UPDATED';   
        }
        else{
            return 'ERROR: AUTOMATION CONTROLLER OFF - NO RECORDS UPDATED'; 
        }
        
    }
    
    //Step 3 => Get INCOMPLETE Order Request Records
    //			If bhOrderNumber was not returned from Step 1, Call methods queryOrderInfo(USD or CAD), returns a list of unique SF_CardRequestId__c.
    webservice static IncompleteRequest queryCardOrderInfoUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<string> lstRequestIds = new List<string>();  
            Map<string,string> mapPaymentDetails = new Map<string,string>();
            
            AggregateResult[] lstCardPaymentDetail = [SELECT 
                                                      SF_CardRequestId__c
                                                      FROM Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_CardRequestId__c != NULL AND BH_Order_Number__c = NULL AND BH_Order_Status__c = 'INCOMPLETE' AND Claim_Currency__c = 'USD' GROUP BY SF_CardRequestId__c];
            
            for(AggregateResult item: lstCardPaymentDetail){
                lstRequestIds.add(item.get('SF_CardRequestId__c').toString());
            }
            
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            incompleteRequest.MerchantId = System.Label.BH_USD_MerchantId;
            incompleteRequest.ProgramId = System.Label.BH_USD_ProgramId;
            incompleteRequest.SFRequestId = lstRequestIds;
            
            return incompleteRequest;
        }
        else{
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            return incompleteRequest;
        }
        
    }
    webservice static IncompleteRequest queryCardOrderInfoCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<string> lstRequestIds = new List<string>();  
            Map<string,string> mapPaymentDetails = new Map<string,string>();
            
            AggregateResult[] lstCardPaymentDetail = [SELECT 
                                                      SF_CardRequestId__c
                                                      FROM Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_CardRequestId__c != NULL AND BH_Order_Number__c = NULL AND BH_Order_Status__c = 'INCOMPLETE' AND Claim_Currency__c = 'CAD' GROUP BY SF_CardRequestId__c];
            
            for(AggregateResult item: lstCardPaymentDetail){
                lstRequestIds.add(item.get('SF_CardRequestId__c').toString());
            }
            
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            incompleteRequest.MerchantId = System.Label.BH_CAD_MerchantId;
            incompleteRequest.ProgramId = System.Label.BH_CAD_ProgramId;
            incompleteRequest.SFRequestId = lstRequestIds;
            
            return incompleteRequest; 
        }
        else{
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            return incompleteRequest; 
            
        }
        
        
        
    }
    
    //Step 4 => Update Records
    //			If response for createNewCard(USD or CAD) is 201 and orderNumber != null => call updateOrderInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus = 'ORDERSUBMITTED')
    //			If response for createNewCard(USD or CAD) is 202 => updateOrderInfo(string sfRequestId, string bhOrderNumber = '', string bhOrderStatus = 'INCOMPLETE')
    //			If response for createNewCard(USD or CAD) is 4XX or 5XX => Send error to SFDC Team.
    
    
    ///****Step 5 and 6 call will not be used in the hybrid approach. Blackhawk will be providing an csv file via SFTP for this update. The file will use the updateCardShipStatusCsv method.****
    //Step 5 => Get list of open orders to check for shipment confirmation.
    webservice static OrderInfo queryCardShipInfoUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            //Required Unique reqeust id for BH webservice call.
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string requestIdBefore = todayDate + uniqueNumber + 'CCBNCUSD';
            //Unique requestId for call our, required by Blackhawk to track calls.
            string requestId = requestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
            
            OrderInfo orderInfo = new OrderInfo();
            List<Loyalty_Card_Payment_Detail> lstCpd = new List<Loyalty_Card_Payment_Detail>();
            AggregateResult[] lstCardPaymentDetail = [SELECT SF_CardRequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c
                                                      FROM  Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_CardRequestId__c != NULL 
                                                      AND BH_Order_Status__c = 'ORDERSUBMITTED'
                                                      AND  Claim_Currency__c = 'USD' GROUP BY SF_CardRequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c];
            
            if(lstCardPaymentDetail.size() > 0){
                
                for(AggregateResult r : lstCardPaymentDetail){
                    Loyalty_Card_Payment_Detail cpd = new Loyalty_Card_Payment_Detail();
                    cpd.BH_Order_Number = (string)r.get('BH_Order_Number__c');
                    cpd.BH_Order_Status = (string)r.get('BH_Order_Status__c');
                    lstCpd.add(cpd);
                }
                
                orderInfo.MerchantId = System.Label.BH_CAD_MerchantId;
                //orderInfo.RequestId = requestId; //Unique requestId for call our, required by Blackhawk to track calls.
                orderInfo.details = lstCpd;
            }
            return orderInfo; 
        }
        else{
            OrderInfo orderInfo = new OrderInfo();
            return orderInfo; 
        }
        
    }
    webservice static OrderInfo queryCardShipInfoCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            //Required Unique reqeust id for BH webservice call.
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string requestIdBefore = todayDate + uniqueNumber + 'CCBNCCAD';
            string requestId = requestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
            
            OrderInfo orderInfo = new OrderInfo();
            List<Loyalty_Card_Payment_Detail> lstCpd = new List<Loyalty_Card_Payment_Detail>();
            AggregateResult[] lstCardPaymentDetail = [SELECT SF_CardRequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c
                                                      FROM  Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_CardRequestId__c != NULL 
                                                      AND BH_Order_Status__c = 'ORDERSUBMITTED'
                                                      AND  Claim_Currency__c = 'CAD' GROUP BY SF_CardRequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c];
            
            if(lstCardPaymentDetail.size() > 0){
                
                for(AggregateResult r : lstCardPaymentDetail){
                    Loyalty_Card_Payment_Detail cpd = new Loyalty_Card_Payment_Detail();
                    cpd.BH_Order_Number = (string)r.get('BH_Order_Number__c');
                    cpd.BH_Order_Status = (string)r.get('BH_Order_Status__c');
                    lstCpd.add(cpd);
                }
                
                orderInfo.MerchantId = System.Label.BH_CAD_MerchantId;
                //orderInfo.RequestId = requestId;
                orderInfo.details = lstCpd;
            }
            return orderInfo; 
        }
        else{
            OrderInfo orderInfo = new OrderInfo();
            return orderInfo; 
        }
        
    }
    
    //Step 6 => Update record with shipping information.
    //			If respone for queryCardShippingInfo(USD or CAD) is 200 and orderStatus = 'SHIPPED' OR 'COMPLETE' => call updateCardShipStatus((string bhOrderNumber, string bhOrderStatus, date shippedDate))
    //			If respone for queryCardShippingInfo(USD or CAD) is !=200 or orderStatus != 'SHIPPED' OR 'COMPLETE' => retry call next day.
    webservice static string updateCardShipStatus(string bhOrderNumber, string bhOrderStatus, date shippedDate){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            date expiryDate = date.parse(System.Label.BH_Card_Expiration_Date);
            
            List<Loyalty_Card_Payment_Detail__c> lstOpenOrderDetails = [SELECT 
                                                                        BH_Order_Number__c,Contact_Card_Active__c,
                                                                        BH_Order_Status__c,Contact_Card_Expiration__c,
                                                                        Card_Shipped_Date__c,Contact__r.Email,Contact__r.Contractor_ID__c
                                                                        FROM Loyalty_Card_Payment_Detail__c
                                                                        WHERE BH_Order_Status__c = 'ORDERSUBMITTED' AND BH_Order_Number__c = :bhOrderNumber AND Card_Shipped_Date__c = NULL AND Contact__r.Contractor_ID__c != NULL];
            
            //List of unique Contractor Ids from Loyalty_Card_Payment_Detail__c.
            Set<String> setContractorIDs = new Set<String>();
            
            For(Loyalty_Card_Payment_Detail__c r:lstOpenOrderDetails){
                setContractorIDs.add(r.Contact__r.Contractor_ID__c);
            }
            
            if(lstOpenOrderDetails.size() > 0){
                for(Loyalty_Card_Payment_Detail__c item : lstOpenOrderDetails){
                    item.BH_Order_Status__c = bhOrderStatus;
                    item.Card_Shipped_Date__c = shippedDate;
                    item.Contact_Card_Active__c = TRUE;
                }
                
                try {
                    //Update Loyalty_Card_Payment_Detail__c
                    update lstOpenOrderDetails;
                    
                    //Call batch job to update contacts.
                    LoyaltyContactBatchUpdate objbatch = new LoyaltyContactBatchUpdate(setContractorIDs);
                    Database.executeBatch(objbatch, 200);
                    //end update contact
                    
                    return 'SUCCESS: ' + lstOpenOrderDetails.size() + ' UPDATED';
                    
                } catch(Exception e) {
                    
                    System.debug(e);
                    String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                        String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                    String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateCardOrderInfo. Error: ' + e;
                    EmailUtil.sendMessage(toAddress, body,subject);
                }
                
            }
            
            return 'ERROR: NO RECORDS UPDATED';
        }
        else{
            return 'ERROR: AUTOMATION CONTROLLER OFF - NO RECORDS UPDATED';
        }
        
    }
    
    //Step 6a Hybrid => Update record with shipping information.
    // Method for PI/PO to use for updating card shipment information with CSV file from Blackhawk to SFTP.
    webservice static string updateCardShipStatusCsv(List<CompleteOrderInfo> shipmentDetails){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            date expiryDate = date.parse(System.Label.BH_Card_Expiration_Date);
            
            Map<String,Date> mapshipmentDetails = new Map<String,Date>();
            
            for(CompleteOrderInfo record : shipmentDetails){
                mapshipmentDetails.put(record.Name, record.CompleteDate);
            }
            
            List<Loyalty_Card_Payment_Detail__c> lstOpenOrderDetails = [SELECT 
                                                                        Name,BH_Order_Number__c,Contact_Card_Active__c,
                                                                        BH_Order_Status__c,Contact_Card_Expiration__c,
                                                                        Card_Shipped_Date__c,Contact__r.Email,Contact__r.Contractor_ID__c
                                                                        FROM Loyalty_Card_Payment_Detail__c
                                                                        WHERE BH_Order_Status__c = 'ORDERSUBMITTED' AND Name IN :mapshipmentDetails.keyset() AND Card_Shipped_Date__c = NULL AND Contact__r.Contractor_ID__c != NULL];
            
            //List of unique Contractor Ids from Loyalty_Card_Payment_Detail__c.
            Set<String> setContractorIDs = new Set<String>();
            
            For(Loyalty_Card_Payment_Detail__c r:lstOpenOrderDetails){
                setContractorIDs.add(r.Contact__r.Contractor_ID__c);
            }
            
            if(lstOpenOrderDetails.size() > 0){
                for(Loyalty_Card_Payment_Detail__c item : lstOpenOrderDetails){
                    item.BH_Order_Status__c = 'COMPLETE';
                    item.Card_Shipped_Date__c = mapshipmentDetails.get(item.Name);
                    item.Contact_Card_Active__c = TRUE;
                }
                
                try {
                    //Update Loyalty_Card_Payment_Detail__c
                    update lstOpenOrderDetails;
                    
                    //Call batch job to update contacts.
                    LoyaltyContactBatchUpdate objbatch = new LoyaltyContactBatchUpdate(setContractorIDs);
                    Database.executeBatch(objbatch, 200);
                    //end update contact
                    
                    return 'SUCCESS: ' + lstOpenOrderDetails.size() + ' UPDATED';
                    
                } catch(Exception e) {
                    
                    System.debug(e);
                    String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                        String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                    String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateCardOrderInfo. Error: ' + e;
                    EmailUtil.sendMessage(toAddress, body,subject);
                }
                
            }
            
            return 'ERROR: NO RECORDS UPDATED';  
        }
        else{
            return 'ERROR AUTOMATION CONTROLLER OFF: NO RECORDS UPDATED';  
        }
        
    }
    
    //**Start of Funding Process***
    
    //Step 7 => Get Records for Funding Order
    webservice static PaymentRequest getCCBRoofingFundingCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<PaymentDetails> lstPaymentDetails = new List<PaymentDetails>();   
            PaymentRequest paymentRequest = new PaymentRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT Id,Name,Rebate_Amount__c,Contact__r.Contractor_ID__c,Claim_Currency__c,Business_Unit__c,BH_Order_Status__c,Rebate_Claim__r.Name
                                                                         FROM   Loyalty_Card_Payment_Detail__c
                                                                         WHERE  Rebate_Amount__c > 0 
                                                                         AND  (Business_Unit__c = 'Roofing' OR Business_Unit__c = 'BP Roofing')
                                                                         AND Claim_Currency__c = 'CAD' 
                                                                         AND BH_Order_Status__c = NULL
                                                                         AND Hold_Payment__c = FALSE];
            
            if(lstCardPaymentDetail.size() > 0){
                
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBRCAD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                    PaymentDetails payment = new PaymentDetails();
                    payment.RebateAmount = item.Rebate_Amount__c;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.RebateClaimNo = item.Rebate_Claim__r.Name;
                    payment.PaymentRecordName = item.Name;
                    lstPaymentDetails.add(payment);
                    item.SF_RequestId__c = sfRequestId;
                    item.SF_RequestId_Date__c = datetime.now();
                }
                
                paymentRequest.SFRequestId = sfRequestId;
                //paymentRequest.MerchantId = '60300004053';
                //paymentRequest.ProgramId = '95032111';
                paymentRequest.MerchantId = System.Label.BH_CAD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_CAD_ProgramId;
                paymentRequest.paymentDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_RequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
                
            }
            
            return paymentRequest; 
        }
        else{
            PaymentRequest paymentRequest = new PaymentRequest();
            return paymentRequest; 
        }
        
    }   
    webservice static PaymentRequest getCCBRoofingFundingUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<PaymentDetails> lstPaymentDetails = new List<PaymentDetails>();   
            PaymentRequest paymentRequest = new PaymentRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT Id,Name,Rebate_Amount__c,Contact__r.Contractor_ID__c,Claim_Currency__c,Business_Unit__c,BH_Order_Status__c,Rebate_Claim__r.Name
                                                                         FROM   Loyalty_Card_Payment_Detail__c
                                                                         WHERE  Rebate_Amount__c > 0 
                                                                         AND  Business_Unit__c = 'Roofing' 
                                                                         AND Claim_Currency__c = 'USD' 
                                                                         AND BH_Order_Status__c = NULL
                                                                         AND Hold_Payment__c = FALSE];
            
            if(lstCardPaymentDetail.size() > 0){
                
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBRUSD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                    PaymentDetails payment = new PaymentDetails();
                    payment.RebateAmount = item.Rebate_Amount__c;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.RebateClaimNo = item.Rebate_Claim__r.Name;
                    payment.PaymentRecordName = item.Name;
                    lstPaymentDetails.add(payment);
                    item.SF_RequestId__c = sfRequestId;
                    item.SF_RequestId_Date__c = datetime.now();
                }
                
                paymentRequest.SFRequestId = sfRequestId;
                //paymentRequest.MerchantId = '60300004053';
                //paymentRequest.ProgramId = '95032111';
                paymentRequest.MerchantId = System.Label.BH_USD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_USD_ProgramId;
                paymentRequest.paymentDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_RequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
            }
            
            return paymentRequest;
            
        }
        else{
            PaymentRequest paymentRequest = new PaymentRequest();
            return paymentRequest; 
        }
        
    }
    webservice static PaymentRequest getCCBSidingFundingCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<PaymentDetails> lstPaymentDetails = new List<PaymentDetails>();   
            PaymentRequest paymentRequest = new PaymentRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT Id,Name,Rebate_Amount__c,Contact__r.Contractor_ID__c,Claim_Currency__c,Business_Unit__c,BH_Order_Status__c,Rebate_Claim__r.Name
                                                                         FROM   Loyalty_Card_Payment_Detail__c
                                                                         WHERE Rebate_Amount__c > 0 
                                                                         AND Business_Unit__c != 'Roofing' 
                                                                         AND Claim_Currency__c = 'CAD' 
                                                                         AND BH_Order_Status__c = NULL
                                                                         AND Hold_Payment__c = FALSE];
            if(lstCardPaymentDetail.size() > 0){
                
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBSCAD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                    PaymentDetails payment = new PaymentDetails();
                    payment.RebateAmount = item.Rebate_Amount__c;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.RebateClaimNo = item.Rebate_Claim__r.Name;
                    payment.PaymentRecordName = item.Name;
                    lstPaymentDetails.add(payment);
                    item.SF_RequestId__c = sfRequestId;
                    item.SF_RequestId_Date__c = datetime.now();
                }
                
                paymentRequest.SFRequestId = sfRequestId;
                //paymentRequest.MerchantId = '60300004053';
                //paymentRequest.ProgramId = '95032111';
                paymentRequest.MerchantId = System.Label.BH_CAD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_CAD_ProgramId;
                paymentRequest.paymentDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_RequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
            }
            return paymentRequest;
            
        }
        else{
            PaymentRequest paymentRequest = new PaymentRequest();
            return paymentRequest; 
        }        
        
    }
    webservice static PaymentRequest getCCBSidingFundingUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<PaymentDetails> lstPaymentDetails = new List<PaymentDetails>();   
            PaymentRequest paymentRequest = new PaymentRequest();
            
            List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT Id,Name,Rebate_Amount__c,Contact__r.Contractor_ID__c,Claim_Currency__c,Business_Unit__c,BH_Order_Status__c,Rebate_Claim__r.Name
                                                                         FROM   Loyalty_Card_Payment_Detail__c
                                                                         WHERE Rebate_Amount__c > 0 
                                                                         AND Business_Unit__c != 'Roofing' 
                                                                         AND Claim_Currency__c = 'USD' 
                                                                         AND BH_Order_Status__c = NULL
                                                                         AND Hold_Payment__c = FALSE];
            if(lstCardPaymentDetail.size() > 0){
                
                string todayDate = string.valueOfGmt(datetime.now());
                string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
                string sfRequestIdBefore = todayDate + uniqueNumber + 'CCBSUSD';
                string sfRequestId = sfRequestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
                
                system.debug('sfRequestId => ' + sfRequestId);
                
                for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                    PaymentDetails payment = new PaymentDetails();
                    payment.RebateAmount = item.Rebate_Amount__c;
                    payment.ContractorId = item.Contact__r.Contractor_ID__c;
                    payment.RebateClaimNo = item.Rebate_Claim__r.Name;
                    payment.PaymentRecordName = item.Name;
                    lstPaymentDetails.add(payment);
                    item.SF_RequestId__c = sfRequestId;
                    item.SF_RequestId_Date__c = datetime.now();
                }
                
                paymentRequest.SFRequestId = sfRequestId;
                //paymentRequest.MerchantId = '60300004053';
                //paymentRequest.ProgramId = '95032111';
                paymentRequest.MerchantId = System.Label.BH_USD_MerchantId;
                paymentRequest.ProgramId = System.Label.BH_USD_ProgramId;
                paymentRequest.paymentDetails = lstPaymentDetails;
                
                update lstCardPaymentDetail; //Update SF_RequestId__c on Loyalty_Card_Payment_Details__c for each record in batch.
            }
            
            return paymentRequest;
            
        }
        else{
            
            PaymentRequest paymentRequest = new PaymentRequest();
            return paymentRequest; 
        }
        
    }
    
    //Step 8 => Update Records
    //			If response for PaymentRequest(USD or CAD) is 201 and orderNumber != null => call updateOrderInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus = 'ORDERSUBMITTED')
    //			If response for PaymentRequest(USD or CAD) is 202 => updateOrderInfo(string sfRequestId, string bhOrderNumber = '', string bhOrderStatus = 'INCOMPLETE')
    //			If response for PaymentRequest(USD or CAD) is 4XX or 5XX => Send error to SFDC Team.
    //Method for updating SF with Blackhawk Order Number and Status.
    webservice static string updateOrderFundingInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            if(!String.isBlank(sfRequestId))
            {
                List<Loyalty_Card_Payment_Detail__c> lstCardPaymentDetail = [SELECT 
                                                                             SF_RequestId__c,
                                                                             BH_Order_Number__c,
                                                                             BH_Order_Status__c
                                                                             FROM Loyalty_Card_Payment_Detail__c
                                                                             WHERE SF_RequestId__c = :sfRequestId
                                                                            ];
                
                if(lstCardPaymentDetail.size() > 0){
                    for(Loyalty_Card_Payment_Detail__c item : lstCardPaymentDetail){
                        item.BH_Order_Number__c = bhOrderNumber;
                        item.BH_Order_Status__c = bhOrderStatus;
                    }
                    
                    try {
                        //Update the Loyalty Card Payment Details
                        update lstCardPaymentDetail;  
                        return 'SUCCESS: ' + lstCardPaymentDetail.size() + ' UPDATED';
                        
                    } catch(Exception e) {
                        
                        System.debug(e);
                        String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                            String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                        String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateOrderFundingInfo. Error: ' + e;
                        EmailUtil.sendMessage(toAddress, body,subject);
                    }
                    
                }
                
                return 'ERROR: NO RECORDS UPDATED';   
            }
            return 'ERROR: NO RECORDS UPDATED';   
        }
        else{
            return 'ERROR AUTOMATION CONTROLLER OFF: NO RECORDS UPDATED'; 
        }
        
    }
    
    //Step 9 => Get INCOMPLETE Funding Order Request Records
    //			If bhOrderNumber was not returned from Step 7, Call methods queryFundingInfoUSD(USD or CAD), returns a list of unique SF_RequestId__c.
    webservice static IncompleteRequest queryOrderFundingInfoUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<string> lstRequestIds = new List<string>();  
            Map<string,string> mapPaymentDetails = new Map<string,string>();
            
            AggregateResult[] lstCardPaymentDetail = [SELECT 
                                                      SF_RequestId__c
                                                      FROM Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_RequestId__c != NULL AND BH_Order_Number__c = NULL AND BH_Order_Status__c = 'INCOMPLETE' AND Claim_Currency__c = 'USD' GROUP BY SF_RequestId__c];
            
            for(AggregateResult item: lstCardPaymentDetail){
                lstRequestIds.add(item.get('SF_RequestId__c').toString());
            }
            
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            incompleteRequest.MerchantId = System.Label.BH_USD_MerchantId;
            incompleteRequest.ProgramId = System.Label.BH_USD_ProgramId;
            incompleteRequest.SFRequestId = lstRequestIds;
            
            return incompleteRequest;
        }
        else{
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            return incompleteRequest;
        }
        
    }
    webservice static IncompleteRequest queryOrderFundingInfoCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<string> lstRequestIds = new List<string>();  
            Map<string,string> mapPaymentDetails = new Map<string,string>();
            
            AggregateResult[] lstCardPaymentDetail = [SELECT 
                                                      SF_RequestId__c
                                                      FROM Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_RequestId__c != NULL AND BH_Order_Number__c = NULL AND BH_Order_Status__c = 'INCOMPLETE' AND Claim_Currency__c = 'CAD' GROUP BY SF_RequestId__c];
            
            for(AggregateResult item: lstCardPaymentDetail){
                lstRequestIds.add(item.get('SF_RequestId__c').toString());
            }
            
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            incompleteRequest.MerchantId = System.Label.BH_CAD_MerchantId;
            incompleteRequest.ProgramId = System.Label.BH_CAD_ProgramId;
            incompleteRequest.SFRequestId = lstRequestIds;
            
            return incompleteRequest;
        }
        else{
            IncompleteRequest incompleteRequest = new IncompleteRequest();
            return incompleteRequest;
        }
        
    }
    
    //Step 10 => Update Records
    //			If response for createNewCard(USD or CAD) is 201 and orderNumber != null => call updateOrderFundingInfo(string sfRequestId, string bhOrderNumber, string bhOrderStatus = 'ORDERSUBMITTED')
    //			If response for createNewCard(USD or CAD) is 202 => updateOrderFundingInfo(string sfRequestId, string bhOrderNumber = '', string bhOrderStatus = 'INCOMPLETE')
    //			If response for createNewCard(USD or CAD) is 4XX or 5XX => Send error to SFDC Team.
    
    
    //11-9-2023 Lou Bui - We will not need this methods anymore, per Coby from Blackhawk, this call will not return the funding date.
    //Step 11 => Get list of open Funding orders to check for payment confirmation.
    //Old Name => getOrderInfo
    webservice static OrderInfo queryShipFundingInfoUSD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            //Required Unique reqeust id for BH webservice call.
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string requestIdBefore = todayDate + uniqueNumber + 'CCBNCUSD';
            //Unique requestId for call our, required by Blackhawk to track calls.
            string requestId = requestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
            
            OrderInfo orderInfo = new OrderInfo();
            List<Loyalty_Card_Payment_Detail> lstCpd = new List<Loyalty_Card_Payment_Detail>();
            AggregateResult[] lstCardPaymentDetail = [SELECT SF_RequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c
                                                      FROM  Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_RequestId__c != NULL 
                                                      AND BH_Order_Status__c = 'ORDERSUBMITTED'
                                                      AND  Claim_Currency__c = 'USD' GROUP BY SF_RequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c];
            
            if(lstCardPaymentDetail.size() > 0){
                
                for(AggregateResult r : lstCardPaymentDetail){
                    Loyalty_Card_Payment_Detail cpd = new Loyalty_Card_Payment_Detail();
                    cpd.BH_Order_Number = (string)r.get('BH_Order_Number__c');
                    cpd.BH_Order_Status = (string)r.get('BH_Order_Status__c');
                    lstCpd.add(cpd);
                }
                
                orderInfo.MerchantId = System.Label.BH_CAD_MerchantId;
                //orderInfo.RequestId = requestId; //Unique requestId for call our, required by Blackhawk to track calls.
                orderInfo.details = lstCpd;
            }
            return orderInfo;
        }
        else{
            OrderInfo orderInfo = new OrderInfo();
            return orderInfo;
        }
        
    }
    webservice static OrderInfo queryShipFundingInfoCAD(){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            //Required Unique reqeust id for BH webservice call.
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string requestIdBefore = todayDate + uniqueNumber + 'CCBNCCAD';
            string requestId = requestIdBefore.replaceAll('[^a-zA-Z0-9]', '');
            
            OrderInfo orderInfo = new OrderInfo();
            List<Loyalty_Card_Payment_Detail> lstCpd = new List<Loyalty_Card_Payment_Detail>();
            AggregateResult[] lstCardPaymentDetail = [SELECT SF_RequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c
                                                      FROM  Loyalty_Card_Payment_Detail__c
                                                      WHERE SF_RequestId__c != NULL 
                                                      AND BH_Order_Status__c = 'ORDERSUBMITTED'
                                                      AND  Claim_Currency__c = 'CAD' GROUP BY SF_RequestId__c,
                                                      BH_Order_Number__c,
                                                      BH_Order_Status__c];
            
            if(lstCardPaymentDetail.size() > 0){
                
                for(AggregateResult r : lstCardPaymentDetail){
                    Loyalty_Card_Payment_Detail cpd = new Loyalty_Card_Payment_Detail();
                    cpd.BH_Order_Number = (string)r.get('BH_Order_Number__c');
                    cpd.BH_Order_Status = (string)r.get('BH_Order_Status__c');
                    lstCpd.add(cpd);
                }
                
                orderInfo.MerchantId = System.Label.BH_CAD_MerchantId;
                //orderInfo.RequestId = requestId;
                orderInfo.details = lstCpd;
            }
            return orderInfo;
        }
        else{
            OrderInfo orderInfo = new OrderInfo();
            return orderInfo;
        }
        
        
    }
    
    
    //Step 11 => Methods to update order to complete.
    webservice static string updateFundingShipStatus(string bhOrderNumber, string bhOrderStatus, date shippedDate){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            List<Loyalty_Card_Payment_Detail__c> lstOpenOrderDetails = [SELECT 
                                                                        Rebate_Claim__c,
                                                                        BH_Order_Number__c,
                                                                        BH_Order_Status__c,
                                                                        Bank_Payment_Date__c
                                                                        FROM Loyalty_Card_Payment_Detail__c
                                                                        WHERE BH_Order_Number__c = :bhOrderNumber AND Bank_Payment_Date__c = NULL AND BH_Order_Status__c = 'ORDERSUBMITTED'];
            
            if(lstOpenOrderDetails.size() > 0){
                try {
                    for(Loyalty_Card_Payment_Detail__c item : lstOpenOrderDetails){
                        item.BH_Order_Status__c = bhOrderStatus;
                        item.Bank_Payment_Date__c = shippedDate;
                        
                    }
                    
                    update lstOpenOrderDetails;
                    
                    //List of unique Rebate Calims from Loyalty_Card_Payment_Detail__c.
                    Map<String,Date> uniqueRebateClaimData = new Map<String,Date>();
                    
                    For(Loyalty_Card_Payment_Detail__c r:lstOpenOrderDetails){
                        uniqueRebateClaimData.put(r.Rebate_Claim__c, r.Bank_Payment_Date__c);
                    }
                    //system.debug('uniqueRebateClaimData => ' + uniqueRebateClaimData);
                    //start update Rebate Claim
                    LoyaltyRebateClaimBatchUpdate objbatch = new LoyaltyRebateClaimBatchUpdate(uniqueRebateClaimData);
                    Database.executeBatch(objbatch, 200);
                    //end update Rebate Claim
                    
                    
                    return 'SUCCESS: ' + lstOpenOrderDetails.size() + ' UPDATED';
                    
                } catch(Exception e) {
                    
                    System.debug(e);
                    String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                        String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                    String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateFundingShipStatus. Error: ' + e;
                    EmailUtil.sendMessage(toAddress, body,subject);
                }
            }
            
            return 'ERROR: NO RECORDS UPDATED';  
        }
        else{
            return 'ERROR AUTOMATION CONTROLLER OFF: NO RECORDS UPDATED';  
        }
        
    }
    
    //Step 11 => Method Hybrid to update order to complete.
    //Method for PI/PO to use for updating card shipment information with CSV file from Blackhawk to SFTP.
    webservice static string updateFundingShipStatusCsv(List<CompleteOrderInfo> shipmentDetails){
        
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            Map<String,Date> mapshipmentDetails = new Map<String,Date>();
            set<string> contactNames = new set<string>();
            set<string> BHOrderNumber = new set<string>();
            integer counter = 0;
            for(CompleteOrderInfo record : shipmentDetails){
                mapshipmentDetails.put(record.Name, record.CompleteDate);
            }
            
            List<Loyalty_Card_Payment_Detail__c> lstOpenOrderDetails = [SELECT 
                                                                        Name,Rebate_Claim__c,
                                                                        BH_Order_Number__c,
                                                                        BH_Order_Status__c,
                                                                        Bank_Payment_Date__c,
                                                                        Contact_Card_Active__c,
                                                                        Contact__c,
                                                                        Contact__r.Name
                                                                        FROM Loyalty_Card_Payment_Detail__c
                                                                        WHERE Name IN :mapshipmentDetails.keyset() AND Bank_Payment_Date__c = NULL AND BH_Order_Status__c = 'ORDERSUBMITTED'];
            
            if(lstOpenOrderDetails.size() > 0){
                try {
                    for(Loyalty_Card_Payment_Detail__c item : lstOpenOrderDetails){
                        if(item.Contact_Card_Active__c){
                            item.BH_Order_Status__c = 'COMPLETE';
                            item.Bank_Payment_Date__c = mapshipmentDetails.get(item.Name);
                            counter++;
                        } else{
                            contactNames.add(item.Contact__r.Name);
                            BHOrderNumber.add(item.BH_Order_Number__c);
                        }
                    }
                    
                    update lstOpenOrderDetails;
                    
                    //List of unique Rebate Calims from Loyalty_Card_Payment_Detail__c.
                    Map<String,Date> uniqueRebateClaimData = new Map<String,Date>();
                    
                    For(Loyalty_Card_Payment_Detail__c r:lstOpenOrderDetails){
                        if(r.Contact_Card_Active__c){
                            uniqueRebateClaimData.put(r.Rebate_Claim__c, r.Bank_Payment_Date__c);
                        } else{
                            contactNames.add(r.Contact__r.Name);
                            BHOrderNumber.add(r.BH_Order_Number__c);
                        }
                    }
                    //system.debug('uniqueRebateClaimData => ' + uniqueRebateClaimData);
                    //start update Rebate Claim
                    if(!uniqueRebateClaimData.isempty()){
                        LoyaltyRebateClaimBatchUpdate objbatch = new LoyaltyRebateClaimBatchUpdate(uniqueRebateClaimData);
                        Database.executeBatch(objbatch, 200);
                    }
                    //end update Rebate Claim
                    
                    if(contactNames.size()>0){
                        String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                            String subject = 'Contact card is not active but rebate claims came for the claim payment';
                        String body = '	List of contact names whose claims are getting updated without card active is' + contactNames + '. The BH order number for this order is - ' + BHOrderNumber;
                        EmailUtil.sendMessage(toAddress, body,subject);
                    }
                    
                    return 'SUCCESS: ' + counter + ' UPDATED';
                    
                } catch(Exception e) {
                    
                    System.debug(e);
                    String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                        String subject = 'Error with DML operation for LoyaltyCardPaymentProcessing';
                    String body = 'Error with DML operation for LoyaltyCardPaymentProcessing updateFundingShipStatus. Error: ' + e;
                    EmailUtil.sendMessage(toAddress, body,subject);
                }
            }
            
            return 'ERROR: NO RECORDS UPDATED';
        }
        else{
            return 'ERROR AUTOMATION CONTROLLER OFF: NO RECORDS UPDATED';
        }
        
    }
}