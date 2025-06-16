global with sharing class AccountRetrieval {
    webService static String getAccounts(String cli, String accQuery, String contQuery) {
       String whereac = accQuery.length() > 3 ? (' WHERE ' + accQuery) : '';
       String wherect = contQuery.length() > 3 ? (' WHERE ' + contQuery) : '';

       String sQuery = 'FIND \'' + cli + '\' IN PHONE FIELDS RETURNING Account(id, name' 
           + whereac + '), Contact(id, name' + wherect + ')';
       List<List<SObject>> searchList = search.query(sQuery);
       String JSONString = JSON.serialize(searchList);
       return JSONString;
    }
    /* @@code merge from outmerge sandbox */
      webService static String getAccountsInsulation(String cli, String accQuery, String contQuery) {
       String whereac = accQuery.length() > 5 ? (' WHERE ' + accQuery) : '';
       String wherect = contQuery.length() > 5 ? (' WHERE ' + contQuery) : '';

       String sQuery = 'FIND \'' + cli + '\' IN PHONE FIELDS RETURNING Account(id, name' 
           + whereac + '), Contact(id, name' + wherect + ')';
       List<List<SObject>> searchList = search.query(sQuery);
       String JSONString = JSON.serialize(searchList);
       return JSONString;
    }
    
}