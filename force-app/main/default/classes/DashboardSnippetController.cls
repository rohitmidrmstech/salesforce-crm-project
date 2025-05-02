public class DashboardSnippetController {
 public DashBoardSnippetController(){}

    public string getDashboardHtml(){
        PageReference dbPage = new PageReference('https://velocity58-dev-ed.lightning.force.com/lightning/r/Dashboard/01Z5j000001ALIZEA4');
        System.debug('dbpage' + dbPage);
        Blob pageBlob = dbPage.getContent();
        System.debug('pageBlob' + pageBlob);
        return pageBlob.toString();
    }
}