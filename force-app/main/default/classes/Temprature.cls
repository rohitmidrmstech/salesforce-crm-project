public class Temprature {
    public static decimal FtoC(Decimal fh){
        decimal res = (fh - 32) * 5/9;
        return res.setScale(2);
    }
}