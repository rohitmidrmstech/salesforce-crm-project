public class AmountCall {
Final Integer OnlyOneSlice = 8 ;
 Final Integer UptoThreeSlices = 7 ;
Final Integer MoreThanThree = 6 ;
   
    public integer AmountSpilt(Integer NooffSlices){
      Integer AmountPay = NooffSlices==1 ? OnlyOneSlice*NooffSlices :NooffSlices<=3 ? NooffSlices*UptoThreeSlices: MoreThanThree*NooffSlices ;
        return AmountPay;
    }
}