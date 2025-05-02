public class calculation {
    public string name ;
    public integer rollno ;
    
    public  calculation(string name ,integer rollno){
                                                      
        this.name= name;
        this.rollno = rollno;
         
    }
    public void showd(){
        system.debug('company name is:'+ name);
        system.debug('roll no is:'+ rollno);
        
        
        
    }
}