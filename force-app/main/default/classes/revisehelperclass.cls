public class revisehelperclass {
    public void getdetails(){
        reviseclass bn = new reviseclass('rohut','chormalle');
        bn.showdeta();
        reviseclass cv = new reviseclass(20,22);
        cv.sum();
        cv.sum(20,20);
        reviseclass obj =reviseclass.getdata();
        system.debug( 'name is ==' +obj.name );
        system.debug('lname is ===++' + obj.lname);  
        
    }
    public void insertrelatedrecord(){
        reviseclass obj1 = new reviseclass();
        Account acc = obj1.insertAccount('balaji','india');
        insert acc;
        reviseclass obj2 = new reviseclass();
        obj2.Accountrelate(4);
        
        
        
        
        
        
        
        
        
        
        
    }
}