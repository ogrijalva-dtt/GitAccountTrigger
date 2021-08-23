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
  * 2.0       2019-12-02  JF Guilbert         Streamlining changes **/

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