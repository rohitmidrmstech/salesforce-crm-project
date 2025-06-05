@isTest
private class CTI_View_More_Controller_Test 
{
    public static testMethod void test1()
    {
    
        PageReference pageRef = new PageReference('Page.CTI_View_More');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ANI','5555555555');
        CTI_View_More_Controller someController = new CTI_View_More_Controller();
    } 
}