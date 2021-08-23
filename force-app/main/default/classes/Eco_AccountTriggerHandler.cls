/**
* @File Name:   Eco_AccountTriggerHandler
* @Description: Trigger handler for Account object  
* @Author:      Deloitte, username@deloitte.ca
* @Group:       Apex Class
* @Modification Log :
* -------------------------------------------------------------------------------------
* Ver       Date        Author         Modification
* 1.0       2019-09-27  Deloitte     Created the file/class
* 1.1       2019-10-07  Deloitte     Updated to use trigger framework
**/
public with sharing class Eco_AccountTriggerHandler extends Eco_AbstractTriggerHandler {
    private static Boolean ranOnce = false;

    public override void beforeInsert(){
        function1((List<Account__c>)Trigger.new);
    }

    public override void afterInsert(){
        if(!ranOnce) {
            function2((List<Account__c>)Trigger.new);
        }
    }

    /**
    * @Name          function1
    * @Description   
    * @Author        Deloitte
    * @CreatedDate   2019-09-27
    * @Return        void
    */
    public static void function1(List<Account__c> newAccounts) {
        for(Account ac:newAccounts){
            string updatename = ac.Name + '_Test';
            ac.Name = updatename;
        }
    }

    /**
    * @Name          function2
    * @Description   
    * @Author        Deloitte
    * @CreatedDate   2020-02-28
    * @Return        void
    */
    public static void function2(List<Account__c> newAccounts) {
        // handle your changes
    }
}