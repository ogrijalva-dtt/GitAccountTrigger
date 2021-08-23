/**
  * @File Name:     Eco_TriggerFactoryTest.cls
  * @Description:
  * @Date Created:  2018-04-18
  * @Author:        William Lopez, wilopez@deloitte.ca
  * @Group:         Apex
  * @Modification Log:
  *-------------------------------------------------------------------------------------
  * Ver       Date        Author      Modification
  * 1.0       2018-04-18  William Lopez    Created the file/class
  * 2.0       2019-12-02  JF Guilbert      Streamlining changes
  */
@isTest
private class Eco_TriggerFactoryTest
{
    private class Eco_TestHandler extends Eco_AbstractTriggerHandler{}

    @isTest
    static void testBase()
    {
        Contact obj = new Contact(LastName = '1', FirstName = '2');
        Map<String, Object> flds = new Map<String, Object>{
            'LastName'    => 'Changed'
            , 'FirstName' => 'ToNew'
        };

        Test.startTest();

        Eco_TestHandler handler = new Eco_TestHandler();

        handler.setFieldValues(obj, flds);
        System.assert(obj.LastName == flds.get('LastName') && obj.FirstName == flds.get('FirstName')
            , 'Expected changes, got :' + JSON.serialize(obj)
        );

        handler.wipeout(obj, new List<String>(flds.keySet()));
        System.assert(String.isBlank(obj.LastName) && String.isBlank(obj.FirstName)
            , 'Expected empty values, got :' + JSON.serialize(obj)
        );

        Test.stopTest();
    }

    @isTest
    static void testTriggerImplementation()
    {
        Contact c = new Contact(LastName = 'Doe');

        Test.startTest();

        Database.insert(c, false);

        c.FirstName = 'Joe';
        Database.update(c, false);

        Database.delete(c, false);

        Test.stopTest();
    }
}