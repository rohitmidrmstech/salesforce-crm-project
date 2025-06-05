@isTest
public class biuCaseUtil_Test {

    @isTest
    public static void test() {
        Case csNew = new Case(Documents__c = 'https://google.com/logo.png');
        biuCaseUtil.formatDocumentData(csNew, csNew);
    }
}