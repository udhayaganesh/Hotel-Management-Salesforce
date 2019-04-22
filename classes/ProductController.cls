public class ProductController {
    public Boolean displayPopup {
        get;
        set;
    }
    public String emailAddr {
        get;
        set;
    }

    public String[] MPItems {
        get {
            String[] selected = new List < String > ();
            List < SelectOption > sos = this.MPOptions;
            for (SelectOption s: sos) {
                selected.add(s.getValue());
            }
            return selected;
        }
        set {
            String selectedCheckBox = '';
            for (String s: value) {
                if (selectedCheckBox == '') selectedCheckBox += s;
                else selectedCheckBox += ';' + s;
            }
            selectedValue = selectedCheckBox;
        }
    }

    public List < SelectOption > MPOptions {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            for (Schema.PicklistEntry f: product__c.Family__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(f.getValue(), f.getLabel()));
            }
            return options;
        }
        set;
    }

    public String selectedValue {
        get;
        set;
    }

    public String tableid {
        get;
        set;
    }
    public boolean takeaway {
        get;
        set;
    }
    public String oppid {
        get;
        set;
    }
    public String tableRecID {
        get;
        set;
    }
    public List < wrapOrder > wrapOrderList {
        get;
        set;
    }
    String LongDate;
    public List < OrderTaking__c > PrdctsList {
        get;
        set;
    }
    public List < opportunity__c > oppTakeAwayList {
        get;
        set;
    }

  public PageReference redirectPopup() {
        displayPopup = false;
      system.debug('oppid===>'+oppid);
      system.debug('emailAddr===>'+emailAddr);
      
        if (oppid != null && emailAddr != null) {
            opportunity__c o = [select id, EmailAddress__c from opportunity__c where id = :oppid limit 1];
            o.EmailAddress__c = emailAddr;
            update o;

            TableList__c t = [select id, status__c, Opportunitynew__c from TableList__c where Opportunitynew__c = :oppid limit 1];
            t.status__c = 'Available';
            t.Opportunitynew__c = null;
            update t;

        }
        PageReference pageRef = new PageReference('/apex/TableList');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference sendEmail() {
        displayPopup = true;
        return null;
    }
    public void closePopup() {
        displayPopup = false;
  }
     public ProductController() {
        tableid = ApexPages.currentPage().getparameters().get('aid');
        if (tableid != null && tableid == 'TakeAway') {
            takeaway = true;
            oppTakeAwayList = [select id, stagename__c from opportunity__c where type__c = 'TakeAway'
            and createddate = LAST_N_DAYS: 1];
        }
        else takeaway = false;

        oppid = ApexPages.currentPage().getparameters().get('oppid');
        tableRecID = ApexPages.currentPage().getparameters().get('sid');
        wrapOrderList = new List < wrapOrder > ();
        if (selectedValue == null && selectedValue == '') selectedValue = 'BreakFast';

        getRecord();
        if (oppid == null) {
            TableList__c t = [select id, opportunitynew__c from TableList__c where id = :tableRecID limit 1];

            if (t.opportunitynew__c <>null) {
                oppid = t.opportunitynew__c;
            }
        }
        if (oppid != null) {
            PrdctsList = [select id, Product__r.name, quantity__C, Price__C from OrderTaking__c where Opportunity__r.id = :oppid order by createddate asc];
        }

    }

    public pagereference getRecord() {
        wrapOrderList.clear();
        if (selectedValue == null || selectedValue == '') {
            for (product__c p: [SELECT id, DisplayUrl__c, Name, Price__c From product__c order by DisplayUrl__c nulls last]) {
                wrapOrderList.add(new wrapOrder(p, p.Price__c + ''));
            }
        }
        else {
            String[] arTest = selectedValue.split(';');

            system.debug(arTest);
            for (product__c p: [SELECT id, DisplayUrl__c, Name, Price__c From product__c where Family__c in :arTest order by DisplayUrl__c nulls last]) {
                wrapOrderList.add(new wrapOrder(p, p.Price__c + ''));
            }
        }
        return null;
    }
    public String getLongDate() {
        Datetime cDT = System.now();
        LongDate = cDT.format('EEEE, MMMM d, yyyy');
        return LongDate;
    }
    public pagereference saveOrder() {
        opportunity__c o;
        if (oppid == null) {
            o = new Opportunity__c();
            if (takeaway) {
                o.name = getLongDate() + 'TakeAway';
                o.type__c = 'TakeAway';
            } else {
                o.name = getLongDate();
                o.type__c = 'New Customer';
                o.TableList__c = tableRecID;
            }
            o.stagename__c = 'Ordered';
            insert o;
        }
        else {
            o = [select id from opportunity__c where id = :oppid limit 1];
        }

        Map < String,
        String > mapPrdcts = new Map < String,
        String > ();
        if (wrapOrderList.size() > 0) {
            for (wrapOrder w: wrapOrderList) {
                if (w.selected) {
                    mapPrdcts.put(w.prod.name, w.qty);

                }
            }
        }

        Map < string,
        product__c > mapPrdcts1 = new Map < string,
        product__c > ();
        for (product__c p: [SELECT Id, Name, Family__c, price__C from product__c WHERE(Name IN: mapPrdcts.keyset())]) {
            mapPrdcts1.put(p.Name, p);
        }
        List < OrderTaking__c > oitem = new List < OrderTaking__c > ();
        for (String s: mapPrdcts.keyset()) {
            OrderTaking__c oppPrdcts = new OrderTaking__c();
            oppPrdcts.Opportunity__c = o.Id;
            oppPrdcts.Quantity__c = Integer.valueof(mapPrdcts.get(s));
            system.debug(mapPrdcts1.get(s).Id);
            oppPrdcts.product__c = mapPrdcts1.get(s).Id;
            oppPrdcts.price__c = Double.valueof(mapPrdcts1.get(s).Price__c) * Double.valueof(mapPrdcts.get(s));
            oppPrdcts.status__c = 'New';
            oitem.add(oppPrdcts);

        }
        insert oitem;
        if (!takeaway) {
            TableList__c t = [select id, status__c from TableList__c where id = :tableRecID limit 1];
            t.status__c = 'Serving';
            t.Opportunitynew__c = o.id;
            update t;
        }

        PageReference pageRef = new PageReference('/apex/TableList');
        pageRef.setRedirect(true);
        return pageRef;
    }

    public class wrapOrder {
        public product__c prod {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
        public String qty {
            get;
            set;
        }
        public String price {
            get;
            set;
        }

        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public wrapOrder(product__c a, String unitprice) {
            prod = a;
            selected = false;
            qty = '0';
            price = unitprice;

        }
    }

}