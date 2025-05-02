public class newrecord {

    public void bulkInsertOnj1(Integer noOfRecords){
        
        Integer start = 0;
        Integer i;
        
        List<obiA__c> lstObj = new List<obiA__c>();
        
        for (i = start; i <= noOfRecords; i++){
            
            obiA__c Com = getObj(i);
            lstObj.add(Com);
        }
        insert lstObj;
    }
    
    public obiA__c getObj(Integer index){
        
        obiA__c Com = new obiA__c();
        Com.Name = getName(index);
        
        return Com;
    }
    
    public String getName(Integer index){
        
        List<String> lstAccname = new List<String>();
        lstAccname.add('Rohit Account');
        lstAccname.add('nitin Account');
        lstAccname.add('mangesh Account');
        lstAccname.add('rhan ccount');
        lstAccname.add('soham Account');
        lstAccname.add('shenaj Account');
        lstAccname.add('satyam Account');
        lstAccname.add('kalia Account');
        lstAccname.add('Gabbarsingh Account');
        lstAccname.add('samba Account');
        lstAccname.add('jay Account');
        lstAccname.add('viru Account');
        
        String name = lstAccname[index];
        return name;
    }

}