@isTest
private class TestZipToFIPSZipController{

    static testmethod void myUnitTest1(){
        Profile profileUsed = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User testUser = new User();
        testUser.Email = 'test@test.com';
        testUser.Username = 'username1@first.com';
        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = profileUsed.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.EmailEncodingKey = 'UTF-8';
        
        insert testUser;
        
        List<FIPS__c> fipsList = new List<FIPS__c>();
        
        FIPS__c fips = new FIPS__c();
        fips.Name='Manhattan - New York - USA'; 
        fips.FIPS_Code__c='698751'; 
        fips.Country__c='Canada'; 
        fips.State__c='Vancouver';
        fips.County__c='Vancouver';
        //Insert fips;
        //FIPS__c f = [SELECT id, Name, FIPS_Code__c, Country__c,State__c, County__c FROM FIPS__c WHERE id =: fips.id limit 1][0];
        
        fipsList.add(fips);
        
        FIPS__c fips1 = new FIPS__c();
        fips1.Name='Malvern'; 
        fips1.FIPS_Code__c='698752'; 
        fips1.Country__c='USA'; 
        fips1.State__c='Pennsylvania';
        fips1.County__c='Chester';
        fipsList.add(fips1);
        
        INSERT fipsList;

        Territory__c terry = new Territory__c();
        terry.Territory_Code__c = 'TS07406';
        insert terry;
        //Territory__c t = [SELECT id, Territory_Code__c FROM Territory__c WHERE id =: terry.id limit 1 ][0];         
        
        List<Territory_Assignment__c> tAssignList = new List<Territory_Assignment__c>();
        Territory_Assignment__c tAssignment = new Territory_Assignment__c();
        tAssignment.Territory__c = terry.id;
        tAssignment.FIPS__c = fips.id;
        
        //Insert tAssignment;
        //Territory_Assignment__c ta = [SELECT id, FIPS__c From Territory_Assignment__c Where id=: tAssignment.id limit 1][0];
        tAssignList.add(tAssignment);
        
        Territory_Assignment__c tAssignment1 = new Territory_Assignment__c();
        tAssignment1.Territory__c = terry.id;
        tAssignment1.FIPS__c = fips1.id;
        tAssignList.add(tAssignment1);
        
        Insert tAssignList;
        
        
        List<Zip_to_Fips__c> ziptoFipsList = new List<Zip_to_Fips__c>();
        Zip_to_Fips__c zipToFips = new Zip_to_Fips__c();
        zipToFips.Name ='19341';
        zipToFips.FIPS_Code_Name__c = fips.id;
        zipToFips.City__c = 'New York';
        //zipToFips.Country__c = f.Country__c;
        
        //Zip_to_Fips__c zipfip = [SELECT id, Name, City__c, FIPS_Code_Name__c, FIPS_Code_Name__r.County__c FROM Zip_to_Fips__c WHERE id =: zipToFips.id limit 1][0];
        ziptoFipsList.add(zipToFips);
        
        Zip_to_Fips__c zipToFips1 = new Zip_to_Fips__c();
        zipToFips1.Name ='19355';
        zipToFips1.FIPS_Code_Name__c = fips1.id;
        zipToFips1.City__c = 'Malvern';
        ziptoFipsList.add(zipToFips1);
        
        INSERT ziptoFipsList;
        /*
        ZipToFIPSZipController controller = new ZipToFIPSZipController();
        try {
            ApexPages.Pagereference result = controller.showZipCode();
        } catch(Exception e) {
            //system.assertEquals(e.getMessage().contain('No Record Found'));
        }
       
        controller.exportToExcel();
        controller.reset();
        ziptoFipsList.clear();
        */
        
    }
    
 }