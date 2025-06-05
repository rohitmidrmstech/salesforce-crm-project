// Created by Sneha on 1-Aug-2017 for S-503818
@isTest
public class BatchCreateNextSlotTest {
    static testMethod void test() {
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<Warehouse_Slot__c> AcctList = new List<Warehouse_Slot__c>();
        BatchCreateNextSlot AU = new BatchCreateNextSlot('Select Id from Warehouse_Slot__c limit 1');
        QL = AU.start(bc);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Warehouse_Slot__c Acc = (Warehouse_Slot__c)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        
        AU.execute(BC, AcctList);
        AU.finish(BC);        
    }
    static testMethod void test_2() {
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<Warehouse_Slot__c> AcctList = new List<Warehouse_Slot__c>();
        BatchCreateNextSlot AU = new BatchCreateNextSlot('Select Id from Warehouse_Slot__c limit 1', System.Today());
        QL = AU.start(bc);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Warehouse_Slot__c Acc = (Warehouse_Slot__c)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        
        AU.execute(BC, AcctList);
        AU.finish(BC);        
    }
}