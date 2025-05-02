public class bookHandler {
    public static void maparchieveBook(List<Book__c> lstbook){
      map<string, string> mapoffBook = new map<string,string>() ; 
      List<Arc__c> lstarchieveBook = new List<Arc__c>() ;
        // mapping of book to book archieved 
        for(book_setting__mdt record : book_setting__mdt.getAll().values()){
           mapoffBook.put(record.Source_field__c , record.Target_field__c) ;
        }
        for(Book__c book : lstbook){
         // creating target object 
           Arc__c arcbook = new Arc__c();  
            for(string  sourcefieldapi :mapoffBook.keyset()){
                string targetfieldapi = mapoffBook.get(sourcefieldapi);
                arcbook.put(targetfieldapi , book.get(sourcefieldapi));
                
            } 
            lstarchieveBook.add(arcbook);
        }
        if(!lstarchieveBook.isempty()){
           insert lstarchieveBook;
        }
    }
    public static void discountOnBook(List<Book__c> LstBooks){
        for(Book__c bk : LstBooks){
            bk.Price__c *= 0.90;
        }
        
        
        
        
    }
}