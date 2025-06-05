/***** AccountMergeController *****
@Author Vincent Ip/LiquidHub
@Date 10-12-2015
@Description This class is built to assist in the Migration from BPCS to SAP.
	This class supports a process to Merge (Salesforce Merge Operation) Account
	records and re-parent child records.  This is being built for the BPCS to SAP
	migraition and may be removed after.

Revision History
12-08-2015	Vincent Ip/LiquidHub			Initial Version
****************************************/
public with sharing class AccountMergeController {

	// used by the page for parameter passing
	public String inputAccountIds {get;set;}

	// internal processing variables
	private List<String> inputAccountIdList = new List<String>();


	public AccountMergeController() {
	}

	public PageReference processAccountIds(){
		inputAccountIdList = inputAccountIds.replaceAll('\r\n','\n').replaceAll('\r','\n').split('\n', -1);
		System.Debug('---inputAccountIdList:'+inputAccountIdList);

		for(Integer currIndex = 0; currIndex < inputAccountIdList.size(); currIndex++){
			
			// get the current row and do a split by ','
			String currSetString = inputAccountIdList.get(currIndex);
			List<String> currSetStringList = currSetString.split(',', -1);
			if (currSetStringList.size()<=1) break;

			// get all the accounts into a map to make it quick
			map<Id, Account> acctMap = new Map<Id, Account>([select Id from Account where id in :currSetStringList]);

			// get the master account (the first id in the list)
			String masterId = currSetStringList.get(0).trim();
			Account masterAccount = acctMap.get( masterId );

			// merge in the rest
			for(Integer mergeIndex=1; mergeIndex<currSetStringList.size(); mergeIndex+=2){

				if ( mergeIndex+1 < currSetStringList.size() ){
					// merge the next 2 with the master
					Id idOne = currSetStringList.get(mergeIndex).trim();
					Id idTwo = currSetStringList.get(mergeIndex+1).trim();
					System.debug('---idOne:'+idOne);
					System.debug('---idTwo:'+idTwo);

					list<Account> acctList = new Account[]{ acctMap.get(idOne), acctMap.get(idTwo) };
					merge masterAccount acctList;
				}else{
					// merge the next one with the master
					Id idOne = currSetStringList.get(mergeIndex).trim();
					System.debug('---idOne:'+idOne);
					merge masterAccount acctMap.get(idOne);
				}
			}
		}

		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 
			'Completed Merge Operation.  Rows Processed:'+inputAccountIdList.size()));
		return null;
	}

}