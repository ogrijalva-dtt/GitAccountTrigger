/**
  * @File Name    :   Eco_TriggerFactory
  * @Description  :   Trigger Factory Class
  * @Date Created :   2017-05-09
  * @Author       :   Fan Yang, fanxyang@deloitte.ca
  * @group        :   Interface
  * @Modification Log:
  **************************************************************************************
  * Ver       Date        Author         Modification
  * 1.0       2017-05-09  Fan Yang       Created the file/class
  * 1.1       2018-04-18  William Lopez  Added Trigger framework 2.0
  * 2.1       2018-04-19  William Lopez  Adapted createHandlerAndExecute to be compabile with V1 Logic
  * 3.0       2019-12-02  JF Guilbert    Streamlining changes
  **/
public without sharing class Eco_TriggerFactory
{
    @TestVisible private static Map<Schema.SObjectType, Eco_TriggerConfig[]> TriggerConfigs;
    @TestVisible private static Map<String, Eco_TriggerInterface> TriggerHanlderMap;
    @TestVisible private static Set<Schema.SObjectType> TriggerIgnores;

    static
    {
        TriggerConfigs    = Eco_TriggerConfig.Configurations;
        TriggerIgnores    = new Set<Schema.SObjectType>();
        TriggerHanlderMap = new Map<String, Eco_TriggerInterface>();
    }

    /**
      * @Name          turnOff/On
      * @Description   Manage the state of all triggers, or just specific ones
      * @Author        JF Guilbert
      * @CreatedDate   2019-12-02
      * @Param         Schema.SObjectType soType
      */
    public static void turnOff() { TriggerIgnores.addAll(TriggerConfigs.keySet()); }
    public static void turnOn () { TriggerIgnores.removeAll(TriggerConfigs.keySet()); }

    public static void turnOffFor(Schema.SObjectType pType) { TriggerIgnores.add(pType); }
    public static void turnOnFor (Schema.SObjectType pType) { TriggerIgnores.remove(pType); }

    /**
      * @Name          getHandlers
      * @Description   Version 2.0 Get trigger handlers for sObject
      * @Author        William Lopez
      * @CreatedDate   2018-04-18
      * @Param         Schema.SObjectType soType
      * @Return        Eco_TriggerInterface[]
      */
    @TestVisible
    private static List<Eco_TriggerInterface> getHandlers(Schema.SObjectType soType)
    {
        List<Eco_TriggerInterface> rVal = new List<Eco_TriggerInterface>();
        String cls;

        if(TriggerConfigs.containsKey(soType))
        {
            for(Eco_TriggerConfig cfg : TriggerConfigs.get(soType)) if(cfg.IsActive)
            {
                cls = cfg.Handler;

                if(!TriggerHanlderMap.containsKey(cls))
                    TriggerHanlderMap.put(
                        cls
                        , (Eco_TriggerInterface)Type.forName(cls).newInstance()
                    );

                rVal.add(TriggerHanlderMap.get(cls));
            }
        }
        return rVal;
    }

    /**
      * @Name          createHandlerAndExecute
      * @Description   Version 2.0 Create Trigger handler and execute
      * @Author        Fan Yang
      * @CreatedDate   2017-05-09
      * @Param         Schema.SObjectType soType
      * @Return        void
      */
    public static void createHandlerAndExecute(Schema.SObjectType soType)
    {
        if(!TriggerIgnores.contains(soType))
        {
            for(Eco_TriggerInterface handler : getHandlers(soType)) handler.execute();
        }
    }

    public class TriggerException extends Exception{}
}