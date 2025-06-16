public class RebateClaimItemUtility {

  public static Set<string> acccategoryset;
  public static Set<string> concategoryset;
  public static set<string> contactLevelCategorySet;
    
    public static Set<string> getAcccategoryset(){
        if(acccategoryset == null){
            acccategoryset = new set<string>();
        }        
        return acccategoryset;
    }
    public static Set<string> getContactLevelCategorySet(){
        if(contactLevelCategorySet == null){
            contactLevelCategorySet = new set<string>();
        }        
        return contactLevelCategorySet;
    }
    public static Set<string> getConcategoryset(){
        if(concategoryset == null){
            concategoryset = new set<string>();
        }        
        return concategoryset;
    }
    
}