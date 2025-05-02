public class d1 {
 public string myname;
public    string lastname;
public integer rollno;
    
     public decimal tm;
   public decimal ob ;
    public void details(){
        system.debug(myname);
        system.debug(lastname);
        system.debug(rollno);
}
    public void calculation(){
        Decimal percentage = (ob*100)/tm;
        system.debug('percentage is:'+percentage);
        details();
    }       
}