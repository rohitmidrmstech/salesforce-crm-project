// ==================================================================================
//   Object: PopContactController
//  Company: Certainteed Siding
//   Author: Mohan Kumar (Threshold Inc)
// Comments: Popup screen that list all the contacts matching the phone parameter provided
//           by the CTI connector. Allow the user to add/edit the Case for the selected 
//           contact.
// ==================================================================================
//  Changes: 2013-05-16 Initial version.
// ==================================================================================

public with sharing class PopContactController {
    public List<Contact> contList {get;set;}
    private Boolean includeFormats = false;
    private String phoneFormat1 = '';
    private String phoneFormat2 = '';
    private String phoneFormat3 = '';
    private Boolean hasSpecialChar = false;
    private String phoneFormat4 = '';
    
    public PopContactController() {
        contList = new List<Contact>();
    }
    
    public Pagereference autoRun() {
        Pagereference pr;
        String phoneParam = Apexpages.currentPage().getParameters().get('ANI');
        if(phoneParam != null && phoneParam != '') {
            //fetch all the contacts that contains the phone parameter value under any of the phone fields
            formatPhoneParam(phoneParam);
            String queryCondition = '';
            if(includeFormats) {
                queryCondition += ' AssistantPhone like \'' + phoneParam + '%\' OR AssistantPhone like \'' + phoneFormat1 + '%\' OR AssistantPhone like \'' + phoneFormat2 + '%\' OR AssistantPhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' MobilePhone like \'' + phoneParam + '%\' OR MobilePhone like \'' + phoneFormat1 + '%\' OR MobilePhone like \'' + phoneFormat2 + '%\' OR MobilePhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' HomePhone like \'' + phoneParam + '%\' OR HomePhone like \'' + phoneFormat1 + '%\' OR HomePhone like \'' + phoneFormat2 + '%\' OR HomePhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' OtherPhone like \'' + phoneParam + '%\' OR OtherPhone like \'' + phoneFormat1 + '%\' OR OtherPhone like \'' + phoneFormat2 + '%\' OR OtherPhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' Phone like \'' + phoneParam + '%\' OR Phone like \'' + phoneFormat1 + '%\' OR Phone like \'' + phoneFormat2 + '%\' OR Phone like \'' + phoneFormat3 + '%\''; 
                
                //this additional check includes the number without any symbol.
                //Eg: if the XXX-XXX-XXXX is passed thru query parameter then we include the XXXXXXXXXX value as the filter.
                if(hasSpecialChar) {
                    queryCondition += ' OR AssistantPhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' MobilePhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' HomePhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' OtherPhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' Phone like \'' + phoneFormat4 + '%\''; 
                    
                }
            } else {
                queryCondition += ' AssistantPhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' MobilePhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' HomePhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' OtherPhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' Phone like \'' + phoneParam + '%\''; 
            }
            String query = 'Select Id, Name, AccountId, Account.Name, Title, MailingState, MailingCountry, MailingCity, ' + 
                                        'AssistantPhone, HomePhone, MobilePhone, Fax, OtherPhone, Phone ' +
                                        ' From Contact Where ' + queryCondition;
            contList = Database.query(query);
            if(contList.size() > 1){
                //Show the page with the list of contacts
            } else if(contList.size() == 1){
                //Redirect to the Contact view page
                pr = new PageReference('/' + contList.get(0).Id);
            } else {
                //Redirect to the Contact tab
                pr = new PageReference('/003/o');
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry! Please provide the query parameter.'));
        }
        if(pr != null) pr.setRedirect(true);
        return pr;
    }
    
    private void formatPhoneParam(String phoneParam) {
        String temp = phoneParam;
        temp = removeSpecialCharacter(temp, '-');
        temp = removeSpecialCharacter(temp, ' ');
        temp = removeSpecialCharacter(temp, '(');
        temp = removeSpecialCharacter(temp, ')');
        if(temp.length() == 10) {
            phoneFormat1 = '(' + temp.subString(0,3) + ') ' + temp.subString(3,6) + '-' + temp.subString(6);
            phoneFormat2 = temp.subString(0,3) + '-' + temp.subString(3,6) + '-' + temp.subString(6);
            phoneFormat3 = temp.subString(0,3) + ' ' + temp.subString(3,6) + '-' + temp.subString(6);
            if(hasSpecialChar) phoneFormat4 = temp;
            includeFormats = true;
        }
    }
    
    private String removeSpecialCharacter(String temp, String symbol) {
        if(temp != null) {
            while(temp.contains(symbol)) {
                temp = temp.replace(symbol, '');
                if(!hasSpecialChar) hasSpecialChar = true;
            }
        }
        return temp;
    }
}