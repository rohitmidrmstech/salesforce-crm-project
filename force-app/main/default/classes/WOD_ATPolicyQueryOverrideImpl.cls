/**
 * -------------------------------------------------------------------------------------------------
 * @author         Pintoo Jadaun<pintoo.jadaun@tavant.com>
 * @created        12-March-2021
 * @description    WOD_ATPolicyQueryOverrideImpl.
 * -------------------------------------------------------------------------------------------------
 */
global  class WOD_ATPolicyQueryOverrideImpl implements WOD_2.ATQueryOverrideInterface {
	/**
   * @description Get List of Applicability Term Records based on the conditions
   * @param query SOQL query 
   * @param queryFields list of the fields paresent in the record
   * @param ruleObjectName Rule Object API Name
   * @param baseObjectFieldName Base Object field API Name
   * @return List of AT
   */
  global List<WOD_2__Applicability_Term__c> fetchApplicabilityTerm(String query, List<String> queryFields, String ruleObjectName, String baseObjectFieldName ) {
      
      String buName = WOD_ClaimQuickActionController.buName;
      system.debug('@@claim Install Date'+WOD_ClaimQuickActionController.claimInstallDate);
      query += ' AND WOD_2__Policy_Definition__r.WOD_2__Business_Units__c=:buName AND WOD_2__Policy_Definition__r.WOD_2__Status__c = \'Active\'';
      
      if(WOD_ClaimQuickActionController.claimInstallDate != null){
        Date claimInstallDate = WOD_ClaimQuickActionController.claimInstallDate;
        query += ' AND WOD_2__Policy_Definition__r.WOD_2__Active_From__c <=: claimInstallDate AND WOD_2__Policy_Definition__r.WOD_2__Active_Until__c >=:claimInstallDate order by WOD_2__Policy_Definition__r.WOD_2__Priority__c ASC NULLS LAST';
      }
      System.debug('@@@AT Query - ' +query);
      return Database.query(query);
    }
  }