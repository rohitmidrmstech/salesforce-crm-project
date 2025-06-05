@isTest
public class OMRItemsControllerTest {
    public static testMethod void testMethod1() {
        OMRItemsController cls = new OMRItemsController();
        cls.productName = 'Test Prod';
        cls.productNumber = '12341234';
        cls.desciption = 'Test Desc';
        cls.search();
        
    }
}