public class vehicle2 {
    public void printout(){
        vehicle obj1 = new vehicle();
        obj1.firstname='rohit';
        obj1.lastname ='chormalle';
        obj1.rollno = 100;
        obj1.totalmarks =1000;
        obj1.obtmarks = 700;
        
       decimal perc = obj1.percentagecal();
        
        obj1.showdetails(perc);
    }        
    }