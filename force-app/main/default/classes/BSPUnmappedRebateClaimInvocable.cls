public class BSPUnmappedRebateClaimInvocable {
    
   @InvocableMethod(label='Run Batch For BSP' Description = 'Launches the Review Job')
    public static void RunBSPbatch()
    {
        BatchToCheckUnMappedRebateClaims bspBatch = new BatchToCheckUnMappedRebateClaims();
        Database.executeBatch(bspBatch);
    }

}