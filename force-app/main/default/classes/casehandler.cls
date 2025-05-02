public class casehandler {
    public static void updatepriority(List<case> lstcase){
        for(case ca : lstcase){
            if(ca.Origin == 'Email'){
                ca.Status= 'New';
                ca.Priority= 'Medium';
            }
        }
    }
}