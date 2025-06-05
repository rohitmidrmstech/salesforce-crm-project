/**
 * An apex page controller that exposes the site login functionality
 * History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
 */
global with sharing class SiteLoginController {
    /*
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
    global SiteLoginController () {}
   /* @@ code merge from outmerge sandbox
   global static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }
    */
}