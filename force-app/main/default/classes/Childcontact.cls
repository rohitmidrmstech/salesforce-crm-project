public class Childcontact extends ParentAccount {
    public list<contact> getcontacts () {
    list<contact> lstcon = [select id, name ,MailingCountry	 FROM contact];    
        return lstcon; 
    }
        public override list<Account> getaccounts(){
         set<string> setcountries = new set<string>() ;
            setcountries.add('usa');
            setcountries.add('japan');
            list<Account> lstacc =[select id, name ,BillingCountry FROM Account WHERE BillingCountry in: setcountries  ];
              return lstacc;
}  
}