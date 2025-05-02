public class handin {
    public void showemployeedetai(decimal gst,decimal salary){ 
        employesalary obj1 = new employesalary();
        obj1.name = 'rohit';
        obj1.eid = 'kshdfkjsh';
        obj1.gst = gst;
        obj1.salary = salary; 
        decimal totalsalary = obj1.calculation();
        obj1.positiononsalary(totalsalary);
        system.debug('result is:' + totalsalary);
    }
    
}