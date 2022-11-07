@IsTest
public with sharing class PjpServiceTest {
   
   @TestSetup
   static void setupData(){
       
       User usr_gm = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name like '%GM (Beverages)%'].Id,
            LastName = 'gmuser',
            Email = 'sandeep.vishwakarma@skinternational.com',
            Username = 'sandeep@skinternational.com'+ System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Asia/Kolkata',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
           Business_Unit__c ='Beverages'
            );
        insert usr_gm; 
       
       System.debug('User GM '+usr_gm);

         User usr_nkam = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name like '%NKAM (Beverages)%'].Id,
            LastName = 'nkamuser',
            Email = 'sandeep.vishwakarma@skinternational.com',
            Username = 'sandeep@skinternational.com'+ System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Asia/Kolkata',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerID = usr_gm.Id,
             Business_Unit__c ='Beverages'
            );
        insert usr_nkam;
       System.debug('User Nkam '+usr_nkam);
       
         User usr_rkam = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name like '%RKAM (Beverages)%'].Id,
            LastName = 'rkamuser',
            Email = 'sandeep.vishwakarma@skinternational.com',
            Username = 'sandeep@skinternational.com'+ System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Asia/Kolkata',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerID = usr_nkam.Id,
             Business_Unit__c ='Beverages'
            );
        insert usr_rkam;
       System.debug('User rkam '+usr_rkam);
         User usr_bdm = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name like 'BDM%'].Id,
            LastName = 'bdmuser',
            Email = 'sandeep1.vishwakarma@skinternational.com',
            Username = 'sandeep@skinternational.com'+ System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Asia/Kolkata',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerID = usr_rkam.Id,
            Business_Unit__c ='Beverages'
            );
        // UserRoleId=[SELECT Id,Name FROM UserRole WHERE Name like '%bdm%'].Id
        insert usr_bdm;
       System.debug('User bdm '+usr_bdm);

      Zone__c zone_west = new Zone__c(
            Name='West',
            User__c= usr_rkam.Id,
            Zone_SFA_Id__c='001'
      );
      insert zone_west;

        Sub_Zone__c subzone_mumbai = new Sub_Zone__c(
          Name='Mumbai',
          Zone__c=zone_west.Id,
          User__c = usr_bdm.Id,
          Sub_Zone_SFA_Id__c='s02'
      );
      insert subzone_mumbai;
       
      Sub_Zone__c subzone_mumbai_thane = new Sub_Zone__c(
          Name='Mumbai-Thane',
          Zone__c=zone_west.Id,
          User__c = usr_bdm.Id,
          Sub_Zone_SFA_Id__c='1'
      );
      insert subzone_mumbai_thane;

     

      City__c city_bangalore = new City__c(
          Name='Bangalore',
          Sub_Zone__c =subzone_mumbai_thane.Id,
          Zone__c=zone_west.Id,
          City_SFA_Id__c='001'
      );
      insert city_bangalore;

     Area__c area_makali = new Area__c(
        Name='Makali',
        City__c=city_bangalore.Id,
        Sub_Zone__c=subzone_mumbai_thane.Id,
        Zone__c=zone_west.Id,
        Area_SFA_Id__c='001'
     );
    insert area_makali;

    Account acc = new Account(
        Name='Acc',
        Phone='9594216059',
        Area__c=area_makali.Id,
        City__c=city_bangalore.Id,
        Zone__c=zone_west.Id,
        Sub_Zone__c=subzone_mumbai_thane.ID,
        Account_Categorization__c='Regional',
        Classification__c='Volume',
        Sub_Classification__c='B',
        Lead_Segment__c='Dining',
        Lead_Sub_Segment__c='Restaurants',
        Channel__c='HORECA',
        Account_Type__c='Direct'
    );

    insert acc;

     Date myDate = Date.newInstance(2020,4,1);
            Time sTime = Time.newInstance(10, 0, 0, 0);
            Time eTime = Time.newInstance(11, 0, 0, 0);
            DateTime sdt = DateTime.newInstance(myDate, sTime);
            DateTime edt = DateTime.newInstance(myDate, eTime);
            PJP__c pjp = new PJP__c(
                Name='Mar-2020',
                Start_Datetime__c=sdt, 
                End_Datetime__c=edt,
                Status__c='Draft',
                PJP_Prepared_By__c='BDM',
                User__c = usr_bdm.Id
            );
        insert pjp;

        PJP__c pjp_user = new PJP__c(
                Name='Apr-2020',
                Start_Datetime__c=sdt, 
                End_Datetime__c=edt,
                Status__c='Draft',
                PJP_Prepared_By__c='BDM',
                User__c = userinfo.getUserId()
            );
        insert pjp_user;

        // [Select Id,Name,Account__c,Start_Datetime__c,End_Datetime__c,PJP__c,User__c from PJP_Detail__c where PJP__c=:month_id order by Account__c];

        PJP_Detail__c pjp_detail1 = new PJP_Detail__c(
            Name='Pjp1',
            Start_Datetime__c=sdt,
            End_Datetime__c=edt,
            Account__c=acc.Id,
            Status__c='Open',
            PJP__c=pjp.Id,
            Plan_Date__c=sdt.Date(),
            User__c =usr_bdm.Id
        ); 
        insert pjp_detail1;
        PJP_Detail__c pjp_detail2 = new PJP_Detail__c(
            Name='Pjp2',
            Start_Datetime__c=sdt,
            End_Datetime__c=edt,
            Account__c=acc.Id,
            Status__c='Open',
            PJP__c=pjp.Id,
            Plan_Date__c=sdt.Date(),
            User__c =usr_bdm.Id
        ); 
        insert pjp_detail2;

   }

   @IsTest
   static void getAccountList_Test(){
       City__c city_bangalore = [select id,Name from City__c where Name='Bangalore' limit 1];
       Area__C area_makali = [select id,Name from Area__c where Name = 'Makali' limit 1];

       Test.startTest();
       List<Account> acclst1 = PjpService.getAccountList(city_bangalore.Name,'','','');
       List<Account> acclst2 = PjpService.getAccountList('',area_makali.Name,'','');
       List<Account> acclst3 = PjpService.getAccountList(city_bangalore.Name,area_makali.Name,'','');
       List<Account> acclst4 = PjpService.getAccountList('','','','B');
       List<Account> acclst5 = PjpService.getAccountList(city_bangalore.Name,area_makali.Name,'','B');
       List<Account> acclst6 = PjpService.getAccountList(city_bangalore.Name,'','','B');
       List<Account> acclst7 = PjpService.getAccountList('',area_makali.Name,'','B');
        List<Account> acclst8 = PjpService.getAccountList('','','','');

       Test.stopTest();
   }

   @IsTest
   static void getAreaTest(){
        City__c city_bangalore = [select id,Name from City__c where Name='Bangalore' limit 1];
       Test.startTest();
       String city_id = city_bangalore.Id;
        List<Area__c> arealst1 = PjpService.getArea(city_id);
        List<Area__c> arealst2 = PjpService.getArea('');
       List<Area__c> gm_area = PjpService.getAreaforGM();
       Test.stopTest();
   }

   @IsTest
   static void getUserTest(){
       Test.startTest();
        List<User> usrlst = PjpService.getUser();
       Test.stopTest();
   }

   @IsTest
   static void getCurrentUserTest(){
       Test.startTest();
       String uname = PjpService.getCurrentUser();
       Test.stopTest();
   }

   @IsTest
   static void getCityTest(){
       Test.startTest();
         List<City__c> citylst = PjpService.getCity();
       	 List<City__c> gm_city = PjpService.getCityforGM();	
       Test.stopTest();
   }

   @IsTest
   static void getAreaAllTest(){
       Test.startTest();
       List<Area__c> arealst = PjpService.getAreaAll();
       Test.stopTest();
   }

   @IsTest
   static void saveAsDraftTest(){
//        // eventToCreate ["6_001p000000qmw0PAAQ_Feb-2020", "4_001p000000qmw8HAAQ_Feb-2020", "5_001p000000qmw8HAAQ_Feb-2020"]
    Account acc = [select id,Name from Account where Name='Acc'];
    User usrlst = [select id,Name from User where LastName ='bdmuser' limit 1];
    PJP__c pjp = [select id,Name,user__c from PJP__c where Name = 'Mar-2020' and user__c=:usrlst.Id];
    System.debug('pjp and user '+pjp.Name+' '+pjp.User__c);
    String detail1 = '1_'+acc.Id+'_'+pjp.Name;
    String detail2 = '2_'+acc.Id+'_'+pjp.Name;
    String detail3 = '3_'+acc.Id+'_'+pjp.Name;
    List<String> eventTocreatelst = new List<String>();
    eventTocreatelst.add(detail1);
    eventTocreatelst.add(detail2);
    eventTocreatelst.add(detail3);
       Test.startTest();
       try {
           String usrid = usrlst.Id;
      // System.debug('user '+User__c+' Event to create '+eventTocreatelst);
       String result = PjpService.saveAsDraft(eventTocreatelst,usrid);
       String submitforappr = PjpService.submitForApproval(pjp.Id+'');
       } catch (Exception e) {
           System.debug(e.getStackTraceString());
           System.debug(e.getMessage());
       }
       Test.stopTest();
   }

    @IsTest
    static void getFilterList1Test(){
        User usrlst = [select id,Name from User where LastName ='bdmuser' limit 1];
        PJP__c pjp = [select id,Name,user__c from PJP__c where Name = 'Mar-2020'];
        Test.startTest();
        String usrid = usrlst.Id;
        PjpService.getFilterList1('Mar-2020','Sun Mar 01 2020 00:00:00 GMT+0530 (India Standard Time)','Tue Mar 31 2020 00:00:00 GMT+0530 (India Standard Time)',usrid,'BDM');
        PjpService.getFilterList1('Mar-2020','Sun Mar 01 2020 00:00:00 GMT+0530 (India Standard Time)','Tue Mar 31 2020 00:00:00 GMT+0530 (India Standard Time)',usrid,'BDM');
        Map<String,PJP_Detail__c> map1 = new Map<String,PJP_Detail__c>();
        map1 = PjpService.getMonthdetails('Mar-2020',usrid);
        String pjp_name = PjpService.getMonthOnUser(usrid,'Mar-2020');
        List<PJP__c> pjplst = new List<PJP__c>();
        pjplst = PjpService.getpjp(usrid);
        String userbyid = PjpService.getUserbyId(usrid);
        
        String pjpuserid = PjpService.getpjpUserId(pjp.Id+'');
        Test.stopTest();
    }

    @IsTest
    static void getProfileTest(){
        Area__c area1 = [select id,Name from Area__c where Name='Makali'];
         PJP__c pjp = [select id,Name,user__c from PJP__c where Name = 'Mar-2020'];
         List<String> pjpdetail_lst = new List<String>();
         List<PJP_Detail__c> pjpd_lst = [select id,name from PJP_Detail__c];
         System.debug('details lst test'+pjpd_lst);
         for(PJP_Detail__c pd :pjpd_lst )
         {
               pjpdetail_lst.add(pd.Id); 
         }
        Test.startTest();
        String profile = PjpService.getProfile();
        string user_id = PjpService.getUserid();
        String username = PjpService.getUsername();
        User u = [select id,Name from User where Email = 'sandeep1.vishwakarma@skinternational.com' limit 1];
        System.runAs(u){
        	string subzone = PjpService.getSubzone();
        }
        Area__c area = PjpService.getcityOnArea(area1.Id+'');
        List<PJP__c> pjplst = new List<PJP__c>();
        pjplst = PjpService.getMonth();
        PjpService.getMOnthbyId(pjp.Id+'');
        Map<String,String> monthmap = new Map<String,String>();
        monthmap = PjpService.getMonthmap();
        PjpService.deleteDetails(pjpdetail_lst);

        List<Sub_Zone__c> subzone_lst = new List<Sub_Zone__c>();
        subzone_lst = PjpService.getBdmuser();
        List<User> rkamuserlst = new List<User>();
        rkamuserlst = PjpService.getRkamUser();
        List<User> nkamuserlst = new List<User>();
        nkamuserlst = PjpService.getNkamUser();
        List<Zone__c> zonelst = new List<Zone__c>();
        zonelst = PjpService.getZone();
        
        Test.stopTest();
    }

    @IsTest
    static void methodName(){
        Zone__c zonelst = [select id,Name from Zone__c where Name='West'];
        Test.startTest();
        List<City__c> citylst = new List<City__c>();
        List<Area__c> arealst = new List<Area__c>();
        List<Account> acclst = new List<Account>();
        List<string> subclasslst = new List<string>();
        
        citylst =  PjpService.rkmCity(zonelst.id+'');
        arealst =  PjpService.rkmArea(zonelst.id+'');

        acclst = PjpService.getAccountsubclass('B');
        PjpService.getSubclassFromApex();
        subclasslst = PjpService.getSubclassFromApex();
        
        Test.stopTest();
    }

    // @IsTest
    // static void getApproval(){
    //     PJP__c pjp_pending = [select id,Name from PJP__c where Name='Feb-2020'];
    //     Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
	// 	app.setObjectId(pjp_pending.Id);
	// 	Approval.ProcessResult result = Approval.process(app);
	// 	Test.StartTest();
	// 	PjpService.approvePjp(pjp_pending.Id+'','Approve it');
	// 	Class.removeQuoteFromApproval(Quote.id);
	// 	Test.StopTest();
        
    // }

    @IsTest
    static void getApproval(){
    Test.startTest();
    User bdmuser = [select id,LastName from User where LastName = 'bdmuser'];
    User rkamuser = [select id,LastName from User where LastName = 'rkamuser'];
    Date myDate = Date.newInstance(2020,4,1);
            Time sTime = Time.newInstance(10, 0, 0, 0);
            Time eTime = Time.newInstance(11, 0, 0, 0);
            DateTime sdt = DateTime.newInstance(myDate, sTime);
            DateTime edt = DateTime.newInstance(myDate, eTime);
    PJP__c pjp_pending;
    PJP__c pjp_reject;        
    System.runAs(bdmuser){
         pjp_pending = new PJP__c(
                Name='Feb-2020',
                Start_Datetime__c=sdt, 
                End_Datetime__c=edt,
                Status__c='Draft',
                PJP_Prepared_By__c='BDM',
                User__c = bdmuser.Id
            );
        insert pjp_pending;

        pjp_pending.Status__c='Pending';
        update pjp_pending;

        // PjpService.approvePjp(pjp_pending.Id+'','Approve it');

         pjp_reject = new PJP__c(
                Name='Jan-2020',
                Start_Datetime__c=sdt, 
                End_Datetime__c=edt,
                Status__c='Draft',
                PJP_Prepared_By__c='BDM',
                User__c = bdmuser.Id
            );
        insert pjp_reject;

        pjp_reject.Status__c='Pending';
        update pjp_reject;
    }

    System.runAs(rkamuser)
    {
       PjpService.approvePjp(pjp_pending.Id+'','Approve it');
       PjpService.rejectPjp(pjp_reject.Id+'','Reject it');
    }

        Test.stopTest();
    }
    
}