/**************************************************************************************
Apex Trigger Name:  AccountTrigger
Version     : 1.0 
Created Date    : 18 August 2021
Function    : Trigger before Insert.
Modification Log :
* Developer                   Date          Version         Description
* ----------------------------------------------------------------------------                 
* Octavio Grijalva          08/18/2021       1.0           Original Version
*************************************************************************************/

trigger AccountTrigger on Account (before insert) {
 
    AccountTriggerHelper AccountUpdate = new AccountTriggerHelper();
   
    if (Trigger.isInsert) {
        
        AccountUpdate.UpdateName (Trigger.new);
     
    }
}