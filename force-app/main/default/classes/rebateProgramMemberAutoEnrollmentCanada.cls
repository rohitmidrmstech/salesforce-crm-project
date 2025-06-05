/* **********************************************************************************************************************************
* Class Name   : rebateProgramMemberAutoEnrollmentCanada
* Description  : This class is written to create BP program rebate members for the Canada if a new contact is either created or updated 
*					from CCB not eligible to eligible.
* Author       : Hithesh
* Modified On  : jan 28,2025
* Test Class   : rebateProgramMemberAutoEnrollmentTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*
**************************************************************************************************************************************/
public class rebateProgramMemberAutoEnrollmentCanada {
    
    public static void autoEnrollment(List<Contact> contacts){
        try{
            set<Contact> canadaContacts = new set<Contact>();
            set<contact> inactiveCanadaContacts = new set<contact>();
            map<id,RebateProgramMember> contactWithProgram = new map<id,RebateProgramMember>();
            set<contact> contactWithoutProgram = new set<contact>();
            list<RebateProgramMember> updateRebateProgramMember = new list<RebateProgramMember>();
            list<RebateProgramMember> insertRebateProgramMember = new list<RebateProgramMember>();
            set<string> activeduplicatecheck = new set<string>();
            set<string> inactiveduplicatecheck = new set<string>();
            
            //Here we are fetching all the contacts which are CCB Eligible
            for(Contact c:contacts){
                if((c.Mailing_Country_Bank_Report__c == 'CAN') && (c.CCB_Eligibility__c =='Eligible') && (c.Distributor__c != 'Yes') && (c.Status__c == 'Active')){
                    canadaContacts.add(c);
                    system.debug('canadaContacts==='+canadaContacts);
                }
                
                //here we are fetching all the contacts where CCB is Not eligible
                if((c.Mailing_Country_Bank_Report__c == 'CAN') && (c.CCB_Eligibility__c =='Not Eligible' || c.CCB_Eligibility__c == 'Not Eligible for current year') && (c.Distributor__c != 'Yes') && (c.Status__c == 'Active')){
                    inactiveCanadaContacts.add(c);
                    system.debug('inactiveCanadaContacts==='+inactiveCanadaContacts);
                }
            }
            date dat = system.today();
            string currentYear = string.valueof(dat.year());
            system.debug('currentYear==='+currentYear);
            list<rebateProgram> currentYearPrograms = [SELECT Id,Name FROM rebateProgram WHERE Program_Active_Year__c =: currentYear AND Rebate_Program_Sub_Type__c = 'BP'];
            system.debug('currentYearPrograms==='+currentYearPrograms);
            if(canadaContacts.size()>0){
                string key='';
                //fetching the rebate program members associated with the contact.
                for(RebateProgramMember rpm:[SELECT Id,Name,MemberStatus,Contact__c,RebateProgramId FROM RebateProgramMember WHERE Contact__c IN: canadaContacts AND RebateProgramId IN: currentYearPrograms]){
                    //checking if the Rebate program member is active or not
                    if(rpm.MemberStatus == 'Active'){
                        key = rpm.Contact__c+ '-' +rpm.RebateProgramId;
                        activeduplicatecheck.add(key);
                        contactWithProgram.put(rpm.Contact__c,rpm);
                        system.debug('contactWithProgram==='+contactWithProgram);
                    }
                    //if inactive and ccb eligible then need to be changed to active
                    if(rpm.MemberStatus == 'Inactive'){
                        key = rpm.Contact__c+ '-' +rpm.RebateProgramId;
                        if(!activeduplicatecheck.contains(key)){
                            contactWithProgram.put(rpm.Contact__c,rpm);
                            system.debug('contactWithProgram==='+contactWithProgram);
                            RebateProgramMember member 	= new RebateProgramMember();
                            member.Id					= rpm.id;
                            member.MemberStatus 		= 'Active';
                            updateRebateProgramMember.add(member);
                            key = rpm.Contact__c+ '-' +rpm.RebateProgramId;
                            activeduplicatecheck.add(key);
                            system.debug('activeduplicatecheck==='+activeduplicatecheck);
                        }
                    }
                }
                //collecting all the contacts without the program member if it is not there then we need to create
                for(contact c:canadaContacts){
                    if(!contactWithProgram.containskey(c.Id)){
                        contactWithoutProgram.add(c);
                        system.debug('contactWithoutProgram==='+contactWithoutProgram);
                    }
                    
                    // Here we are creating a program member for the contacts as the contact is not part of this program
                    for(contact con:contactWithoutProgram){
                        key = con.Id+ '-' + currentYearPrograms.get(0).id;
                        system.debug('Key==='+key);
                        if(!activeduplicatecheck.contains(key)){
                            RebateProgramMember newmember 	= new RebateProgramMember();
                            newmember.Contact__c 			= con.Id;
                            newmember.MemberStatus 			= 'Active';
                            newmember.RebateProgramId 		= currentYearPrograms.get(0).id;
                            newmember.Name					= currentYearPrograms.get(0).Name + ' - ' + con.FirstName + ' '+ con.LastName;
                            insertRebateProgramMember.add(newmember);
                            key = con.Id+ '-' + currentYearPrograms.get(0).id;
                            activeduplicatecheck.add(key);
                            system.debug('activeduplicatecheck==='+activeduplicatecheck);
                        }
                    }
                }
            }
            // if a program member is 
            if(inactiveCanadaContacts.size()>0){
                string inactivekey = '';
                for(RebateProgramMember rpm:[SELECT Id,Name,MemberStatus,Contact__c,RebateProgramId FROM RebateProgramMember WHERE Contact__c IN: inactiveCanadaContacts AND RebateProgramId IN: currentYearPrograms]){
                    inactivekey = rpm.Contact__c + '-' + currentYearPrograms.get(0).id;
                    system.debug('inactivekey==='+inactivekey);
                    if(!inactiveduplicatecheck.contains(inactivekey)){
                        RebateProgramMember inactivemember 	= new RebateProgramMember();
                        inactivemember.Id 					= rpm.id;
                        inactivemember.MemberStatus			= 'Inactive';
                        updateRebateProgramMember.add(inactivemember);
                        inactiveduplicatecheck.add(inactivekey);
                        system.debug('updateRebateProgramMember==='+updateRebateProgramMember);
                    }
                }
            }
            if(updateRebateProgramMember.size()>0){
                update updateRebateProgramMember;
            }
            if(insertRebateProgramMember.size()>0){
                insert insertRebateProgramMember;
            }
        } catch(Exception e){
            integer lineNumber = e.getLineNumber();
            System.debug('Exception in methodautoEnrollment: ' + e.getMessage()+'The error line number ===' +lineNumber);
        } 
    } 
}