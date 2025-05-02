@isTest
public class TempratureTest {
    @isTest
    public static void Warmtem(){
        decimal warm = Temprature.FtoC(60);
        system.assertEquals(15.56, warm);
    }
      @isTest
    public static void coldtem(){
        decimal cold = Temprature.FtoC(0);
        system.assertEquals(-17.78, cold);
    }
}