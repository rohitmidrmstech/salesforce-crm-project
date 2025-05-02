public class Productdetail {
    //global variable declaration
    public string p1;
    public string p2;
    public integer totalp;
    public decimal discountp;
    public decimal leastprice;
    public void productd(){
        system.debug(p1);
        system.debug(p2);
        system.debug(discountp);
        system.debug(leastprice);
    }
    public decimal totaldiscount(){
        decimal amount =(leastprice - discountp/100 *leastprice );
        system.debug('the net amount costomer have to pay :' + amount);
        return amount;
    }
    public string  showtotaldiscount(decimal amnt){
        string msg;
        
        if(amnt > 100){
            msg = 'this is invalid discount';
        } else    {
            
            
            if (amnt >= 5){
                msg = 'first class discount';
            }
            else if (amnt >=20 ){
                msg = 'second class discount';
            }
            else if (amnt >= 50 ){ 
                msg = 'this is third class discount';
            }  
            else {
                msg = 'failed';
            }
        }  return msg;
    }
}