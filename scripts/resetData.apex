// 1) Delete old Accounts created by previous runs of this script
List<Account> oldAccounts = [
    SELECT Id
    FROM Account
    WHERE Name LIKE 'Auto Acc %'
];
delete oldAccounts;

// 2) Get all existing Opportunities in the org
List<Opportunity> existingOpps = [SELECT Id FROM Opportunity];

// 3) Create 10,000 new Accounts
List<Account> newAccounts = new List<Account>();
for (Integer i = 1; i <= 1000; i++) {
    newAccounts.add(new Account(Name = 'Auto Acc ' + i));
}
insert newAccounts;

// 4) Assign each new Account’s OldField__c to a random existing Opportunity
for (Account acc : newAccounts) {
    Integer randomIndex = Math.floor(Math.random() * existingOpps.size()).intValue();
    acc.OldField__c = existingOpps[randomIndex].Id; 
}
update newAccounts;

System.purgeOldAsyncJobs(Date.today()+1);

