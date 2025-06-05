public with sharing class OpportunityViewController {
    String recordId;
    
    public OpportunityViewController(ApexPages.StandardController sc) {
       
 recordId = sc.getId();
 }

public PageReference redirect() {

  List<User> listUser = [Select Id from User where Id = :Userinfo.getUserId() and (Profile.Name like '%Canada%' or Profile.Name = 'Custom Standard Profile' or Profile.Name = 'Super User')];
            if(listUser.size() == 0) {
       PageReference customPage =  new PageReference('/'+recordId);
       customPage.setRedirect(true);
       customPage.getParameters().put('id', recordId);
       return customPage;
      } else {
          return null; //otherwise stay on the same page 
      }
   }
   
}