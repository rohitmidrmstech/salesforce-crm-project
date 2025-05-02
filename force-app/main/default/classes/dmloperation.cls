public class dmloperation {
        public void accountrecord(integer nooffrecord){
            list<Account> lstacc = new list<Account>();
    list<contact> lstcon = new list<contact>() ;       
            integer start = 0;
            integer i;
            for(i = start ; i<nooffrecord ; i++){
                Account acc = new Account();
                acc.Name = 'itspayal';
                acc.AccountNumber = '34343';
                lstacc.add(acc);
            }
                        insert lstacc;
            for(Account acc : lstacc){
                contact objcon = new contact();
                    objcon.LastName = 'bainwad';
                objcon.AccountId = acc.Id;
            
                lstcon.add(objcon);
 
        }
        }
    }
            /* public contact contactrecord(Account name, string lastname,string phone){
    contact conc1 = new contact();
    conc1.Lastname = lastname;
    conc1.Phone = phone;
    conc1.AccountId = name.id;
    insert conc1;
    return conc1;
    }*/