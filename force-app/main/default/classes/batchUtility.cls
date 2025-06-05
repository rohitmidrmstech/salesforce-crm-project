/********************************************************************
Utility class used in batch apex jobs
*******************************************************************/

public class batchUtility
{
    public static void sendExceptionEmailAllAdmin(string subject, string body)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<string> toAddresses = new List<string>();
        for(User u : [Select Id, Email From User Where IsActive = true AND Profile.Name = 'System Administrator'])
        {
            toAddresses.add(u.Email); 
        }
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        if(!Test.isRunningTest())
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void sendMissingWTUEmail(string emailTo)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<string> toAddresses = new List<string>();
        toAddresses.add(emailTo); 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Reminder: Missing WTU'  );
        mail.setPlainTextBody('This is reminder of missing WTU for this weekend. ' );
        if(!Test.isRunningTest())
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}