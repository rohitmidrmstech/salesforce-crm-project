public class OneClickCaseCloseController{
    @TestVisible
    private String caseId;
    public OneClickCaseCloseController(ApexPages.StandardController controller){
       caseId = ApexPages.CurrentPage().getparameters().get('id');
    }
    public PageReference updateCaseStatus(){
        if(String.isNotBlank(caseId)){
            Case caseRecord = new Case(id = caseId, status='Closed');
            Update caseRecord;
        }
        return new PageReference('/'+caseId).setRedirect(true);
    }
}