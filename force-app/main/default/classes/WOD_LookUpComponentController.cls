/**
 * @description This class used to handle Lookup Records
*/
public with sharing class WOD_LookUpComponentController {
    /**
     * @description Search the records with entered text
     * @param searchKey entered text
     * @param objectName SObject API Name
     * @param filter Record filter condition
     * @param primaryField fileds api name
     * @param SecondaryFields fileds api name
     * @return List of SObject records
    */
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName,String filter,String primaryField,String SecondaryFields) {  
      string searchText = '\'%' + String.escapeSingleQuotes(searchKey) + '%\'';  
      string fields = primaryField;
      String searchFilter = ' WHERE (('+primaryField+ ' LIKE '+searchText+')';
      

      if(String.IsNotBlank(SecondaryFields)){
        List<String> secFieldsList = SecondaryFields.split(',');
        for(String fld:secFieldsList){
          if(fld != primaryField){
            fields = fields+','+fld;
            searchFilter = searchFilter + 'OR ('+fld+ ' LIKE '+searchText+')';
          }
        }
      }

      string query = 'SELECT Id,'+fields+' FROM ' +objectName + searchFilter+')';

      if(String.IsNotBlank(filter)){
        query = query+' AND '+filter;
      }
      query = query+' order by '+primaryField+' LIMIT 200';  

      system.debug('@@@@query'+query);
      return Database.query(query);  

    }  
}