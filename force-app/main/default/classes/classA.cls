public abstract class classA {
public integer rollno;
    public string name;
    public void display(integer rollno,string name){
        this.rollno = rollno;
        this.name = name;
     } 
    public void show(){
      system.debug(rollno ) ; 
        system.debug(name);
    }
    public abstract void Fees();
}