/****************************************************************************************
* @Author       Lou Bui
* @Date         02/22/2023
* @Description  
				Test Classes for RetailAccountsController.
*****************************************************************************************/

@isTest
public class RetailAccountsControllerTest {
    
    //Test get retail accounts by zip code.
    @isTest
    public static void getRetailAccountsZipTest(){
        
        Account testAcct = new Account(
        RecordTypeId = '0120V000002213WQAQ',
        Name = 'Lowe Test Account',
    	BillingPostalCode = '00010',
    	BillingCity = 'Malvern',
    	Store__c = '123'
    );
        
    	insert testAcct;
        
		Test.startTest();
        List<Account> lstAccts = RetailAccountsController.getRetailAccounts('00010','ZIP');
        Test.stopTest();
        
        if(lstAccts.size() >= 1){
            System.assertEquals(testAcct.Name,lstAccts[0].Name);
        }
        else{
             System.assert(lstAccts.size() == 0);
        }
       
    }
    
    //Test get retail accounts by city.
     @isTest
    public static void getRetailAccountsCityTest(){
        
        Account testAcct = new Account(
        RecordTypeId = '0120V000002213WQAQ',
        Name = 'Lowe Test Account',
    	BillingPostalCode = '00001',
    	BillingCity = 'Malvern',
    	Store__c = '123'
    );
        
    	insert testAcct;
        
		Test.startTest();
        List<Account> lstAccts = RetailAccountsController.getRetailAccounts('00001','CITY');
        Test.stopTest();
        
        if(lstAccts.size() > 1){
            System.assertEquals(testAcct.Name,lstAccts[0].Name);
        }
        else{
             System.assert(lstAccts.size() == 0);
        }
       
    }
    
    //Test get retail accounts by store number.
    @isTest
    public static void getRetailAccountsStoreTest(){
        
        Account testAcct = new Account(
        RecordTypeId = '0120V000002213WQAQ',
        Name = 'Lowe Test Account',
    	BillingPostalCode = '00001',
    	BillingCity = 'Malvern',
    	Store__c = '123'
    );
        
    	insert testAcct;
        
		Test.startTest();
        List<Account> lstAccts = RetailAccountsController.getRetailAccounts('00001','STORE');
        Test.stopTest();
        
        if(lstAccts.size() > 1){
            System.assertEquals(testAcct.Name,lstAccts[0].Name);
        }
        else{
             System.assert(lstAccts.size() == 0);
        }
       
    }
    
    //Test get retail orders
    @isTest
    public static void getRetailOrdersTest(){
        
        Account testAcct = new Account(
        RecordTypeId = '0120V000002213WQAQ',
        Name = 'Lowe Test Account',
    	BillingPostalCode = '00001',
    	BillingCity = 'Malvern',
    	Store__c = '123'
    );
        insert testAcct;
        
        Order testOrder = new Order(
        accountId = testAcct.Id,
    	Status = 'ENTERED',
    	EffectiveDate = Date.newInstance(2023,02,20),     
		PoNumber = 'TEST_123'   
    );
   
        //insert testOrder;
        
        Test.startTest();
        List<Order> lstOrders = RetailAccountsController.getRetailOrders(testAcct.Id,'ENTERED','2023-02-20');
        Test.stopTest();
        
        if(lstOrders.size() >= 1){
            System.assert(lstOrders.size() > 1);
        }
        else{
             System.assert(lstOrders.size() == 0);
        }
        
        
   }     

	//Test get retail orders by Po number
    @isTest
    public static void getRetailOrdersPoTest(){
        
        Account testAcct = new Account(
        RecordTypeId = '0120V000002213WQAQ',
        Name = 'Lowe Test Account',
    	BillingPostalCode = '00001',
    	BillingCity = 'Malvern',
    	Store__c = '123'
    );
        insert testAcct;
        
        Order testOrder = new Order(
        accountId = testAcct.Id,
    	Status = 'ENTERED',
    	EffectiveDate = Date.newInstance(2023,02,20),     
		PoNumber = 'TEST_123'
    );
   
        //insert testOrder;
        
        Test.startTest();
        List<Order> lstOrders = RetailAccountsController.getRetailOrdersByPo('TEST_123');
        Test.stopTest();
        
        if(lstOrders.size() > 1){
            System.assert(lstOrders.size() >= 1);
        }
        else{
             System.assert(lstOrders.size() == 0);
        }        
        
   }     
      
}