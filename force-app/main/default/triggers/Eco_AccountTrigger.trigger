/**
* @File Name    :   Eco_AccountTrigger
* @Description  :   Account Trigger, calls Eco_TriggerFactory
* @Date Created :   2021-08-23
* @Author       :   Octavio Grijalva, Deloitte, ogrijalva@deloittemx.com
* @group        :   Trigger
* @Modification Log:
**************************************************************************************
        * Ver       Date          Author             Modification
        * 1.0     2021-08-23  Octavio Grijalva   Created the Trigger **/
        
      trigger Eco_AccountTrigger on Account (before insert, before update) {
          Eco_TriggerFactory.createHandlerAndExecute(Account.SObjectType);
      }