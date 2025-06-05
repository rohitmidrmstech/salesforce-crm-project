public with sharing class VOCEditOrverrideController {
    public VOC_Data_Entry__c voc{get;set;}
    public String objAPIName{get;set;}
    public String recordID{get;set;}
    
    public VOCEditOrverrideController (Apexpages.standardController sc) {
        this.voc = (VOC_Data_Entry__c)sc.getRecord();
        if(Apexpages.currentPage().getParameters().containsKey('retURL')){
            recordID = Apexpages.currentPage().getParameters().get('retURL');
            if(recordID!=null && recordID!=''){
                if(recordID.contains('/')){
                    recordID = recordID.replace('/','');
                }
                if(recordID.length()>=15 && recordID.length()<=18){
                    Schema.SOBjectType sT =  ((Id)recordID).getsObjectType();
                    objAPIName = st.getDescribe().getLocalName();
                }
            }
        }
        
    }
    
    public Pagereference init(){
        if(objAPIName!=null && objAPIName!='' && objAPIName=='ProDialogue_Input__c'){
            return new PageReference('/apex/ProDialogueInputForm?id='+recordID);
        }else{
            String newURL = '/'+voc.Id+'/e?';
            if(Apexpages.currentPage().getParameters().containsKey('retURL')){
                newURL += '&retURL='+recordID;
            }
            newURL += '&nooverride=1';
            return new PageReference(newURL);
        }
    }
}