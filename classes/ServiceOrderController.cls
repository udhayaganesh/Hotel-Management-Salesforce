public with sharing class ServiceOrderController {

    public List < resultOrder > takeawayroList {
        get;
        set;
    }

    public List < resultOrder > roList {
        get;
        set;
    }
    public class resultOrder {
        public String tableName {
            get;
            set;
        }
        public String opprID {
            get;
            set;
        }
        public List < OrderTaking__c > ot {
            get;
            set;
        }

        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public resultOrder(String name, String oppid, List < OrderTaking__c > o) {
            tableName = name;
            opprID = oppid;
            ot = o;

        }
    }

    Public String updateOppId {
        get;
        set;
    }
    Public String updatetableID {
        get;
        set;
    }

    Public List < OrderTaking__c > opp {
        get;
        set;
    }
    Public List < OrderTaking__c > takeawayopp {
        get;
        set;
    }
    Public List < string > oppStr = new List < string > ();

    public PageReference deliver() {
        if (updateOppId != null) {
            List < OrderTaking__c > updateOrder = new List < OrderTaking__c > ();
            List < TableList__c > updateTab = [select id, status__C from TableList__c where name = :updatetableID limit 1];
            system.debug('updateTab -->' + updateTab);
            if (updateTab != null && updateTab.size() > 0) {
                for (TableList__c t: updateTab) {
                    t.status__C = 'ReadyForBill';
                    update t;
                }
            }
            else if (updateTab == null || updateTab.size() == 0) {
                List < opportunity__c > o = [select id, stagename__C from opportunity__c where id = :updateOppId limit 1];
                system.debug('Take away' + o);
                for (opportunity__c o1: o) {
                    o1.stagename__C = 'Delivered';
                    update o1;
                }
            }
            List < OrderTaking__c > ot = [select id, status__c from OrderTaking__c where opportunity__r.id = :updateOppId];
            for (OrderTaking__c order: ot) {
                order.status__c = 'Delivered';
                updateOrder.add(order);
            }
            if (updateOrder.size() > 0) update updateOrder;

        }
        PageReference pageRef = new PageReference('/apex/ServiceOrder');
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference incrementCounter() {
        roList = new List < resultOrder > ();
        takeawayroList = new List < resultOrder > ();
        opp = new List < OrderTaking__c > ();
        List < TableList__c > t = [select id, name, opportunitynew__r.id, status__c from TableList__c where Status__c = 'Serving'];
        for (TableList__c t1: t) {
            opp = [select id, name, Product__r.name, quantity__C, Price__C from OrderTaking__c
            where opportunity__r.id = :t1.opportunitynew__r.id and opportunity__r.type__c = 'New Customer'
            order by createddate desc];
            resultOrder r = new resultOrder(t1.name, t1.opportunitynew__r.id + '', opp);
           roList.add(r);

        }
        system.debug(oppStr);

        List < opportunity__c > oppt = [select id, OrderNumber__c, type__c from opportunity__c where type__c = 'TakeAway'
        and stagename__c <>'Delivered'
        and createddate = LAST_N_DAYS: 1];
        for (opportunity__c op1: oppt) {
            takeawayopp = [select id, Product__r.name, quantity__C, Price__C from OrderTaking__c where opportunity__r.id = :op1.id order by createddate desc];
            resultOrder r = new resultOrder(op1.OrderNumber__c, op1.id + '', takeawayopp);
            takeawayroList.add(r);
        }
        return null;
    }

}