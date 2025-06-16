/**
 * @description Helper class for Payment Line trigger 
*/
public class WOD_PaymentLineTriggerHelperCLS{
    /**
	 * @description to handel payment line before events
	 * @param listPayment list of Payment Line Records
	*/
    public static void handlebeforeEvent(List<WOD_Payment_Line__c> listPayment){
        Id profileId = userinfo.getProfileId();
        String userProfile;
        userProfile = [select Name from profile where id = :profileId].Name;
        Map<Id,WOD_Payment_Line__c> paymentLineMap = new Map<Id,WOD_Payment_Line__c>();
        for(WOD_Payment_Line__c eachPayment : listPayment){
            paymentLineMap.put(eachPayment.Id,eachPayment);
        }
        for(WOD_Payment_Line__c pl: [Select Id,Payment__r.Void_WOD_Payment__c,Payment__r.Released_To_SAP__c from WOD_Payment_Line__c where id=:paymentLineMap.KeySet()]){
            if(pl.Payment__r.Void_WOD_Payment__c  && (userProfile != 'Integration User' && userProfile != 'System Administrator')){
                paymentLineMap.get(pl.Id).addError('Payment Line is not editable/deleteable for Void Payment.');
            }
            if(pl.Payment__r.Released_To_SAP__c && (userProfile != 'Integration User' && userProfile != 'System Administrator')){
                paymentLineMap.get(pl.Id).addError('Payment Line is not editable/deleteable once the Payment is release to SAP.');
            }
        }           
    }
}