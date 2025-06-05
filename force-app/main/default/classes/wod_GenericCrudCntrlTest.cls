/**
 * @description Test class for wod_GenericCrudCntrl
*/
@isTest
public class wod_GenericCrudCntrlTest {
  /**
   * @description data set up and execution
  */
	static testmethod void GenericCrudCntrlTest(){
     Test.startTest();
     wod_GenericCrudCntrl GenericController = new wod_GenericCrudCntrl();
     String dynaQuery = 'select Id, name, description from report LIMIT 3';
     String dynaQueryAcc = 'select Id, name from Account LIMIT 3';

        list<Account> tempAccountRecordsList = new List<Account>(); 
        list<Account> accountList = new List<Account>();
        
        Account acc=new Account();
        acc.Name='Burlington';
        acc.BillingCity = 'test';
        acc.BillingStreet = 'test';
        acc.BillingState = 'test';
        acc.BillingPostalCode = 'test';
        insert acc;
        tempAccountRecordsList.add(acc);
        
        wod_GenericCrudCntrl.OutputWrapper crudReadWrapper = new  wod_GenericCrudCntrl.OutputWrapper();
        List<wod_GenericCrudCntrl.DMLOutputWrapper> crudWrapper = new  List<wod_GenericCrudCntrl.DMLOutputWrapper>();
        List<wod_GenericForceCntrl.DMLOutputLockWrapper> crudLockWrapper  = new List<wod_GenericForceCntrl.DMLOutputLockWrapper>();
        crudReadWrapper = wod_GenericCrudCntrl.ReadSObjects(dynaQueryAcc);
        crudReadWrapper = wod_GenericCrudCntrl.ReadSObjects(dynaQuery); //pass string value
        crudWrapper =  wod_GenericCrudCntrl.InsertSObjects(tempAccountRecordsList);
        acc.BillingPostalCode='111111111111111111111111111111111111111111111';
        accountList.add(acc);
        crudWrapper =  wod_GenericCrudCntrl.UpdateSObjects(accountList);
        crudWrapper =  wod_GenericCrudCntrl.UpdateSObjects(tempAccountRecordsList);
        crudWrapper =  wod_GenericCrudCntrl.DeleteSObjects(tempAccountRecordsList);
        crudLockWrapper  = wod_GenericCrudCntrl.UpdateForceSObjects(tempAccountRecordsList);
        wod_GenericCrudCntrl.totalRecordsCount('2');
        
        WOD_TestDataFactory.createContact('Test','Last Name',acc.Id,false);
        WOD_TestDataFactory.createTerritory();
        Test.stopTest();
  }
  /**
   * @description data set up and execution
  */
    static testmethod void GenericCrudCntrlTest2(){
        wod_GenericCrudCntrl.ReadSObjects('');
       
    }
}