/**
  * @File Name    :   Eco_TriggerInterface
  * @Description  :   Trigger Interface
  * @Date Created :   2017-05-09
  * @Author       :   Fan Yang, fanxyang@deloitte.ca
  * @group        :   Interface
  * @Modification Log:
  **************************************************************************************
  * Ver       Date        Author              Modification
  * 1.0       2017-05-09  Fan Yang            Craeted the file/class
  * 2.0       2019-12-02  JF Guilbert         Streamlining changes
  **/
public interface Eco_TriggerInterface
{
    void bulkBefore();
    void bulkAfter ();
    void andFinally();

    void beforeInsert();
    void beforeUpdate();
    void beforeDelete();

    void afterInsert  ();
    void afterUpdate  ();
    void afterDelete  ();
    void afterUndelete();

    void execute();
}