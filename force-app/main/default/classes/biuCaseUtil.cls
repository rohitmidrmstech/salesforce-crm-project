public with sharing class biuCaseUtil {
    //This method is to format the Documents__c field data into Html format
    public static void formatDocumentData(case csNew, case csOld){
        String fileName;
        String htmlUrl = '';
        String documentdata;
        String[] urls;              
        if(csNew.Documents__c != null && csNew.Documents__c != ''){
            
            documentdata = csNew.Documents__c;           
            if(!documentdata.contains('<a')){
                urls = documentdata.split(',');
                if(urls.size()>0){
                    for(String strUrl : urls){
                        if(strUrl != ''){
                            strUrl = strUrl.replace('<br>', '');
                            fileName = getFileName(strUrl); 
                            if(htmlUrl == ''){
                                htmlUrl = getHtmlLink(strUrl,fileName);
                            }
                            else{
                                htmlUrl = htmlUrl + '<br>' + getHtmlLink(strUrl,fileName);
                            } 
                        }
                        
                    }
                }
                if(csOld != null){
                    if(csOld.Documents__c != '' && csOld.Documents__c != null){
                     csNew.Documents__c = csOld.Documents__c + '<br>' +  htmlUrl;
                    }
                    else{
                         csNew.Documents__c = htmlUrl;
                    }
                }
                else{
                    csNew.Documents__c = htmlUrl;
                }
              
               
            }
            
        }
    }
  //This method is to get the file name from the document url  
    private static string getFileName(String url){
        Integer startIndex;
        Integer endIndex;
        string strFileName;
        system.debug('url-->' + url);
        startIndex= url.lastindexOf('/');
        endIndex = url.indexOf('?');
        if(startIndex != -1 && endIndex != -1){
            strFileName =  url.substring(startIndex + 1,endIndex);
        }
        else if(startIndex != -1){
            strFileName =  url.substring(startIndex + 1);
        }
        else{
            strFileName = url;
        }
        return strFileName;
    }
    //This method is to format the url into html format
    private static string getHtmlLink(String url, String fileName){
        string strHtmlUrl;
        strHtmlUrl = '<a href="' + url + '" target="_blank">' + fileName + '</a>';       
        return strHtmlUrl;
    }    
    
}