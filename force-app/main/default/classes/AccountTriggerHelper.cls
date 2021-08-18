/**************************************************************************************
Apex Trigger Name:  AccountTriggerHelper
Version     : 1.0 
Created Date    : 18 August 2021
Function    : Manage tasks related to the Account.
Modification Log :
* Developer                   Date          Version         Description
* ----------------------------------------------------------------------------                 
* Octavio Grijalva          08/18/2021       1.0           Original Version
*************************************************************************************/

public class AccountTriggerHelper {
    
    public void UpdateName(List<Account> newAcc){
        
        for(Account ac:newAcc){
            string updatename = ac.Name + '_Test';
            ac.Name = updatename;
        }
         
    }

}