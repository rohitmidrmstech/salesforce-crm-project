public class abc {
    public static void sysprintoutln(){
        string firstname ='mangesh';
        string lastname = 'shinde';
        double salary = 12.89;
        Boolean b = false;
       long no = 23456725363L;            
  		system.debug(firstname+'\n'+lastname+'\n'+salary+'\n'+b+'\n'+no);          
        
    }    
    public static void main(){
      date myDate = date.newInstance(1983, 7, 15);
		date newDate = myDate.addYears(2);
		date expectedDate = date.newInstance(1985, 7, 15);
		system.assertEquals(expectedDate, newDate);  
  
        
    }   
}