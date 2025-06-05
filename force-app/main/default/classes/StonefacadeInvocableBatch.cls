/* **********************************************************************************************************************************
* Class Name   : StonefacadeInvocableBatch
* Description  : Class to call batch class from flow
* Author       : Dipen
* Created On   : Dec 30,2023
* Test Class   : StonefacadeInvocableBatchTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         30-12-20223           1000              Initial Development
**************************************************************************************************************************************/

public class StonefacadeInvocableBatch 
{
   @InvocableMethod(label='Run Batch For StoneFacade' Description = 'Launches the Batch Job')
    public static void Runbatch()
    {
        BatchToCalculateTransactionvalue sfbatch = new BatchToCalculateTransactionvalue();
        Database.executeBatch(sfbatch);
    }
}