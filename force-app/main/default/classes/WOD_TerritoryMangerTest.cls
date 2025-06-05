/**
 * @description Test class for WOD_TerritoryManger
*/
@isTest
private class WOD_TerritoryMangerTest {
    /**
     * @description data set up and execution
    */
	private static testmethod void  populateTM(){
        FIPS__c fips=new FIPS__c();
        fips.Name='Test';
        fips.FIPS_Code__c ='2222';
        fips.State__c='TS';
        insert fips;
        
        Territory__c terr=new Territory__c();
        terr.Name='No Territory';
        terr.Territory_SalesOrg__c='555';
        terr.Type__c='Residential';
        terr.Sales_Rep__c=Userinfo.getUserId();
        terr.Sales_Rep2__c=Userinfo.getUserId();
        terr.Sales_Rep3__c=Userinfo.getUserId();
        terr.Sales_Rep4__c=Userinfo.getUserId();
        terr.Sales_Rep5__c=Userinfo.getUserId();
        insert terr;
        
        
        Territory_Assignment__c ts=new Territory_Assignment__c();
        ts.Active__c=true;
        ts.FIPS__c=fips.Id;
        ts.Territory__c=terr.Id;
        
        Zip_to_Fips__c zipFips=new Zip_to_Fips__c();
        zipFips.FIPS_Code_Name__c=fips.Id;
        zipFips.State_Code__c='TS';
        zipFips.City__c='Test';
        insert zipFips;
        
        
        WOD_TerritoryManger tm=new WOD_TerritoryManger();
        tm.populateTM('TS','','Residential','Canada','Beauharnois','','');
        
        tm.populateTM('TS','','Residential','Aus','Sydney','','');
        tm.populateTM(null,'','Residential','Aus','Sydney','','');
        tm.setTerritoryType('1021', 'CBI Deneef');
        tm.setTerritoryType('1501', 'Residential');
        tm.setTerritoryType('1501', 'Solar');
        WOD_TerritoryManger.populateTMSiding('TS','Residential','Aus','Sydney');
        WOD_TerritoryManger.populateTMSiding('TS','Residential','Canada','Beauharnois');
        WOD_TerritoryManger.returnTM(terr.Id);
        WOD_TerritoryManger.populateTMSiding(null,'Residential','Aus','Sydney');
        
        
        
    }
}