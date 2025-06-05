/**
 * @description To handle Attachment
*/
public class wod_AttachmentChange {
    public Id id{get;set;}
    public Attachment doc{get;set;}
    public String docContent{get;set;}
    public String logo{get;set;}
    public String targetObject{get;set;}
    public String header{get;set;}
    public String footer{get;set;}
    
    public String[] contentList{get;set;}
    public set<String> query{get;set;}
    public set<String[]> queryRelated{get;set;}
    public sobject objectData{get;set;}
    public list<sobject> relatedObjectData{get;set;}
    public String queryData{get;set;}
    public String queryRelatedData{get;set;}
    public  BLOB body{get;set;}
    public List<String> relatedTable{get;set;}
    
    /**
	 * @description To prepare Attachments
	 * @param id Id of the SObject]
     * @param zip Parent Id
	 * @return Attachment
	*/
    public Attachment FaultCodeFunc(Id id,Id zip){
        query=new set<String>();
        queryRelated=new set<String[]>();
        Id docId;
        relatedTable = new list<String>();
        String[] relatedData;
        String[] pdfData;
        queryData='Select ';
        queryRelatedData='Select ';
        //id = 'a062800000APnXo';//apexpages.currentpage().getparameters().get('id');
        //docId = apexpages.currentpage().getparameters().get('docId');
        system.debug('id::' + id);
        try{
        doc = [select Body from Attachment where ParentId =:zip and Name ='word/document.xml' limit 1]; 
        //system.debug('Body::' + doc.Body);        
        body = doc.Body;        
        docContent= body.toString();
        //docContent=EncodingUtil.base64Encode(doc.Body);
        }
        catch(exception e){
            docContent='test';
        }
        //system.debug('docContent::' + docContent);        
        contentList = docContent.split('</w:p>');
        //system.debug('::::contentList' + contentList);
        integer i=0;
        string test;
        String test2;
        targetObject='WOD_2__Claim__c';       
        for (string text : contentList )
        {
            
            while(text.contains('«'))
            {               
                //system.debug('text«::' + text);
                test=text.substring(0, text.indexOf('»') +1);                
                test2=text.substring(text.indexOf('»') +1, text.length());                
                
                String a=replace(test);
                if(a!='')
                    query.add(a);
                //test = test.replace('«','');
                //test = test.replace('»','');
                text=test2;//test+test2;
            }
        }
        //system.debug('::::queryFields' + query);
        
        
        for(string text : query) 
        {
            if(text!='')
            queryData = queryData + text + ',';
        }
        queryData = queryData.removeEnd(',');
         String queryString = queryData + ' from '+targetObject+' where Id = \'' + id + '\''; 
         /*String queryString = new twod.SoqlBuilder()
            .selectx(query)
            .fromx(targetObject)
            .wherex(new twod.FieldCondition('id').EQUALS(id))
            .toSoql();*/
        
        //system.debug('::::queryData' + queryData);
        
        //queryData = queryData.substring(0,queryData.length() - 1) ;
        //queryData = queryData + ' from '+targetObject+' where Id = \'' + id + '\'';        
        try{
            system.debug('::::query' + queryString);
            objectData = Database.query(queryString) ;
        
        //system.debug('::::objectData' + objectData);
        
        
        String value ;
        String[] obj ;
        
        for(string text : query)    
        {
            if(text.contains('.'))
            {
                value=splitString(text,objectData);
            }
            else
            {
                value = String.valueOf (objectData.get(text));  
            }
            
            if(value==null){ value=''; }
            system.debug('text-->'+text);            
            if(text.contains('date') || text.contains('Date')){
                system.debug('came insidee');
                Date d=Date.valueof(objectData.get(text));
                value=String.valueOf(d.format());
            }
            docContent = docContent.replace('«'+text+'»',value);   
            //system.debug('::::docContent' + docContent);
            
        }
        docContent = docContent.replace('«','');
        docContent = docContent.replace('»','');
        //Delete doc;
        Attachment a=new Attachment();
        //code changes start for zip issue(claim attachment download)
        /*
        try{
            a = [select Body from Attachment where ParentId =:zip and Name ='word/documentOri.xml' limit 1]; 
            Delete a;
             a=new Attachment();
            a.Body=Blob.valueof(docContent);
            a.ParentId =zip;
            a.Name ='word/documentOri.xml';
            //insert a;
        }
        catch(Exception e)
        {
            a=new Attachment();
            a.Body=Blob.valueof(docContent);
            a.ParentId =zip;
            a.Name ='word/documentOri.xml';
            //insert a;
        }*/
        List<Attachment> lstAttachments = new List<Attachment>();
        lstAttachments = [select Body from Attachment where ParentId =:zip and Name ='word/documentOri.xml'];
        if(!lstAttachments.isEmpty()){
            a = lstAttachments[0];
            Delete a;
        }
        a=new Attachment();
        system.debug('docContent--->'+docContent);
        a.Body=Blob.valueof(docContent);
        a.ParentId =zip;
        a.Name ='word/documentOri.xml';           
        //code changes end for zip issue(claim attachment download)
        
        //system.debug('::::a' + a.Id);
        
        //system.debug('::::Final docContent' + docContent);
        //system.debug('::::Related Data    ' + queryRelatedData ); 
        
        //docContent = blobToString(body, 'UTF-8');                
        //docContent=string.valueOf(body);        
        // docContent = EncodingUtil.urlEncode(docContent, 'UTF-8');
        // docContent = EncodingUtil.base64Encode(body);
        //system.debug(body.toString());     
        //          
        return a;
        }catch(exception e){
            system.debug('issuerrrre'+e.getMessage()+e.getLineNumber());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add('divyashree.kumar@tavant.com' );
            queryString+= ' <>' + e.getMessage();
            mail.setToAddresses(sendTo);
            mail.setSubject('Attachment Error');
            String body =queryString;
            mail.setHtmlBody(body);            
            Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('issue'+result);
            return null;
        }
    }
    /**
	 * @description To replace String
	 * @param text input String
	 * @return replaced string
	*/
    public static String replace(String text)
    {
        string test;
        String test2;
        //system.debug('textt--11111-Ori---' + text);   
        test=text.substring(text.indexOf('«') + 1, text.indexOf('»'));  
        //system.debug('test--11111--' + test);   
        //system.debug('test--11-<w:t>-' + test.indexOf('<w:t>'));   
        //system.debug('test--11-</w:t>-' + test.indexOf('</w:t>'));                   
                    
        return test;
    }
    /**
	 * @description To split String
	 * @param text input String
     * @param objectData SObject data
	 * @return output string
	*/
    public static String splitString(String text,sobject objectData)
    {
        String[] obj ;
        String val;
        //system.debug('-------TEXT--------' + text );
        obj = text.split('\\.',2);
        //system.debug('------OBJ---------' + obj );
        val=obj[1];
        sobject parentObject = objectData.getSobject(obj[0]);        
        if(val.contains('.'))
        {
            return( splitString(val,parentObject) );
        }
        else
        {
            return( (String)parentObject.get(obj[1]) );
        }
    }
        
        
}