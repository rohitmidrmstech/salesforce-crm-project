@isTest
public class EventUtilityTest {
    @isTest
    public static void ChecklengthEvent(){
     string res = EventUtility.Event('india');
        system.assertEquals(null, res);
    }
     @isTest
    public static void CheckStatus(){
     string priority = EventUtility.Event('ca');
        system.assertEquals('High', priority);
    }
    @isTest
    public static void CheckStatusOffPririty(){
     string priority = EventUtility.Event('Ba');
        system.assertEquals('cold', priority);
    }
    
    
    
    
}