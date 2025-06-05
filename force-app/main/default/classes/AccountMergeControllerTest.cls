@isTest
public class AccountMergeControllerTest 
{
	@testSetup
	public static void init(){
		Account acct = new Account(Name='Test Merge');
		Account acct2 = new Account(Name='Test Merge');
		Account acct3 = new Account(Name='Test Merge');
		insert new Account[]{acct, acct2, acct3};
	}
	@isTest 
	public static void testMerge2()
	{
		List<Account> accountList = [select id from Account where name='Test Merge'];

		AccountMergeController testClass = new AccountMergeController();
		testClass.inputAccountIds = accountList.get(0).Id+','+accountList.get(1).Id;

		testClass.processAccountIds();

		accountList = [select id from Account where name='Test Merge'];
		System.assertEquals(2, accountList.size());
	}
	@isTest 
	public static void testMerge3()
	{
		List<Account> accountList = [select id from Account where name='Test Merge'];

		AccountMergeController testClass = new AccountMergeController();
		testClass.inputAccountIds = accountList.get(0).Id+','+accountList.get(1).Id+','+accountList.get(2).Id;

		testClass.processAccountIds();

		accountList = [select id from Account where name='Test Merge'];
		System.assertEquals(1, accountList.size());
	}
}