/**
  * @File Name    :   Eco_AbstractTriggerHandler
  * @Description  :   Abstract Trigger Handler that all trigger handler extends from
  * @Date Created :   2017-05-09
  * @Author       :   Fan Yang, fanxyang@deloitte.ca
  * @group        :   Interface
  * @Modification Log:
  **************************************************************************************
  * Ver       Date        Author              Modification
  * 1.0       2017-05-09  Fan Yang            Craeted the file/class
  * 1.1       2018-04-18  William Lopez       Added Trigger framework 2.0
  * 2.0       2019-12-02  JF Guilbert         Streamlining changes

  Usage patterns:

  NOTES:
      1. DO NOT use the System.Trigger in your handler
      2. ALWAYS use [this.triggers] in your handler - it has the same API as System.Trigger
      3. BECAUSE an instance of [this.triggers] can be used in a future, queue or batch

  (0) - Custom Metadata setup entry in Eco_TriggerConfig__mdt:
      Label: Eco AccountContactRelations
      Name : Eco_AccountContactRelations
      Order__c  : 0
      Active__c : Y
      SObject__c: Account
      Handler_Name__c: Eco_AccountTriggerHandler

  (1) - Trigger code: [For the (0).SObject__c value]
      /**
        * @File Name    :   Eco_AccountTrigger
        * @Description  :   Account Trigger, calls Eco_TriggerFactory
        * @Date Created :   20..-..-..
        * @Author       :   xyz xyzlastname, Deloitte, xyzlastname@deloitte.ca
        * @group        :   Trigger
        * @Modification Log:
        **************************************************************************************
        * Ver       Date        Author              Modification
        * 1.0       20..-..-..  xyz xyzlastname     Created the file/class
        ** /
      trigger Eco_AccountTrigger on Account (
          // before insert, before update, before delete,
          // after insert, after update, after delete, after undelete
      ) {
          CDC_TriggerFactory.createHandlerAndExecute(Account.SObjectType);
      }

  (2) - Handler code SAMPLE: [For the (0).Handler_Name__c value]
      /**
        * @File Name    :   Eco_AccountTriggerHandler
        * @Description  :   Account Trigger Handler, invoked on DML actions for the object
        * @Date Created :   20..-..-..
        * @Author       :   xyz xyzlastname, Deloitte, xyzlastname@deloitte.ca
        * @group        :   Trigger
        * @Modification Log:
        **************************************************************************************
        * Ver       Date        Author              Modification
        * 1.0       20..-..-..  xyz xyzlastname     Created the file/class
        ** /
      public virtual with sharing class Eco_AccountTriggerHandler extends Eco_AbstractTriggerHandler
      {
          private static final List<String> FLDS_OFCHANGE = new String[]{'AccountId', 'Roles'};

          /**
            * @description Before object insert processing
            * @Date Created :   20..-..-..
            * @Author       :   xyz xyzlastname
            * /
          public override void beforeInsert()
          {
              System.debug('Context='+this.triggers.asJSON());
              ...
          }

          /**
            * @description After object update processing
            * @Date Created :   20..-..-..
            * @Author       :   xyz xyzlastname
            * /
          public override void afterUpdate()
          {
              Eco_Triggers trg = this.triggers;
              Account oldAcr;

              Set<Account>
                  relsAdd  = new Set<Account>(),
                  relsSubs = new Set<Account>();

              // -- Iterate against the incoming ACRs to identify if the AccountId has changed, which means [whatever] from the parenting change.
              for(Account acc : (List<Account>)trg.newLst)
              {   //Get the old values of the record.
                  oldAcc = (Account)trg.oldMap.get(acc.Id);

                  if(trg.hasChangedOR(acc, FLDS_OFCHANGE))
                  {
                      if(trg.isChanged(acc, FLDS_OFCHANGE[1]) && acc.AccountId != null) // Roles
                      {
                          if(acc.Roles.contains('[whatever]')) relsAdd.add(acc);
                          else relsSubs.add(acc);
                      }
                      if(trg.isChanged(acc, FLDS_OFCHANGE[0])) // AccountId
                      {
                          if(acc.Roles.contains('[whatever]'))
                          {
                              if(acc.AccountId != null)    relsAdd.add(acc);
                              if(oldAcc.AccountId != null) relsSubs.add(oldAcc);
                          }
                      }
                  }
              }
              if(!relsAdd.isEmpty())  doSomethingOnAdd(relsAdd,  ...);
              if(!relsSubs.isEmpty()) doSomethingOnSub(relsSubs, ...);
          }

          /**
            * @description After object delete processing
            * @Date Created :   20..-..-..
            * @Author       :   xyz xyzlastname
            * /
          public override void afterDelete()
          {
              ...
          }
      }
  **/
public with sharing abstract class Eco_AbstractTriggerHandler implements Eco_TriggerInterface
{
    public static Boolean FirstRun = true;

    public virtual void bulkBefore() {}
    public virtual void bulkAfter () {}
    public virtual void andFinally() {}

    public virtual void beforeInsert() {}
    public virtual void beforeUpdate() {}
    public virtual void beforeDelete() {}

    public virtual void afterInsert  () {}
    public virtual void afterUpdate  () {}
    public virtual void afterDelete  () {}
    public virtual void afterUndelete() {}

    public Eco_Triggers triggers { get; set; }

    /**
      * @Name          execute
      * @Description   Execute this handler
      * @Author        Fan Yang
      * @CreatedDate   2017-05-09
      * @Param         Eco_TriggerInterface instance handler
      * @Return        void
      */
    public void execute()
    {
        this.triggers = new Eco_Triggers();

        if(System.Trigger.isBefore)
        {
            this.bulkBefore();

            if     (System.Trigger.isDelete) { this.beforeDelete(); }
            else if(System.Trigger.isInsert) { this.beforeInsert(); }
            else if(System.Trigger.isUpdate) { this.beforeUpdate(); }
        }
        else
        {
            this.bulkAfter();

            if     (System.Trigger.isDelete)   { this.afterDelete(); }
            else if(System.Trigger.isInsert)   { this.afterInsert(); }
            else if(System.Trigger.isUpdate)   { this.afterUpdate(); }
            else if(System.Trigger.isUndelete) { this.afterUndelete(); }
        }
        this.andFinally();
    }

    /**
      * @Name          setFieldValues
      * @Description   For the specified object, set the collection of fields to their mapped values
      * @Author        JF Guilbert
      * @CreatedDate   2018-10-01
      * @Param         SObject             Account
      * @Param         Map<String, Object> Fields/Values mapping to consider
      * @Return        SOjbect             Affected input object
      */
    @TestVisible
    protected SObject setFieldValues(SObject pObj, Map<String, Object> pFlds)
    {
        for(String fld : pFlds.keySet()) pObj.put(fld, pFlds.get(fld));

        return pObj;
    }

    /**
      * @Name          wipeout
      * @Description   For the specified object, set the collection of fields to null
      * @Author        JF Guilbert
      * @CreatedDate   2018-07-20
      * @Param         SObject  Target object
      * @Param         String[] Fields to wipe-out
      * @Return        SOjbect  Affected input object
      */
    @TestVisible
    protected SObject wipeout(SObject pObj, String[] pFlds)
    {
        for(String key : pFlds) pObj.put(key, null);

        return pObj;
    }
}