public class sendEmail {
    public static void SystemAdminEmail(List<Account> lstacc){
        user userobj =[SELECT Id ,Name ,email,Profile.Name FROM user WHERE Profile.Name ='System Adminstrator'];
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
        for(Account acc : lstacc){
            if(userobj.email != null) {
                messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
                mail.setSenderDisplayName('Salesforce');
                mail.toAddresses = new String[]{userobj.email};
                    mail.setSubject('New Account was Created.');
                String body = 'Dear System Administrator, <br/>';
                body += 'An account has been created and name is '+acc.Name+'.';
                mail.setHtmlBody(body);
                //Adding each single mail to be sent to the list of mails
                listEmail.add(mail);
            }
        }
    }
}