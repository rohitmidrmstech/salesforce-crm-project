public class encapsulationEMP {
    private string Firstname;
    private string lastname;
    private string email;
    private string empid;
    private string accesstoken = '5646mlhngmgrmlrm6dmf';
    class MyOwnException extends Exception{}    
    public void setname(string name){
        if(string.isNotBlank(name)){
            this.Firstname = name; 
        } else {
            throw new MyOwnException('name is required');
        }        
    }
    public string getname(){
        if(string.isBlank(Firstname)){
            throw new MyOwnException('set the name');   
        } 
        return Firstname;
    }
    public void setemail(string email){
        if(string.isNotBlank(email)&& email.contains('@')){
            this.email = email; 
        } else {
            throw new MyOwnException('email is required');   
            
        } 
    }
    public string getemail(){
        if(string.isEmpty(email)) {
            throw new MyOwnException('set the email');
        }else{
            return email;  
            
        } 
        
    }
    
    public void setlastname(string lastname){
        
        if(string.isNotBlank(lastname)){
            this.lastname = lastname; 
        } 
        else
        {
            throw new MyOwnException('lastname is required');   
            
        }
    }                   
    public string getlastname(){
        if(string.isBlank(lastname)) {
            throw new MyOwnException('set the lastname');
        }else{
            return lastname;  
        }
    }
    
    public string getaccesstoken(){
        string profileid = userinfo.getProfileId();
        list<profile> lstp = [select id ,name from profile where Id =: profileid limit 1];
        profile objp = lstp[0]; 
        if(objp.Name != 'systemadminstrator'){
            throw new MyOwnException('you have not a profile');
                }
        
        return accesstoken;
    }              
}