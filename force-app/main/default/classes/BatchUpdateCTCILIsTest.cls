/**
 * Created by alanbrown on 5/10/19.
 */

@isTest
public class BatchUpdateCTCILIsTest {


    static testMethod void test1() {

        account a = new account();
        a.name ='Test Acc';
        insert a;

        Plants__c  Testingplant3 = new Plants__c();
        Testingplant3.Name ='Testing2324';
        Testingplant3.Plant_Manager__c = UserInfo.getUserId();
        Testingplant3.SAP_Plant__c = 'SAP test';
        insert Testingplant3;


        Product2 p = new product2();
        p.name='TestProduct11332345';
        p.productCode = 'islabor34';
        p.Sales_Org__c = '1100';
        p.SAP_Material__c = '9081638445_1100';
        p.ApprovingPlant__c = Testingplant3.id;
        insert p;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry where pricebook2Id=:pricebookId limit 1];
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 p1 = new Product2();
        p1.SAP_Material__c = '9080638445-1100';
        p1.Sales_Org__c = '1100';
        p1.productCode = 'islabor34';
        p1.RecordTypeId = strRecordTypeId;
        p1.Name ='Testig1233';
        p1.ApprovingPlant__c =Testingplant3.id;
        insert p1;

        order o1 = new order();
        o1.accountId = a.id;
        o1.effectiveDate = Date.Today();
        o1.pricebook2id = pricebookId;
        o1.status = 'Draft';

        //o1.invoice__c = i2.id;
        o1.Sales_Org__c = '1100';

        insert o1;

        invoice__c i1 = new invoice__c();
        i1.Order__c = o1.Id;
        i1.Order_Number__c = '123';

        insert i1;

        orderItem oi = new orderItem();
        oi.orderId = o1.id;
        oi.quantity = 20;
        oi.Product2Id = p1.id;
        oi.pricebookEntryId = pbe.id;
        oi.extended_amount__c = 11.11;


        oi.unitPrice = 33;
        oi.Material__c = '9080638445';


        insert oi;

        OrderItem oiRetrieve = [select product2id from orderitem where id = :oi.id];

        Invoice_line_item__c ili = new Invoice_line_item__c();
        ili.product__c = oiRetrieve.product2id;
        ili.invoice__c = i1.id;

        insert ili;



        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<Invoice_line_item__c> invoiceLIList = new List<Invoice_line_item__c>();
        BatchUpdateCTCInvoiceLineItemExtAmt AU = new BatchUpdateCTCInvoiceLineItemExtAmt(
                'Select invoice__c, product__c, product_value__c, invoice__r.order__c from Invoice_line_item__c'+
                        ' where id = \'' + ili.id + '\'');
        QL = AU.start(bc);

        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Invoice_Line_item__c invLi = (Invoice_Line_item__c)QIT.next();
            System.debug(invLi);
            invoiceLIList.add(invLi);
            System.debug('###1 ');
        }

        AU.execute(BC, invoiceLIList);

        OrderItem oiTest = [select extended_amount__c from orderitem where id = :oi.id];
        Invoice_line_item__c iliTest = [select product_value__c from invoice_Line_item__c where id = :ili.id];
        System.debug('*** oiTest.extended_amount__c: ' + oiTest.extended_amount__c);
        System.debug('*** ilitest.Product_value__c: ' + ilitest.Product_value__c);

        System.assert(oiTest.extended_amount__c == ilitest.Product_value__c);

        AU.finish(BC);


    }
}