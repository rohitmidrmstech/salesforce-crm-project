// Created by Sneha on 1-Aug-2017 for S-503818
@isTest
public class SafeDrivingSMATCardController_Test{

    public static testMethod void testMyController() {
    
    
        SafeDrivingSMATCardController obj= new SafeDrivingSMATCardController();
        obj.getSafetyOptions();
        obj.getConfirmation();
        obj.cObserverName='test';
        obj.cTimeDate=System.today();
        obj.cRegion='test';
        obj.cLocation ='test';
        obj.cPreparation ='test';
        obj.cTravel='test';
        obj.cBreakingParking='test';
        obj.cArrival ='test';
        obj.cImprovements ='test';
        obj.cEmplyeeComments ='test';
        obj.cAddComments ='test';
        obj.cSEval  ='test';
   
   
    }
    
    
    
}