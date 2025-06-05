@isTest
public class AccountRetrievalTest {
    @isTest
    static void testNewAccount() {
        String cli = '5551231234';
 //       Contact c = new Contact(LastName='ALEdev test acc', HomePhone=cli);
 //       insert c;
        String result = AccountRetrieval.getAccounts(cli, '', '()');
        System.debug('result: ' + result);
        List<List<SObject>> sl = (List<List<SObject>>) JSON.deserialize(result, List<List<SObject>>.class);
        System.debug('list size: ' + sl.size());
        System.debug('Contact list size: ' + sl.get(1).size());
        System.assertEquals(2, sl.size());
        
    }
    /*Code merge from outmerge sandbox  */
    @isTest
    static void testNewAccountInsulation() {
        String cli = '5551231234';
        Contact c = new Contact(LastName='ALEdev test acc', HomePhone=cli,MailingStreet = 'Test1',Phone = '1234567890', MailingCity = 'testcity1', MailingState='testState1', MailingPostalCode='test1postal');
        insert c;
        String result = AccountRetrieval.getAccountsInsulation(cli, '', '()');
        System.debug('result: ' + result);
        List<List<SObject>> sl = (List<List<SObject>>) JSON.deserialize(result, List<List<SObject>>.class);
        System.debug('list size: ' + sl.size());
        System.debug('Contact list size: ' + sl.get(1).size());
        System.assertEquals(2, sl.size());
        
    }
}