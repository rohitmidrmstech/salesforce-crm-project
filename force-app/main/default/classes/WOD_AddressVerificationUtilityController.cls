/**
 * @description AddressVerifificationController is an Utility Class which is used as a proxy class  to make http calls to MelissaData API
 * About Melissa Data Personar API: Melissia Data personator API used to validate Address in USA/CA
 * http://wiki.melissadata.com/index.php?title=Personator
 */
public with sharing class WOD_AddressVerificationUtilityController {
   //String companyId='117433773';
    String companyId= System.Label.WOD_MelissaDataCompanyId;
    String action='Check';
    //String action='Verify,Append,Move';
    String JSON='json';
  	/**
  	 * @description Inorder to prepare requestdata
  	 * @param  address1 for Address 1
     * @param  address2 for Address 2
     * @param  cityName for City
     * @param  stateName for State
     * @param  zipCode for Zip
     * @param  country for Country
     * @param  email for Email
  	 * @return  String of Response
	 */
    public String address(String address1,String address2,String cityName,String stateName,String zipCode,String country,String email) {
    
        if(null == address2){
        	address2 ='';    
        }
        //XML Response-Not in Scope
        //String body='id='+companyId+'&act='+action+'&a1='+ EncodingUtil.urlEncode(address1, 'UTF-8') +'&a2='+ EncodingUtil.urlEncode(address2, 'UTF-8') +'&city='+ EncodingUtil.urlEncode(cityName, 'UTF-8') +'&admarea='+ EncodingUtil.urlEncode(stateName, 'UTF-8') +'&ctry='+ EncodingUtil.urlEncode(country, 'UTF-8') +'&postal='+ EncodingUtil.urlEncode(zipCode,'UTF-8');
        
        
        //JSON Response
        System.debug(address1+'=====>'+address2+'=='+cityName+'=='+stateName+'=='+zipCode+'=='+country+'=='+email);
        String body='format='+JSON+'&id='+companyId+'&act='+action+'&a1='+ EncodingUtil.urlEncode(address1, 'UTF-8') +'&a2='+ EncodingUtil.urlEncode(address2, 'UTF-8') +'&city='+ EncodingUtil.urlEncode(cityName, 'UTF-8') +'&state='+ EncodingUtil.urlEncode(stateName, 'UTF-8') +'&ctry='+ EncodingUtil.urlEncode(country, 'UTF-8') +'&postal='+ EncodingUtil.urlEncode(zipCode,'UTF-8')+'&email='+ EncodingUtil.urlEncode(email,'UTF-8');
          
        String URL='https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify?';
        //Melissa Data asked to send request in one URL.
        String restRequest = URL+body;
        System.debug('restRequest :'+restRequest);
        String result =AddressVerificationHttpCall(restRequest);
        System.debug('Validated Address'+result);
        return result;
    }
	
    /**
  	 * @description Inorder to prepare requestdata
  	 * @param   restRequest url of end point with body
  	 * @return  http response
	 */
    public String AddressVerificationHttpCall(String restRequest){
        String httptRes = null;
       	// if(isTestExceution)
        //    return getTestInput();
        try {            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(restRequest);
            req.setMethod('GET');
            System.debug('Request :'+req);
            // req.setBody(EncodingUtil.urlEncode(body,'UTF-8'));
            System.debug('Request body :'+req.getBody());
            System.debug('req:'+req);
            if(Test.isRunningTest()){
                httptRes='{"Records":[{"AddressExtras":" ","AddressKey":"12345000199","AddressLine1":"Street","AddressLine2":" ","City":"Schenectady","CompanyName":" ","EmailAddress":"i.santhosh94@gmail.com","MelissaAddressKey":"4691137080","NameFull":" ","PhoneNumber":" ","PostalCode":"12345-0001","RecordExtras":" ","RecordID":"1","Reserved":" ","Results":"AC02,AC03,AS01,ES01","State":"NY"}],"TotalRecords":"1","TransmissionReference":" ","TransmissionResults":" ","Version":"4.0.25"}';
            }else{
                HttpResponse res = http.send(req);
                httptRes = res.getBody();
                System.debug('response :'+res.getBody());
                System.debug('callout in  :'+Limits.getCallouts());      
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
            }          
        }
        catch(Exception exp){
            System.debug('Excepiton occurred while calling Melisa data API'+ exp.getMessage());
            httptRes = exp.getMessage();           
        }
        return httptRes;       
    }    
}