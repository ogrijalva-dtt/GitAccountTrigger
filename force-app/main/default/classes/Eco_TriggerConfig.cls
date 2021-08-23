/**
  * @File Name:   Eco_TriggerConfig.cls
  * @Description:
  * @Date Created: 2017-05-09
  * @Author:       Fan Yang, fanxyang@deloitte.ca
  * @Group:        Apex
  * @Modification Log :
  *-------------------------------------------------------------------------------------
  * Ver       Date        Author         Modification
  * 1.0       2017-05-09  Fan Yang       Created the file/class
  * 1.1       2018-04-18  William Lopez  Added Trigger framework 2.0
  * 2.0       2019-12-02  JF Guilbert    Streamlining changes
  */
public with sharing class Eco_TriggerConfig
{
    public static Map<Schema.SObjectType, Eco_TriggerConfig[]> Configurations { // All the configurations
        get {
            if(Configurations == null) {
                Configurations = new Map<Schema.SObjectType, Eco_TriggerConfig[]>();

                for(Eco_TriggerConfig__mdt cfg : [
                    SELECT Id, DeveloperName, MasterLabel, Active__c, Handler_Name__c, SObject__c,Order__c
                    FROM   Eco_TriggerConfig__mdt
                    ORDER BY Order__c ASC
                ]){
                    Eco_TriggerConfig tc = new Eco_TriggerConfig(cfg);

                    if(!Configurations.containsKey(tc.SObjectType))
                        Configurations.put(tc.SObjectType, new List<Eco_TriggerConfig>());

                    Configurations.get(tc.SObjectType).add(tc);
                }
            }
            return Configurations;
        }
        private set;
    }

    /**
      * @Name          getBySObjectType
      * @Description   Get Trigger Configuration By SObject Type
      * @Author        Fan Yang
      * @CreatedDate   2017-05-09
      * @Param         SObjectType Type
      * @Return        CDC_TriggerConfig
      */
    public static Eco_TriggerConfig[] getBySObjectType(SObjectType pType)
    {
        return Configurations.get(pType);
    }
    /**
      * @Name          getBySObjectName
      * @Description   Get Trigger Configuration By Name
      * @Author        Fan Yang
      * @CreatedDate   2017-05-09
      * @Param         String Name
      * @Return        CDC_TriggerConfig
      */
    public static Eco_TriggerConfig[] getBySObjectName(String pName)
    {
        return getBySObjectType(Schema.getGlobalDescribe().get(pName));
    }

    /**
      * @Name          Eco_TriggerConfig
      * @Description   Private Constructor of class
      * @Author        JF Guilbert
      * @CreatedDate   2019-12-02
      * @Param         Metadata configuration
      * @Return        Eco_TriggerConfig
      */
    @TestVisible
    private Eco_TriggerConfig(Eco_TriggerConfig__mdt pCfg)
    {
        this.Handler     = pCfg.Handler_Name__c;
        this.IsActive    = pCfg.Active__c;
        this.SObjectName = pCfg.SObject__c;
        this.SObjectType = Schema.getGlobalDescribe().get(this.SObjectName);
    }

    public SObjectType SObjectType { get; private set; }
    public Boolean IsActive        { get; private set; }
    public String  Handler         { get; private set; }
    public String  SObjectName     { get; private set; }
}