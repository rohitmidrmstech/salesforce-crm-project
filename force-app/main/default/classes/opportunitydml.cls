public class opportunitydml{
    
    Public account createAccount(String accName, string accRating, string accIndustry, Decimal accAnnual, string accType, string accSLA){
        Account ObjAcc = new Account();
        ObjAcc.Name = accName;
        ObjAcc.Rating = accRating;
        ObjAcc.Industry = accIndustry;
        ObjAcc.AnnualRevenue = accAnnual;
        ObjAcc.Type = accType;
        ObjAcc.SLA__c= accSLA;
        
        insert ObjAcc;
        return ObjAcc;
    }
    Public contact createContact(Account ObjAcc){
        Contact ObjCon = new Contact();
        
        ObjCon.FirstName= ObjAcc.Name;
        ObjCon.LastName='Contact';
        ObjCon.Title='Test Title1';
        ObjCon.Phone= '9890098523';
        ObjCon.Email = 'test@gmail.com';
        objcon.accountid=objacc.id;
        insert ObjCon;
        return Objcon;
    }
    
    Public Opportunity CreateOpportunity(Account ObjAcc,contact objcon){
        Opportunity ObjOpp = New Opportunity();
        
        ObjOpp.Name = 'Kalyani1';
        ObjOpp.CloseDate = System.today();
        ObjOpp.StageName = 'Value Proposition';
        ObjOpp.LeadSource = 'Phone Inquiry';
        ObjOpp.IsPrivate = True;
        ObjOpp.AccountID=ObjAcc.id;
        objopp.ContactId = objcon.Id;
        insert ObjOpp;
        return objopp;
    }    
    
    Public void createCase(Account ObjAcc,contact objcon){
        Case ObjCase = new Case();
        
        ObjCase.Status = 'Working';
        ObjCase.Origin = 'Email';
        ObjCase.AccountID=ObjAcc.id;
        objCase.ContactId = Objcon.Id;
        
        insert ObjCase;
        
    }
    
    
    
    
    
    
}