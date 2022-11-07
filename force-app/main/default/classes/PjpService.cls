public with sharing class PjpService {
@AuraEnabled
public map<String,String> monthIntMap =new map<String,String>();
public Map<String,String> monthvaluemap = new Map<String,String>();
static List<String> SubclassList = new List<String>();

public PjpService() {
monthIntMap.put('Jan','01');
monthIntMap.put('Feb','02');
monthIntMap.put('Mar','03');
monthIntMap.put('Apr','04');
monthIntMap.put('May','05');
monthIntMap.put('Jun','06');
monthIntMap.put('Jul','07');
monthIntMap.put('Aug','08');
monthIntMap.put('Sep','09');
monthIntMap.put('Oct','10');
monthIntMap.put('Nov','11');
monthIntMap.put('Dec','12');
}
@AuraEnabled(cacheable=true)
public static List<Account> getAccountList(string filter1,String filter2, String filter3,String subclass){
system.debug('filter1--->'+filter1);
system.debug('filter2--->'+filter2);
system.debug('filter3--->'+filter3);
system.debug('subclass--->'+subclass);


if(!String.isBlank(filter1) && String.isBlank(filter2) && String.isBlank(subclass)){//for city
    return [Select id,Name,Sub_Classification__c from Account where City__r.Id=:filter1 and Key_Customer__c!=null and RecordType.Name='Outlet'  and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(String.isBlank(filter1) && !String.isBlank(filter2) && String.isBlank(subclass)){//for Area
    return [Select id,Name,Sub_Classification__c from Account where Area__r.Id=:filter2 and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(!String.isBlank(filter1)&& !String.isBlank(filter2) && String.isBlank(subclass)){//for city and Area
    return [Select id,Name,Sub_Classification__c from Account where City__r.Id=:filter1 and Area__r.Id=:filter2 and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(String.isBlank(filter1) && String.isBlank(filter2) && !String.isBlank(subclass)){ // for class
     return [Select id,Name,Sub_Classification__c from Account where Sub_Classification__c=:subclass and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(!String.isBlank(filter1) && !String.isBlank(filter2) && !String.isBlank(subclass)){ // for city area class
     return [Select id,Name,Sub_Classification__c from Account where City__r.Id=:filter1 and Area__r.Id=:filter2 and Sub_Classification__c=:subclass and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(!String.isBlank(filter1) && String.isBlank(filter2) && !String.isBlank(subclass)){ // for city class
     return [Select id,Name,Sub_Classification__c from Account where City__r.Id=:filter1 and Sub_Classification__c=:subclass and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else if(String.isBlank(filter1) && !String.isBlank(filter2) && !String.isBlank(subclass)){ // for area class
     return [Select id,Name,Sub_Classification__c from Account where Area__r.Id=:filter2 and Sub_Classification__c=:subclass and Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
}else{ // no codition
     List<Account> tempAcc =[Select id,Name,Sub_Classification__c from Account where Key_Customer__c!=null and RecordType.Name='Outlet'   and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name]; 
      //PjpService.SubclassList
    //   for(Account acc:tempAcc){
    //       PjpService.SubclassList.add(acc.Sub_Classification__c);
    //   }
        return tempAcc;
	}
}

@AuraEnabled(cacheable=true)
public static List<Area__c> getArea(String city_id){
    List<Area__c> arealst =  [select id,Name from Area__c where City__r.Id=:city_id];
    if(arealst.size()>0){
        return arealst;
    }else{
        return new List<Area__c>();
    }
}

@AuraEnabled(cacheable=true)
public static List<User> getUser(){
    List<User> userlst =  [select id,Name from User];
    if(userlst.size()>0){
        return userlst;
    }
    else{
        return new List<User>();
    }
}
@AuraEnabled(cacheable=true)
public static List<User> getUserforGM(){
    List<User> userlst =  [select id,Name from User where Profile.Name='BDM (Beverages)' OR Profile.Name='RKAM (Beverages)' OR Profile.Name='NKAM (Beverages)'];
    if(userlst.size()>0){
        return userlst;
    }
    else{
        return new List<User>();
    }
}

@AuraEnabled
public static string getCurrentUser(){
    return UserInfo.getUserId();
}

@AuraEnabled(cacheable=true)
public static List<City__c> getCity(){
    // List<City__c> citylst =  [select id,Name from City__c];
    // return citylst;
     
    List<Sub_Zone__c> lst = [select Id,Name,Zone__c from Sub_Zone__c where User__r.Id=:UserInfo.getUserId() OR Sub_Zone_Manager_Bevrages2__c=:UserInfo.getUserId() ];
    	set<String> zoneIds = new set<String>();
        for(Sub_Zone__c subzone :lst){
        	zoneIds.add(subzone.Zone__c); 
        }
        List<City__c> lstcity = [select Id,Name from City__c where Zone__c in:zoneIds];
        System.debug('city '+lstcity);
        if(lstcity.size()>0){
            return lstcity;
        }else{
            return new List<City__c>();
        }
}

@AuraEnabled(cacheable=true)
public static List<Area__c> getAreaAll(){
    
    List<Sub_Zone__c> lst = [select Id,Name,Zone__c from Sub_Zone__c where User__r.Id=:UserInfo.getUserId() OR Sub_Zone_Manager_Bevrages2__c=:UserInfo.getUserId()];
    set<String> zoneIds = new set<String>();
        for(Sub_Zone__c subzone :lst){
        	zoneIds.add(subzone.Zone__c); 
        }
    	System.debug('lst -->'+lst);
        List<Area__c> lstarea = [select Id,Name from Area__c where Zone__c in:zoneIds];
        System.debug('Area '+lstarea);
        if(lstarea.size()>0){
            return lstarea;
        }else{
            return new List<Area__c>();
        }
}

@AuraEnabled
public static string saveAsDraft(List<String> eventToCreate,String usr_id){
system.debug('save as draft----->'+eventToCreate);
PjpService pjpServiceobj = new PjpService();
 List<PJP_Detail__c> pjp_detailList = new List<PJP_Detail__c>();
for(String s:eventToCreate){
    Integer day = Integer.valueOf(s.split('_')[0]);
    String accountid = s.split('_')[1];
    String mon_name = s.split('_')[2];
    String mon = s.split('_')[2].split('-')[0];
    Integer year1 = Integer.valueOf(s.split('_')[2].split('-')[1]);
    Integer mon1 = Integer.valueOf(pjpServiceobj.monthIntMap.get(mon));
    Date myDate = Date.newInstance(year1,mon1,day);
    Time sTime = Time.newInstance(10, 0, 0, 0);
    Time eTime = Time.newInstance(11, 0, 0, 0);
    DateTime sdt = DateTime.newInstance(myDate, sTime);
    DateTime edt = DateTime.newInstance(myDate, eTime);
    PJP__c pjpc = [select Id,Name from PJP__c where Name=:mon_name and User__r.Id=:usr_id limit 1];
    System.debug('pjpc '+pjpc);
    PJP_Detail__c  pd = new PJP_Detail__c(Name='pjp_'+String.valueOf(day)+'-'+mon_name,Start_Datetime__c=sdt,End_Datetime__c=edt,Account__c=accountid,PJP__c=pjpc.Id,Plan_Date__c=myDate,User__c=UserInfo.getUserId());
    pjp_detailList.add(pd);
}
upsert pjp_detailList;
if(pjp_detailList.size()>0){
    return 'updated';
}else{
    return 'failed';
}
} 
@AuraEnabled
public static string submitForApproval(String pjp_id){
    List<PJP__c> lstpjp = [select Id,Name from PJP__C where Id=:pjp_id limit 1];
    if(lstpjp.size()>0)
    {
        lstpjp[0].Status__c ='Pending';
        update lstpjp;
        return lstpjp[0].Status__c;
    }else {
        return 'some thing wrong happen';   
    }
}
@AuraEnabled
public static String getFilterList1(String currentMonth,String startDate, String endDate,String usr_id,String profilename){
system.debug(' currentMonth-> '+currentMonth+' startDate-> '+startDate+' endDate '+endDate);
List<PJP__c> pjpMasterList;
Boolean isMasterCreated;
String nextMonth;
system.debug('currentMonth-----> '+startDate.split(' ')[0]+' ===== '+startDate.remove(startDate.split(' ')[0]));
system.debug('startDate 1 -->'+startDate.split(' ')[1]);
system.debug('startDate 2 -->'+startDate.split(' ')[2]);
system.debug('startDate 3 -->'+startDate.split(' ')[3]);
system.debug('endDate 1 -->'+endDate.split(' ')[1]);
system.debug('endDate 2 -->'+endDate.split(' ')[2]);
system.debug('endDate 3 -->'+endDate.split(' ')[3]);
pjpMasterList = new List<PJP__c>();
pjpMasterList  = [SELECT Id, Name, Start_Datetime__c, End_Datetime__c, Status__c, Approved_By__c FROM PJP__c where Name=:currentMonth and User__r.Id=:UserInfo.getUserId()];

if(pjpMasterList.size()>0){
    //create Master for next month i.e.
    isMasterCreated = true;  
}else{
    //load master for next month
    isMasterCreated = false;
}
if(!isMasterCreated){
    //create master data
PjpService PjpServiceObj = new PjpService();

    PJP__c pjp = new PJP__c();
    system.debug('@@@month Map '+PjpServiceObj.monthIntMap);
    system.debug('@@@month Map '+PjpServiceObj.monthIntMap.get(startDate.split(' ')[1]));
    pjp.Name = currentMonth;

  
   String newSDate = startDate.split(' ')[3]+'-'+startDate.split(' ')[2]+'-'+PjpServiceObj.monthIntMap.get(startDate.split(' ')[1])+' 14:00 00';
   String newEDate = PjpServiceObj.monthIntMap.get(endDate.split(' ')[1])+'-'+endDate.split(' ')[2]+'-'+endDate.split(' ')[3]+' 14:00 00';
  
 
DateTime dt = DateTime.newInstance(Integer.valueOf(startDate.split(' ')[3]), Integer.valueOf(PjpServiceObj.monthIntMap.get(startDate.split(' ')[1])), Integer.valueOf(startDate.split(' ')[2]), 12, 0, 0);
DateTime dt2 = DateTime.newInstance(Integer.valueOf(endDate.split(' ')[3]), Integer.valueOf(PjpServiceObj.monthIntMap.get(endDate.split(' ')[1])), Integer.valueOf(endDate.split(' ')[2]), 12, 0, 0);
  system.debug('@@ newSDate '+dt);
   system.debug('@@ newEDate2 '+dt2);
//DateTime dt2 = DateTime.valueOf(newEDate);
  
    pjp.Start_Datetime__c = dt;
    pjp.End_Datetime__c = dt2;
    pjp.Status__c = 'Draft';
    pjp.User__c = UserInfo.getUserId();
    pjp.PJP_Prepared_By__c = profilename;
    insert pjp;
    System.debug('PJP inserted --------->'+pjp.Name);
    return pjp.Name;
}else{
system.debug('isMasterCreated------------> '+isMasterCreated);
return '';
}
}

@AuraEnabled(cacheable=true)
public static String getProfile(){
    List<profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()];
    return profile[0].Name;
} 

@AuraEnabled(cacheable=true)
public static string getUserid(){
    return UserInfo.getUserId();
}

@AuraEnabled
public static string getUsername(){
    return UserInfo.getName();
}

@AuraEnabled
public static string getSubzone(){
    List<Sub_Zone__c> lst = [select Id,Name from Sub_Zone__c where User__r.Id=:UserInfo.getUserId() OR Sub_Zone_Manager_Bevrages2__c=:UserInfo.getUserId()];
    return lst[0].Name;
}

@AuraEnabled
public static Area__c getcityOnArea(String area_id){
    System.debug('Area Id '+area_id);
    Area__c lst = [select Id,Name,City__c,City__r.Name from Area__c where Id =:area_id];
    return  lst;
}

@AuraEnabled
public static List<PJP__c> getMonth(){
    List<PJP__c> month = [Select Id,Name,Status__c,Start_Datetime__c from PJP__c where User__r.Id=:UserInfo.getUserId() order by Start_Datetime__c asc];
    if(month.size()>0){
    return month;
    }else{
    return new List<PJP__c>();    
    }
}

@AuraEnabled
public static List<PJP__c> getMOnthbyId(String mon_id){
    List<PJP__c> month = [Select Id,Name,Status__c,Start_Datetime__c, PJP_Prepared_By__c from PJP__c where Id=:mon_id and Name!=null order by Start_Datetime__c asc];
    if(month.size()>0){
    return month;
    }else{
    return new List<PJP__c>();    
    }
}

@AuraEnabled
public static string getMonthOnUser(String usr_id,String mon_name){
    List<PJP__c> pjplst = [select Id,Name,Start_Datetime__c from PJP__c where User__r.Id=:usr_id and Name=:mon_name order by Start_Datetime__c asc limit 1];
    if(pjplst.size()>0)
    {
        return pjplst[0].Id;
    }else{
        return 'data';
    }
    
}

// @AuraEnabled
// public static List<PJP_Detail__c> getMonthdetails(String month_id){
//     return [Select Id,Name,Account__c,Start_Datetime__c,End_Datetime__c,PJP__c,User__c from PJP_Detail__c where PJP__c=:month_id order by Account__c];
// }


@AuraEnabled
public static Map<String,PJP_Detail__c> getMonthdetails(String month_value,String usr_id){

System.debug('Month details '+month_value);
  PjpService PjpServiceObj = new PjpService();
        List<PJP__c> pjplst = [Select Id,Name from PJP__c where User__r.Id=:usr_id];
        System.debug('current user '+UserInfo.getUserId()+' Name'+UserInfo.getFirstName());
    	for(PJP__c pjp:pjplst)
    	{
        	PjpServiceObj.monthvaluemap.put(pjp.Name,pjp.Id);

    	}

  System.debug(PjpServiceObj.monthvaluemap.get(month_value)); //
  System.debug('Monthvalue map '+PjpServiceObj.monthvaluemap); 
  String month_id =  PjpServiceObj.monthvaluemap.get(month_value);
  System.debug('Month id '+month_id);  
  Map<String,PJP_Detail__c> mapcheckbox = new Map<String,PJP_Detail__c>();
    	String str;
        String temp1;
        String temp2;
        List<PJP_Detail__c> pjp_detailList = [Select Id,Name,Account__c,Start_Datetime__c,End_Datetime__c,PJP__c,User__c from PJP_Detail__c where PJP__c=:month_id order by Account__c];
		System.debug('pjp details '+pjp_detailList);
       for(PJP_Detail__c  pjpd: pjp_detailList){
           Datetime dt = (DateTime)pjpd.Start_Datetime__c;
            System.debug(dt.day());
              mapcheckbox.put(dt.day()+'_'+pjpd.Account__c,pjpd);
       }
       System.debug('Month details '+mapcheckbox);
    return mapcheckbox;    
}

@AuraEnabled
public static Map<String,String> getMonthmap(){
    
    Map<String,String> monthmap = new Map<String,String>();
    List<PJP__c> pjplst = [Select Id,Name from PJP__c where User__r.Id=:UserInfo.getUserId()];

    for(PJP__c pjp:pjplst)
    {
        monthmap.put(pjp.Name,pjp.Id);
    }
    System.debug('month map '+monthmap);
    return monthmap;
}

@AuraEnabled
public static void deleteDetails(List<String>  lst){
    System.debug('lst '+lst);
    List<PJP_Detail__c> pjp_detailList = [Select Id,Name,Account__c,Start_Datetime__c from PJP_Detail__c where Id IN:lst];
   if(pjp_detailList.size()>0){
    delete pjp_detailList;
    }
}

@AuraEnabled
public static List<Sub_Zone__c> getBdmuser(){
    //  List<Profile> bdm_id = [SELECT Id,Name FROM Profile WHERE Name like '%BDM%' limit 1];
    //  return [select Id,Name from User where ProfileId =:bdm_id[0].Id];
    Map<ID,Zone__c> lstzone = new Map<ID, Zone__c>([select Id,Name from Zone__c where User__r.Id=:UserInfo.getUserId()]);
     List<Sub_Zone__c> lst = [select Id,Name,User__c,User__r.Id,User__r.Name,Sub_Zone_Manager_Bevrages2__c,Sub_Zone_Manager_Bevrages2__r.Name from Sub_Zone__c where Zone__r.Id IN:lstzone.keyset() and (User__r.Id!=null OR Sub_Zone_Manager_Bevrages2__c!=null)];
     if(lst.size()>0){
         return lst;
    }else{
        return new List<Sub_Zone__c>();
    }
}

@AuraEnabled
public static List<User> getRkamUser(){
     List<Profile> rkam_id = [SELECT Id,Name FROM Profile WHERE Name like '%RKAM%' limit 1];
     return [select Id,Name from User where ProfileId =:rkam_id[0].Id];
}

@AuraEnabled
public static List<User> getNkamUser(){
     List<Profile> gm_id = [SELECT Id,Name FROM Profile WHERE Name like '%NKAM%' limit 1];
     return [select Id,Name from User where ProfileId =:gm_id[0].Id];
}


@AuraEnabled
public static List<Zone__c> getZone(){
    List<Zone__c> lstzone = [select Id,Name from Zone__c where User__r.Id=:UserInfo.getUserId() and Id!=null];
    if(lstzone.size()>0){
    return lstzone;
    }else{
        return new List<Zone__c>();
    }
}

@AuraEnabled
public static List<City__c> rkmCity(String zone){
    return [SELECT Id, Name FROM City__c where Zone__r.Id=:zone];
}

@AuraEnabled
public static List<Area__c> rkmArea(String zone){
    return [SELECT Id, Name FROM Area__c where Zone__r.Id=:zone];
}

@AuraEnabled
public static List<PJP__c> getpjp(string usr_id){
    return [select Id,Name,Status__c,User__r.Name,Start_Datetime__c,PJP_Prepared_By__c from PJP__c where User__r.Id=:usr_id order by Start_Datetime__c asc];
}
@AuraEnabled
public static List<Account> getAccountsubclass(String str){
    return [select Id,Name,Sub_Classification__c from Account where Sub_Classification__c=:str and Key_Customer__c!=null and RecordType.Name='Outlet'  and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved')  order by Name ];
}

@AuraEnabled
public static string getUserbyId(String usr_id){
    List<User> usrlst = [select Id,Name from User where Id=:usr_id limit 1];
    if(usrlst.size()>0)
    {
        return usrlst[0].Name;
    }else{return ''; }
}

@AuraEnabled
public static Boolean approvePjp(String pjp_id,String comment){
 System.debug('pjp to approve id '+pjp_id); 
 System.debug('Comment value '+comment);  
List<ProcessInstanceWorkitem> workItems = [
    SELECT Id, ProcessInstanceId 
    FROM ProcessInstanceWorkitem 
    WHERE ProcessInstance.TargetObjectId = :pjp_id 
  ];
  System.debug('Workitem id '+workItems[0].Id);
List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
for(ProcessInstanceWorkitem workItem : workItems){
  Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
  
  req.setWorkitemId(workItem.Id);
  //Valid values are: Approve, Reject, or Removed. 
  //Only system administrators can specify Removed.
  req.setAction('Approve');
  req.setComments(comment);
  requests.add(req);
  System.debug('req '+req);
}
   Approval.ProcessResult[] processResults;
try{
   processResults = Approval.process(requests);
}catch(DmlException dml){
    System.debug('Exp '+dml.getCause()+'-----'+dml.getMessage()+'----->'+dml.getStackTraceString());
}
System.debug('Results '+processResults);
if(processResults.size() > 0)
{
    System.debug('Success');
    return true;
}else{
    System.debug('Failed to Approve Record');
    return false;
}

}

@AuraEnabled
public static Boolean rejectPjp(String pjp_id,String comment){
     System.debug('Comment value '+comment); 
  List<ProcessInstanceWorkitem> workItems = [
    SELECT Id, ProcessInstanceId 
    FROM ProcessInstanceWorkitem 
    WHERE ProcessInstance.TargetObjectId = :pjp_id 
  ];
List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
for(ProcessInstanceWorkitem workItem : workItems){
  Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
  req.setWorkitemId(workItem.Id);
  //Valid values are: Approve, Reject, or Removed. 
  //Only system administrators can specify Removed.
  req.setAction('Reject');
  req.setComments(comment);
  requests.add(req);
}
Approval.ProcessResult[] processResults = Approval.process(requests);
System.debug('Results '+processResults);
if(processResults.size() >0)
{
    System.debug('Success');
    return true;
}else{
    System.debug('Failed to Approve Record');
    return false;
} 
}

@AuraEnabled
public static List<string> getSubclassFromApex(){
  Set<String> myset = new set<string>(); 
  List<String> subclasslst =  new List<String>();  
  List<Account> acclst = [Select Id,Name,Sub_Classification__c from Account where Key_Customer__c!=null and RecordType.Name='Outlet'  and (Status__c = 'Active' OR Status__c = 'Approved' OR Status__c = 'Auto Approved') order by Name];
  for(Account a:acclst){
      if(myset.add(a.Sub_Classification__c))
      {
          subclasslst.add(a.Sub_Classification__c);
      }
  }
  return subclasslst;
}
@AuraEnabled
public static string getpjpUserId(String pjp_id){
    List<PJP__c> pjpuserIdlst = [Select id,Name,CreatedById from PJP__c where id=:pjp_id];
    if(pjpuserIdlst.size()>0)
    {
        return pjpuserIdlst[0].CreatedById;
    }else{
        return '';
    }
}
@AuraEnabled
public static List<City__c> getCityforGM(){
    List<City__c> lst_city = [select id,Name from City__c];
    return lst_city;
}
@AuraEnabled
public static List<Area__c> getAreaforGM(){
    List<Area__c> lst_area = [select id,Name from Area__c];
    return lst_area;
}

// @AuraEnabled
// public static List<Event> getEvents(String usr_id){
//     List<Event> lstevt = new List<Event>();
//     if(usr_id==''){
//     for(Event e :[SELECT Id, OwnerId, Subject, StartDateTime, EndDateTime FROM Event where OwnerId=:UserInfo.getUserId()]){
//         Integer offset = UserInfo.getTimezone().getOffset(e.StartDateTime);
//         Event evt = new Event();
//         evt.Id = e.Id;
//         evt.OwnerId = e.OwnerId;
//         evt.Subject = e.Subject;
//         evt.StartDateTime = e.StartDateTime.addSeconds(offset/1000);
//         evt.EndDateTime = e.EndDateTime.addSeconds(offset/1000);

//         lstevt.add(evt);
//     }
//     return lstevt;        
//     }else{
//         return new List<Event>();
//     }    
// }

// @AuraEnabled
// public static String addEvent(String Subject,String OwnerId,String StartDateTime,String Type,String EndDateTime,String Agenda,String Complaint_Type,String Comments,List<String> WhoId,String WhatId,String Next_Step_Date,String Next_Step_Description,String Activity_Type,String Activity_Status){
//     String eventcreated = '';
//     try {
//         //  Fri Mar 20 2020 05:30:00 GMT+0530 (India Standard Time)
//         System.debug('Start date '+StartDateTime);

//         PjpService PjpServiceObj = new PjpService();
//         Integer day1 = Integer.valueOf(StartDateTime.split(' ')[2]);
//         System.debug('Day '+day1);
//         Integer month1 = Integer.valueOf(PjpServiceObj.monthIntMap.get(StartDateTime.split(' ')[1]));
//         System.debug('month1 '+month1);
//         Integer year1 = Integer.valueOf(StartDateTime.split(' ')[3]);
//         System.debug('year1 '+year1);
//         Integer hr1 = Integer.valueOf(StartDateTime.split(' ')[4].split(':')[0]);
//         System.debug('hr1 '+hr1);
//         Integer min1 = Integer.valueOf(StartDateTime.split(':')[1]);
//         System.debug('min1 '+min1);
//         Integer sec1 = Integer.valueOf(StartDateTime.split(' ')[4].split(':')[2]);
//         System.debug('sec1 '+sec1);

//         Integer day2 = Integer.valueOf(StartDateTime.split(' ')[2]);
//         Integer month2 = Integer.valueOf(PjpServiceObj.monthIntMap.get(StartDateTime.split(' ')[1]));
//         Integer year2 = Integer.valueOf(StartDateTime.split(' ')[3]);
//         Integer hr2 = Integer.valueOf(StartDateTime.split(' ')[4].split(':')[0]);
//         Integer min2 = Integer.valueOf(StartDateTime.split(':')[1]);
//         Integer sec2 = Integer.valueOf(StartDateTime.split(' ')[4].split(':')[2]);
        
//         // Integer day3 = Integer.valueOf(Next_Step_Date.split(' ')[2]);
//         // Integer month3 = Integer.valueOf(PjpServiceObj.monthIntMap.get(Next_Step_Date.split(' ')[1]));
//         // Integer year3 = Integer.valueOf(Next_Step_Date.split(' ')[3]);

//         DateTime sdt = DateTime.newInstance(year1, month1, day1, hr1, min1, sec1);
//         DateTime edt = DateTime.newInstance(year2, month2, day2, hr2, min2, sec2);
//         // Date next_stepDate = Date.newInstance(year3, month3, day3);
//         System.debug('Date Time '+sdt);
//         System.debug('Agenda '+Agenda);
//         System.debug('TYpe '+Type);

//         // List<Id> conid = new List<Id>();
//         // List<Contact> conlst = [select id,Name from Contact where id in:WhoId];
//         // for(Contact con:conlst){
//         //     conid.add(con.Id);
//         // }
//         // System.debug('Contact Id '+conid);

//         if(Type=='none'){
//             Type = '';
//         }
//         if(Agenda=='none'){
//             Agenda = '';
//         }
//         if(Complaint_Type=='none'){
//             Complaint_Type = '';
//         }
//         if(Activity_Type=='none'){
//             Activity_Type = '';
//         }
//         if(Activity_Status=='none'){
//             Activity_Status = '';
//         }



//         Event evt = new Event();
//         evt.Subject = Subject;
//         evt.OwnerId = ID.valueOf(OwnerId);
//         evt.StartDateTime = sdt;
//         evt.Type = Type;
//         evt.EndDateTime = edt;
//         evt.Agenda__c = Agenda;
//         evt.Complaint_Type__c = Complaint_Type;
//         evt.Comments__c = Comments ;
//         // //evt.WhoId = WhoId ;
//         // //evt.WhatId = WhatId;
//         // evt.Next_Step_Date__c = next_stepDate;
//         evt.Next_Step_Description__c = Next_Step_Description; 
//         evt.Activity_Type__c = Activity_Type;
//         evt.Activity_Status__c = Activity_Status; 
//         insert evt;
//         eventcreated = evt.Id;
//         System.debug('Event created'+evt.Id);    
//         System.debug('Event created'+evt);
//     } catch (Exception e) {
//         System.debug('Exception while aadding event'+ e.getDmlFieldNames(0));
//     }
//     return eventcreated;
// }

}