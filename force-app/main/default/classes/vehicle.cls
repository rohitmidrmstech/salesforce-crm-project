public class vehicle {
        // this is the global vatriable we can use in any class or method
        public string firstname;
        public string lastname;
        public  integer rollno;
        public   decimal totalmarks;
        public   decimal obtmarks;
        public void printdetails(){
            system.debug( firstname);
            system.debug( lastname);
            system.debug(rollno);
        }  
        public decimal percentagecal() {
            decimal percentage = (obtmarks/totalmarks)*100 ;
            printdetails();
            return percentage;
        }        
        public void showdetails(decimal perc){
            
            if (perc >= 75){
                system.debug('distinction qualifie');
            }             
            else if(perc >=65 && perc < 75){
                system.debug('first class is covered');
                
            }     
            
            else if (perc >= 45 && perc < 65){
                system.debug('second class');
            }     
            else {
                system.debug('your bou is failed to qualify the exam');   
            }   
        }
    }