global class BillDetailsHandler {
    global static String OpportuntiyId {
        get;
        set;
    }
    public List < Data > getData() {
        return BillDetailsHandler.getChartData(OpportuntiyId);
    }
        public Customer getCustomerData() {
        opportunity__c opplst = [SELECT id, Name, OrderNumber__c, LastModifiedDate, TableList__r.name, EmailAddress__c from opportunity__c WHERE Id = :OpportuntiyId limit 1];
        Customer c = new Customer();
        c.Name = opplst.name;
        c.OrderNo = opplst.OrderNumber__c;
        c.TableName = opplst.TableList__r.name;
        c.Email = opplst.EmailAddress__c;
        c.CDate = String.valueof(opplst.LastModifiedDate);
        return c;
    }

    global static List < Data > getChartData(String opd) {
        Map < String,
        String > fldMapings = new Map < String,
        String > ();
        List < Data > data = new List < Data > ();
        List < OrderTaking__c > qplist = [SELECT Name, price__c, Product__r.name, quantity__c from OrderTaking__c WHERE Opportunity__r.id = :opd];
        for (OrderTaking__c qp: qplist) {
            Data d = new Data();
            d.quantity = String.valueof(qp.quantity__c);
            d.product = qp.Product__r.name;
            d.price = String.valueof(qp.price__c);
            data.add(d);
        }
        return data;
    }
global class Data {
        public String Name {
            get;
            set;
        }
        public String price {
            get;
            set;
        }
        public String product {
            get;
            set;
        }
        public String quantity {
            get;
            set;
        }
        public Data() {}
    }

    global class Customer {
        public String Name {
            get;
            set;
        }
        public String CDate {
            get;
            set;
        }
        public String OrderNo {
            get;
            set;
        }
        public String TableName {
            get;
            set;
        }
        public String Email {
            get;
            set;
        }
        public Customer() {}
    }
    

 
}