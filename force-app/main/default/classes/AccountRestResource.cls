@restResource(UrlMapping='/Account/')
global class AccountRestResource {
    @httpget
    global static AccountWrapper returnAccount(){
        //List<Account> accList = [SELECT Id ,Name , industry ,annualrevenue FROm Account WHERE annualrevenue!=null Order by annualrevenue desc Limit 10  ];
        Map<string,String> aaNameMap = RestContext.request.Params;
        String Id = aaNameMap.get('Id');
        List<Account> accList = [SELECT Id ,Name , industry ,annualrevenue FROm Account WHERE Id =:Id];
        Set<Id> accid = new Set<Id>();
        for(Account acc :accList){
           accid.add(acc.Id);
        }
        List<contact>conList = [SELECT Id ,Name FROM Contact WHERE AccountId In :accid];
       List<Case>caseList = [SELECT Id  FROM Case WHERE AccountId In :accid];

         AccountWrapper wrapper = new AccountWrapper();
        wrapper.acclist= accList;
        wrapper.ConList= conList;
        if(!caseList.isEmpty())
           wrapper.caseList= caseList; 
        return wrapper;
    }
    //@httpPost
    global static String CreateAccount( String accName){
        Account acc= new Account();
        acc.Name = accName;
        try{
            Insert acc;
                return 'Account Created Successfully';
        } catch(Exception ex){
            return ex.getMessage();
            
        }
        
    }
    @httppost
    global static String createAccountandContact(AccountcontactInformation information){
        Account accrecord = information.accInformn;
        //Contact conrecord = information.coninformn;
        try{
            insert accrecord;
            //Insert conrecord;
            return 'Account contact Created Successfully';
        } Catch(Exception ex){
            return ex.getMessage();
        }
        
    }
    global class AccountcontactInformation{
        global Account accInformn {get;set;}
        //global Contact coninformn{get;set;}
    }    
    global class AccountWrapper{
        global List<Account> acclist;
         global List<Contact> ConList; 
        global List<Case> caseList;
        
    }

}