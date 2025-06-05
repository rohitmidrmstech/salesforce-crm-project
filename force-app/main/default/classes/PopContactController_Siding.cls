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

public with sharing class PopContactController_Siding {
    public List<PopContactWrapper> contList {get;set;}
    public List<PopContactWrapper> caseList {get;set;}
    public Boolean showCases {get;set;}
    
    private Boolean includeFormats = false;
    private String phoneFormat1 = '';
    private String phoneFormat2 = '';
    private String phoneFormat3 = '';
    private Boolean hasSpecialChar = false;
    private String phoneFormat4 = '';
    private Integer currentSelectedContactIndex;    //contains the contact row index that the user has select for the list.
    
    public PopContactController_Siding() {
        contList = new List<PopContactWrapper>();
        caseList = new List<PopContactWrapper>();
        showCases = false;
    }
    
    public Pagereference autoRun() {
        Pagereference pr;
        String phoneParam = Apexpages.currentPage().getParameters().get('ANI');
        System.debug('ANI phoneParam: '+phoneParam);
        if(phoneParam != null && phoneParam != '') {
            //fetch all the contacts that contains the phone parameter value under any of the phone fields
            formatPhoneParam(phoneParam);
            String queryCondition = '';
            if(includeFormats) {
                queryCondition += ' AssistantPhone like \'' + phoneParam + '%\' OR AssistantPhone like \'' + phoneFormat1 + '%\' OR AssistantPhone like \'' + phoneFormat2 + '%\' OR AssistantPhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' MobilePhone like \'' + phoneParam + '%\' OR MobilePhone like \'' + phoneFormat1 + '%\' OR MobilePhone like \'' + phoneFormat2 + '%\' OR MobilePhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' HomePhone like \'' + phoneParam + '%\' OR HomePhone like \'' + phoneFormat1 + '%\' OR HomePhone like \'' + phoneFormat2 + '%\' OR HomePhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' OtherPhone like \'' + phoneParam + '%\' OR OtherPhone like \'' + phoneFormat1 + '%\' OR OtherPhone like \'' + phoneFormat2 + '%\' OR OtherPhone like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' Phone like \'' + phoneParam + '%\' OR Phone like \'' + phoneFormat1 + '%\' OR Phone like \'' + phoneFormat2 + '%\' OR Phone like \'' + phoneFormat3 + '%\' OR';
                //queryCondition += ' Home_Phone__c like \'' + phoneParam + '%\' OR Home_Phone__c like \'' + phoneFormat1 + '%\' OR Home_Phone__c like \'' + phoneFormat2 + '%\' OR Home_Phone__c like \'' + phoneFormat3 + '%\' OR';
                queryCondition += ' Mobile__c like \'' + phoneParam + '%\' OR Mobile__c like \'' + phoneFormat1 + '%\' OR Mobile__c like \'' + phoneFormat2 + '%\' OR Mobile__c like \'' + phoneFormat3 + '%\'';
                //queryCondition += ' Other_Phone__c like \'' + phoneParam + '%\' OR Other_Phone__c like \'' + phoneFormat1 + '%\' OR Other_Phone__c like \'' + phoneFormat2 + '%\' OR Other_Phone__c like \'' + phoneFormat3 + '%\'';
                //if fax field uncommented then include OR condition in the above line
                //queryCondition += ' Fax like \'' + phoneParam + '%\' OR Fax like \'' + phoneFormat1 + '%\' OR Fax like \'' + phoneFormat2 + '%\' OR Fax like \'' + phoneFormat3 + '%\' OR';
                //queryCondition += ' Fax__c like \'' + phoneParam + '%\' OR Fax__c like \'' + phoneFormat1 + '%\' OR Fax__c like \'' + phoneFormat2 + '%\' OR Fax__c like \'' + phoneFormat3 + '%\' ';
                
                //this additional check includes the number without any symbol.
                //Eg: if the XXX-XXX-XXXX is passed thru query parameter then we include the XXXXXXXXXX value as the filter.
                if(hasSpecialChar) {
                    queryCondition += ' OR AssistantPhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' MobilePhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' HomePhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' OtherPhone like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' Phone like \'' + phoneFormat4 + '%\' OR ';
                    //queryCondition += ' Home_Phone__c like \'' + phoneFormat4 + '%\' OR ';
                    queryCondition += ' Mobile__c like \'' + phoneFormat4 + '%\'';
                    //queryCondition += ' Other_Phone__c like \'' + phoneFormat4 + '%\'';
                    //if fax field uncommented then include OR condition in the above line
                    //queryCondition += ' Fax like \'' + phoneFormat4 + '%\' OR ';
                    //queryCondition += ' Fax__c like \'' + phoneFormat4 + '%\'';
                    
                }
            } else {
                queryCondition += ' AssistantPhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' MobilePhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' HomePhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' OtherPhone like \'' + phoneParam + '%\' OR';
                queryCondition += ' Phone like \'' + phoneParam + '%\' OR';
                //queryCondition += ' Home_Phone__c like \'' + phoneParam + '%\' OR';
                queryCondition += ' Mobile__c like \'' + phoneParam + '%\'';
                //queryCondition += ' Other_Phone__c like \'' + phoneParam + '%\'';
                //if fax field uncommented then include OR condition in the above line
                //queryCondition += ' Fax like \'' + phoneParam + '%\' OR';
                //queryCondition += ' Fax__c like \'' + phoneParam + '%\'';
            }
           
            String query = 'Select Id, Name, AccountId, Account.Name, Title, MailingState, MailingCountry, MailingCity, Gender__c, ' + 
                                        'AssistantPhone, HomePhone, MobilePhone,Fax,OtherPhone, Phone,Mobile__c' +
                                        ' From Contact Where ' + queryCondition;
           
            System.debug('query: '+query);
            List<Contact> contacts = Database.query(query);
            /*
            List<Contact> contacts = [FIND :phoneParam IN PHONE FIELDS RETURNING Contact(Id, Name, AccountId, Account.Name, Title, MailingState, 
                                        MailingCountry, MailingCity, Gender__c, AssistantPhone, HomePhone, MobilePhone, Fax, Fax__c, 
                                        OtherPhone, Phone, Home_Phone__c, Mobile__c, Other_Phone__c)][0];
            */
            //if only one matching contact is found then default the contact as selected and search for the open cases and list the cases under separate section.
            //if NO contact is found then redirect the user to standard contact page
            //if only one open case record is found then redirect the user to standard case edit page 
            if(contacts.size() > 0)  {
                Boolean hasOnlyOne = false;
                if(contacts.size() == 1) {
                    hasOnlyOne = true;
                    currentSelectedContactIndex = 0;
                }
                Integer index = 0;
                for(Contact c : contacts) {
                    PopContactWrapper pcw = new PopContactWrapper();
                    if(hasOnlyOne) pcw.isSelected = true;
                    pcw.cont = c;
                    pcw.rIndex = index++;
                    contList.add(pcw);
                }
                if(hasOnlyOne) {
                    System.currentPageReference().getParameters().put('rowIndex', '0');
                    pr = fetchOpenCases();
                }
            } else  {
                //String url = '/003/e?ent=Contact' + '&con10=' + phoneParam;
                String url = '/setup/ui/recordtypeselect.jsp?ent=Contact&save_new_url=%2F003%2Fe%3F&ent=Contact&con10=' + phoneParam;
                pr = new Pagereference(url);
                return pr;
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
    
    //retrieves all the open cases for the selected contact
    public Pagereference fetchOpenCases() {
        Pagereference pr;
        showCases = false;
        caseList.clear();
        currentSelectedContactIndex = null;
        String param = System.currentPageReference().getParameters().get('rowIndex');
        System.debug('param: '+param);
        if(param != null && param != '') {
            Integer rowIndex = Integer.valueOf(param);
            currentSelectedContactIndex = rowIndex;
            PopContactWrapper cw = contList.get(rowIndex);
            if(cw.isSelected) {
                showCases = true;
                List<Case> cases = [Select c.Subject, c.Status, c.Id, c.CreatedDate, c.ContactId, c.ClosedDate, c.CaseNumber, c.IsClosed 
                                        From Case c Where ContactId =: cw.cont.Id AND IsClosed = false];
                Boolean hasOnlyOne = false;
                if(cases.size() == 1) hasOnlyOne = true;
                Integer index = 0;
                for(Case c : cases) {
                    PopContactWrapper pcw = new PopContactWrapper();
                    if(hasOnlyOne) pcw.isSelected = true;
                    pcw.cse = c;
                    pcw.rIndex = index++;
                    caseList.add(pcw);
                }
                //if only one case is found then redirect the user to case edit page.
                if(hasOnlyOne) {
                    System.currentPageReference().getParameters().put('rowIndex', '0');
                    pr = editCase();
                }
            }
        }
        if(pr != null) pr.setRedirect(true);
        return pr;
    }
    
    //redirect the user to standard case page if the user has selected a contact and auto populate the contact and account field for a new case
    public Pagereference newCase() {
        Pagereference pr;
        try {
            if(currentSelectedContactIndex != null) {
                PopContactWrapper pcw = contList.get(currentSelectedContactIndex);
                if(pcw.isSelected) {
                    //pr = new Pagereference('/500/e?ent=Case&cas3_lkid=' + pcw.cont.Id + '&cas4_lkid=' + pcw.cont.AccountId);
                    pr = new Pagereference('/setup/ui/recordtypeselect.jsp?ent=Case&save_new_url=%2F500%2Fe%3F&cas3_lkid=' + pcw.cont.Id + '&cas4_lkid=' + pcw.cont.AccountId);
                    pr.setRedirect(true);
                }
            }
        } catch(Exception ex) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }
        return pr;
    }
    
    //when a user select a case record redirect the user to standard case edit page
    public Pagereference editCase() {
        Pagereference pr;
        String param = System.currentPageReference().getParameters().get('rowIndex');
        if(param != null && param != '') {
            Integer rowIndex = Integer.valueOf(param);
            PopContactWrapper cw = caseList.get(rowIndex);
            if(cw.isSelected) {
                pr = new Pagereference('/' + cw.cse.Id + '/e?retURL=/' + cw.cse.Id);
                pr.setRedirect(true);
            }
        }
        return pr;
    }
    
    public class PopContactWrapper {
        public Integer rIndex {get;set;}
        public Boolean isSelected {get;set;}
        public Contact cont {get;set;}
        public Case cse {get;set;}
        
        public PopContactWrapper() {
            isSelected = false;
            cont = new Contact();
            cse = new Case();
        }
    }
}