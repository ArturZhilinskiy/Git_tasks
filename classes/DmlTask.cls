/**
 * Created by User on 17.05.2019.
 */

public class DmlTask {

    public String myFirstName { get; private set; }
    public String myLastName { get; private set; }
    public Id myId { get; private set; }
    public String myCurrency { get; private set; }
    public String myEmail { get; private set; }
    public String myOrganizationName { get; private set; }
    public Date dateToday { get; private set; }
    public Integer availableSoqlCont { get; private set; }

    public DmlTask(){
        myFirstName = UserInfo.getFirstName();
        myLastName = UserInfo.getLastName();
        myId = UserInfo.getOrganizationId();
        myCurrency = UserInfo.getDefaultCurrency();
        myEmail = UserInfo.getUserEmail();
        myOrganizationName = UserInfo.getOrganizationName();
        dateToday = System.today();
        availableSoqlCont = Limits.getLimitQueries();
    }

    public static void addContacts(String contactLastName) {
        List<Contact> myList = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact contact = new Contact(LastName = contactLastName + i);
            myList.add(contact);
        }
        insert myList;
    }

    public static void upsertContacts(String contactLastName, String contactTitle) {

        List<Contact> myList = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact contact = new Contact(LastName = contactLastName + i, Title = contactTitle);
            myList.add(contact);
        }

        for (Contact contact : [SELECT id FROM Contact WHERE LastName Like :contactLastName + '%']) {
            contact.Title = contactTitle;
            myList.add(contact);
        }

        upsert myList;
    }

    public static void deleteLastTenCreatedContacts() {

        List<Contact> myList = [SELECT id FROM Contact ORDER BY CreatedDate DESC LIMIT 10];

        delete myList;
    }

    public static void undeleteDeletedContacts() {

        List<Contact> myList = [SELECT id FROM Contact ORDER BY CreatedDate DESC LIMIT 10 ALL ROWS];

        undelete myList;
    }

    public static void createContactsWithDatabaseClass(String contactLastName) {

        List<Contact> myList = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            if (i < 5) {
                Contact contact = new Contact(LastName = contactLastName + i);
                myList.add(contact);
            }
            if (i >= 5) {
                Contact contact = new Contact(/*LastName = contactLastName + i*/);
                myList.add(contact);
            }
        }
        List<Contact> allCon = [SELECT id FROM Contact];

        Savepoint savepoint = Database.setSavepoint();
        Database.insert(myList, false);
        if (allCon.size() + myList.size() > [SELECT id FROM Contact].size()) {
            System.debug('Call rollback');
            Database.rollback(savepoint);
        }
    }

}