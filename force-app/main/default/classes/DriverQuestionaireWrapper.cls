/**
 *	Purpose			:	This class is used to hold custom logic for Lightning experience page of Driver Safety Audit.
 *
 *	Created By		:	Padmesh Soni (Appirio Offshore)
 *
 *	Created Date	:	11/7/2017
 *
 *	Current Version	:	V_1.0
 *
 *	Revision Log	:	V_1.0 - Created - S-523609
 **/
public class DriverQuestionaireWrapper implements Comparable {
    	
	@AuraEnabled
	public String questionTopic;
	
	@AuraEnabled
	public String question;
	
	@AuraEnabled
	public String answer;
	
	@AuraEnabled
	public Integer name;
	
	@AuraEnabled
	public boolean isShowQuestionTopic;
	
	public DriverQuestionaireWrapper(String questionTopic, String question, String answer, Integer name) {
		
		this.questionTopic = questionTopic;
		this.question = question;
		this.answer = answer;
		this.name = name;
	}
	
	public Integer compareTo(Object compareTo) {
		
        DriverQuestionaireWrapper driverSafeWrapper = (DriverQuestionaireWrapper) compareTo;
        
        if (name == driverSafeWrapper.name) 
        	return 0;
        
        if (name > driverSafeWrapper.name) 
        	return 1;
        
        return -1;        
    }
}