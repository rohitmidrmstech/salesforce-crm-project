public class dimart {
    public void showdidiscount( decimal leastprice ,decimal discountp){
        productdetail d1 = new productdetail();
        d1.discountp = discountp;
        d1.leastprice =leastprice;
        decimal amnt = d1.totaldiscount();
        string msg = d1.showtotaldiscount(amnt);
        system.debug('result is :' + msg);
    }      
}