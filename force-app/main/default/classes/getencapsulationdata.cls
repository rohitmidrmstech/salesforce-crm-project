public class getencapsulationdata {
    public static void getdata(string name ,string last ,string email){
        encapsulationEMP ecap = new encapsulationEMP();
       ecap.setlastname(last);
        ecap.setemail(email);
        ecap.setname(name);
        
    string lname=    ecap.getlastname();
        string emails = ecap.getemail();
        string names = ecap.getname();
        system.debug( lname + ' ' + emails+' ' + names);
        
    }
}