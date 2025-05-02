public class firstyear {
    public static void main() { 
    date myDate = date.newInstance(1983, 7, 15);
		date newDate = myDate.addYears(5);
		date expectedDate = date.newInstance(1988, 7, 15);
        datetime mynewdate = datetime.newinstance(2000,5,8,8,9,12);
        
		system.assertEquals(expectedDate, newDate); 
        
        
        
        
    system.debug(mydate+'\n'+newdate+'\n'+expectedDate+'\n'+mynewdate);
    
}
}