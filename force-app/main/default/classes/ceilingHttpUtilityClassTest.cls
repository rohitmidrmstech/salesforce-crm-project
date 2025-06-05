@isTest
public class ceilingHttpUtilityClassTest {
	 public static testMethod void unitTest() { 
         String  c;
         Decimal p; 
         String pT; 
         String e;
         String prod;
         String u;
         ceilingHttpUtilityClass.Request objRequest = new ceilingHttpUtilityClass.Request();
         ceilingHttpUtilityClass.Response objResponse = new ceilingHttpUtilityClass.Response();
         ceilingHttpUtilityClass.Response objResponse1 = new ceilingHttpUtilityClass.Response(c,p,pT,e,prod,u);
         ceilingHttpUtilityClass.materialObject objMaterial = new ceilingHttpUtilityClass.materialObject();
           Test.startTest();
         ceilingHttpUtilityClass.stripLeadingZeros('Test String');
           
          Test.stopTest();
     }
}