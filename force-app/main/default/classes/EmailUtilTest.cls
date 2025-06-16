@isTest
public class EmailUtilTest {
	private static String subject = 'Test Email';
	private static String body = 'Test Email';
	private static String toAddress = 'test@myemaildomain.com';

	@isTest
	static void sendMessageTest() {

		// Call the sendMessage method
		Test.startTest();
		EmailUtil.sendMessage(new List<String>{ toAddress }, subject, body);
		Test.stopTest();

		// Verify the email was sent
		List<EmailMessage> sentEmails = [SELECT Subject, TextBody FROM EmailMessage];
		System.assertEquals(1, sentEmails.size());
		System.assertEquals(subject, sentEmails[0].Subject);
		System.assertEquals(body, sentEmails[0].TextBody);
	}
}