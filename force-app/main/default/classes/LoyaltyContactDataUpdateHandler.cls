public class LoyaltyContactDataUpdateHandler {
    
    public static void updatePhone(List<Contact> contacts){
        
        //system.debug('contacts size => ' + contacts.size());
        
        if(contacts.size() > 0){
            for(Contact c: contacts){
                if(!String.isBlank(c.Phone)){
                    //system.debug('lstConatcts =>' + contacts);
                    //system.debug('Phone =>' + c.phone);
                    string newPhone = c.phone.replaceAll('[^0-9.]', '');  
                    //system.debug('newPhone => ' + newPhone);
                    //system.debug('Length => '  newPhone.length());+
                    if(newPhone.length() == 10){
                        c.Phone_Bank_Report__c = newPhone;
                    }
                    else{
                        c.Phone_Bank_Report__c = '';
                    }
                } 
                else{
                c.Phone_Bank_Report__c = '';
            }  
            }  
        }
  
    }
}