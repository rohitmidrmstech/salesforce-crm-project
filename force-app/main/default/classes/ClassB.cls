public class ClassB extends classA {
    public integer nooffstudent;
    public decimal fees= 100;
    public decimal discount = 10000;
    public void detail(integer nooffstudent ){
        this.nooffstudent = nooffstudent;
    }
    public override void Fees(){
        decimal totalfee = fees * nooffstudent;
        decimal reminingfees = totalfee - discount;
        system.debug('nooffstudent ====' +nooffstudent);
        
        system.debug('totalfee======' + totalfee ); 
        system.debug('reminingfees ===' + reminingfees);
        
    }
}