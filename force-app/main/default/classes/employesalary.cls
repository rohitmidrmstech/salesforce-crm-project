public class employesalary {
    public string name;
    public string eid;
    public decimal gst;
    public decimal salary;
    
    public void detailofemployee(){
        
        system.debug('name of employee is:'+ name);
        system.debug('eid is :'+ eid);
        system.debug('salary is :'+ salary);
        system.debug ('gst is:'+ gst);
    }       
    public decimal calculation(){
        detailofemployee();
        decimal reducesal = (salary - gst/100 * salary ); 
        return reducesal;
    }
    public void positiononsalary (decimal ts ){
        
        system.debug('salary of employee is :' + ts);
        
        if (ts > =150000){
            system.debug('upper class category people:');
        }
        else {
            if (ts > = 60000 ){
                system.debug('middle class it peopel');
            }
            else if (ts > = 25000){
                system.debug('lower middle class:');
            }
            else {
                system.debug('this in non It people working in low budget ');
            }
        }
    }
}