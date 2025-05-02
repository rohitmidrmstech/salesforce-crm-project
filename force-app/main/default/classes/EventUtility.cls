public class EventUtility {
    public static string Event(string EventStatus){
        string eventsta ;
        if(string.isBlank(EventStatus) || EventStatus.length() > 2 ){
            return null;
        }if(EventStatus == 'ca'){
            eventsta = 'High';
        }else{
            eventsta = 'cold';
        }
        return eventsta;
    }
}