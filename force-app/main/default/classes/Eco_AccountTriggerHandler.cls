/**
* @File Name:   Eco_AccountTriggerHandler
* @Description: Trigger handler for Account object  
* @Author:      Octavio Grijalva, ogrijalva@deloittemx.com
* @Group:       Apex Class
* @Modification Log :
* -------------------------------------------------------------------------------------
* Ver       Date        Author         Modification
* 1.0       2019-09-27  Deloitte     Created the file/class
* 1.1       2019-10-07  Deloitte     Updated to use trigger framework
* 1.1.1     2021-08-23  Deloitte     Created Function to Update Account Name
**/
public with sharing class Eco_AccountTriggerHandler extends Eco_AbstractTriggerHandler {
    private static Boolean ranOnce = false;

    public override void beforeInsert(){
        Eco_UpdateAccountNameBeforeInsert((List<Account>)Trigger.new);
    }

    public override void beforeUpdate(){
        Eco_UpdateAccountNameBeforeUpdate((List<Account>)Trigger.new);
        }

    /**
    * @Name          Eco_UpdateAccountNameBeforeInsert 
    * @Description   Update Account Name Before Insert
    * @Author        Octavio Grijalva
    * @CreatedDate   2021-08-23
    * @Return        void
    */
    public static void Eco_UpdateAccountNameBeforeInsert(List<Account> newAccounts) {
        for(Account ac:newAccounts){
            string updatename = ac.Name + '_Test';
            ac.Name = updatename;
        }
    }

    /**
    * @Name          Eco_UpdateAccountNameBeforeUpdate
    * @Description   Update Account Name Before Update
    * @Author        Octavio Grijalva
    * @CreatedDate   2021-08-23
    * @Return        void
    */
    public static void Eco_UpdateAccountNameBeforeUpdate(List<Account> newAccounts) {
         for(Account ac:newAccounts){
            string updatename = ac.Name + '_Test';
            ac.Name = updatename;
        }
    }
}