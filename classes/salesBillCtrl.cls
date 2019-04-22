public class salesBillCtrl{


  public boolean printpdf {
    get;
    set;
  }
  public boolean qty2{
    get;
    set;
  }
  public String roomno {
    get;
    set;
  }
  public Decimal tax  {
    get;
    set;
  }
  public Decimal total {
    get;
    set;
  }

  public salesbill__c billing{
    get;
    set;
  }

  public salesproduct__c billProd {
    get;
    set;
  }


  public salesBillCtrl(ApexPages.StandardController controller) {
    String recID = ApexPages.currentPage().getparameters().get('id');
    String pdf= ApexPages.currentPage().getparameters().get('printpdf');
    if(pdf=='true')
    {
     printpdf= true;
    }
    else
    {
     printpdf =false;
     }
    if(recID != null)
    {
        printpdf = true;
        billing = [select id,name,Invoice_Date__c,Invoice_Number__c,Seller_Address__c,Seller_Name__c,Total_Amount__c from salesbill__c where id =: recID];
        billProd = [select id,  name,Shipping_Charges__c , Total_Prod2__c ,Total_Prod1__c ,Grant_Total__c ,grant_tax__c, NetAmount2__c,NetAmount1__c,
Product_Name1__c    ,Product_Name2__c,Quantity1__c,Quantity2__c,salesbill__c,Tax_Rate1__c,Tax_Rate2__c,Tax_Type1__c,Tax_Type2__c,Unit_Price1__c,Unit_Price2__c  from salesproduct__c where salesbill__c = : recID ]; 
        if(billProd.Quantity2__c == null)
           qty2 = false;
         else
           qty2 = true;
         
    }
    else
    {
    qty2 = true;
    printpdf = false;
    billing = new salesbill__c();
    billProd = new salesproduct__c();
   // billing.Room_Link__c = ApexPages.currentPage().getparameters().get('sid');
    }
  }

  public PageReference saveRecord() {
     String recordID = ApexPages.currentPage().getparameters().get('id');
     
    if(recordID == null){
     
   
    salesbill__c cd = new salesbill__c ();
    cd.Invoice_Date__c = billing.Invoice_Date__c ;
    cd.Invoice_Number__c= billing.Invoice_Number__c  ;
    cd.Seller_Address__c = billing.Seller_Address__c ;
    cd.Seller_Name__c= billing.Seller_Name__c;
    cd.Total_Amount__c = billing.Total_Amount__c ;
    insert cd;
    
     
    salesproduct__c sp = new salesproduct__c();
    sp.salesbill__c = cd.id;
    sp.Product_Name1__c = billProd.Product_Name1__c;
    sp.Product_Name2__c = billProd.Product_Name2__c;  
    sp.Quantity1__c = billProd.Quantity1__c;
    sp.Quantity2__c = billProd.Quantity2__c;
    sp.Shipping_Charges__c = billProd.Shipping_Charges__c;
    Decimal tax1,tax2;
    if(billProd.Unit_Price2__c != null && billProd.Unit_Price2__c != 0.00 && billProd.Quantity2__c !=null)
    {
    tax2 = (billProd.Unit_Price2__c * billProd.Quantity2__c * 12) /100;
    sp.Tax_Rate2__c = tax2;
    sp.Tax_Type2__c = 'GST';
    sp.Unit_Price2__c = billProd.Unit_Price2__c ;
    sp.Total_Prod2__c = billProd.Unit_Price2__c + tax2;
    
    }
    if(billProd.Unit_Price1__c != null)
    {
    tax1 = (billProd.Unit_Price1__c * billProd.Quantity1__c * 12) /100;
    sp.Tax_Rate1__c = tax1;
    sp.Tax_Type1__c = 'GST';
    sp.Unit_Price1__c = billProd.Unit_Price1__c;
    sp.Total_Prod1__c = (billProd.Unit_Price1__c * billProd.Quantity1__c ) + tax1;
    
    sp.Grant_Total__c =( billProd.Unit_Price1__c * billProd.Quantity1__c ) + tax1;
    
    }
    if(billProd.Unit_Price2__c != null)
    {
    sp.Grant_Total__c = (billProd.Unit_Price2__c * billProd.Quantity2__c )+ tax2 +(billProd.Unit_Price1__c * billProd.Quantity1__c ) + tax1;
    }
    insert sp; 
     
     
    Pagereference pg = new Pagereference('/apex/salesbill?id='+cd.id);
    pg.setredirect(true);
    return pg;
    }
    else
    {
    update billing;
    update billProd;
    Pagereference pg = new Pagereference('/apex/salesbill?id='+recordID );
    pg.setredirect(true);
    return pg;
        
    }
  }
public PageReference newRecord() {

    /*Id roomno = billing.Room_Link__r.id;
    billing.Deal__c='Checked-Out';
    update billing;
    Room_List__c roomLs = [select id,status__c from Room_List__c where id =: roomno];
    roomLs.status__c ='Available';
    roomLs.Current_billing__c= '';
    update roomLs;
    */
    PageReference p = new PageReference('/apex/salesbill');
    p.setRedirect(true);
    return p;
  }
  
  public PageReference savePrint() {
   String recordID = ApexPages.currentPage().getparameters().get('id');
     
    if(recordID == null){
     
   /*
    salesbill__c cd = new salesbill__c ();
    cd.Invoice_Date__c = billing.Invoice_Date__c ;
    cd.Invoice_Number__c= billing.Invoice_Number__c  ;
    cd.Seller_Address__c = billing.Seller_Address__c ;
    cd.Seller_Name__c= billing.Seller_Name__c;
    cd.Total_Amount__c = billing.Total_Amount__c ;
    insert cd;
    
     
    salesproduct__c sp = new salesproduct__c();
    sp.salesbill__c = cd.id;
    sp.Product_Name1__c = billProd.Product_Name1__c;
    sp.Product_Name2__c = billProd.Product_Name2__c;  
    sp.Quantity1__c = billProd.Quantity1__c;
    sp.Quantity2__c = billProd.Quantity2__c;
    sp.Tax_Rate1__c = billProd.Tax_Rate1__c;
    sp.Tax_Rate2__c = billProd.Tax_Rate2__c;
    sp.Tax_Type1__c = billProd.Tax_Type1__c;
    sp.Tax_Type2__c = billProd.Tax_Type2__c;
    sp.Unit_Price1__c = billProd.Unit_Price1__c;
    sp.Unit_Price2__c = billProd.Unit_Price2__c ;
    insert sp; 
     
     
    Pagereference pg = new Pagereference('/apex/salesbill?id='+cd.id+'&printpdf=true&renderAs=pdf');
    pg.setredirect(true);
    return pg;*/
    return null;
    }
    else
    {
    update billing;
    update billProd;
    Pagereference pg = new Pagereference('/apex/salesbill?id='+recordID+'&printpdf=true&renderAs=pdf' );
    pg.setredirect(true);
    return pg;
        
    }
  }
 
}