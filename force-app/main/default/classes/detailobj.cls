public class detailobj {
    public void showdetail1(){
        stdobject objrecord = new stdobject();
        Account acc = objrecord.accrecord('ot','3736',363.456);
        contact con =objrecord.conrecord('chle','rotr@gmail.com','36',acc);
        objrecord.opprecord('vty',4.47,con,acc,'closed won',date.newInstance(2022, 3, 10));
        
    }
}