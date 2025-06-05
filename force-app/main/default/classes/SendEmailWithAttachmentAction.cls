/****************************************************************************************
* @Author       Dru Luce-Edwards
* @Date         December 13, 2016
* @Description  Used by process builder, sends a specified email template to specified addresses with the specified PDF Email attached.
*****************************************************************************************/
public class SendEmailWithAttachmentAction{
    /****************************************************************************************
    * @Author       Dru Luce-Edwards
    * @Date         December 13, 2016
    * @Description  Used by process builder, sends a specified email template to specified addresses with the specified PDF Email attached.
    *****************************************************************************************/
    @InvocableMethod(label='Send Email With A VF PDF Attachment' description='Sends a specified email template with a specified VF PDF attachment to specified addresses.')
    public static void sendEmailWithVFPDFAttachmentAction(List<EmailSettings> lstES){
        EmailSettings es = lstES.get(0);
        //Get the template id
        EmailTemplate template = null;
        for(EmailTemplate temp : [select id, name from EmailTemplate where developername = :es.TemplateAPIName limit 1]){
            template = temp;               
        }
        User replyToUser = null;
        for(User u : [SELECT Id,Name,Email FROM User WHERE Id = :es.ReplyToId limit 1]){
            replyToUser = u;
        }
        OrgWideEmailAddress owe = null;
        for(OrgWideEmailAddress o : [SELECT ID FROM OrgWideEmailAddress WHERE Address = 'ctcquotemailbox@saint-gobain.com' LIMIT 1]){
            owe = o;
        }
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTargetObjectId(es.TargetObjectId); 
        msg.setWhatId(es.WhatId);
        msg.setTemplateId(template.Id);
        msg.setToAddresses(es.ToAddresses);
        msg.setCcAddresses(es.CCAddresses);
        msg.setSaveAsActivity(false);
        msg.setBccAddresses(es.BCCAddresses);
        msg.setUseSignature(false);
        if(owe != null){
            msg.setOrgWideEmailAddressId(owe.Id);
        } else if(replyToUser != null){
            msg.setSenderDisplayName(replyToUser.Name);
        }
        if(replyToUser != null){
            msg.setReplyTo(replyToUser.Email);
        }
        PageReference pdf =  new Pagereference(es.PDFAttachmentURL);
        // Code modified by Sneha for S-504993 Start--> getContent method cannot be covered in testclass as testmethod does not support it.
        Blob b;
        
         try{
        if(!test.isRunningTest()){
            b = pdf.getContent();
          }else{
            b = blob.valueof('TEST');
          }
        }
        catch(Exception e)
        {
        }
        
        // Code modified by Sneha for S-504993 end
         
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(es.FileName);
        efa.setBody(b);
        msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        if(!Test.isRunningTest()) 
        	Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
    }
    
    public class EmailSettings{
        @InvocableVariable(label='To Addresses' required=true)
        public List<String> ToAddresses;
        
        @InvocableVariable(label='CC Addresses')
        public List<String> CCAddresses;
        
        @InvocableVariable(label='BCC Addresses')
        public List<String> BCCAddresses;
        
        @InvocableVariable(label='Email Template API Name' required=true)
        public String TemplateAPIName;
        
        @InvocableVariable(label='Target Object Id' description='Id of the recipient object. (Contact, User, or Lead Id)' required=true)
        public String TargetObjectId;
        
        @InvocableVariable(label='What Id' description='Id of the main object. (Quote Id for example)' required=true)
        public String WhatId;
        
        @InvocableVariable(label='Reply To User Id' description='Id of the reply to user.' required=true)
        public String ReplyToId;
        
        @InvocableVariable(label='PDF Attachment URL' required=true)
        public String PDFAttachmentURL;
        
        @InvocableVariable(label='Attachment File Name' required=true)
        public String FileName;
    }
}