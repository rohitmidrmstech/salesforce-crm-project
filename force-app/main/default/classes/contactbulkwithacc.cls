public class contactbulkwithacc {
    public Account insertrecord(){
       Account acc = new Account() ;
        acc.Name = 'jaykumar';
        insert acc;
        return acc;
    }
    
    public void conbulk(Account acc,integer nooffrecord){
        list<contact> lstacc = new list<contact>();
        for(integer i=0 ; i<= nooffrecord ; i++){
           contact con = new contact() ;
            con.FirstName = getcontact(i);
            con.LastName = 'patil';
            con.AccountId = acc.Id;
            lstacc.add(con);
        }
       insert lstacc;              
    }
    public string getcontact(integer index){
        list<string> lststr = new list<string>();
        lststr.add('jay 1');
        lststr.add('jay2');
        lststr.add('jay3');
        lststr.add('jay4');
        string name= lststr[index];
        return name;
    }
    
    
}