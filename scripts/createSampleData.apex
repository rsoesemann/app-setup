// Query all Opportunity Ids
List<Opportunity> allOpportunities = [SELECT Id FROM Opportunity];

if (allOpportunities.isEmpty()) {
    System.debug('No Opportunities found.');
} else {
    // Query all Accounts that need updating
    List<Account> accountsToUpdate = [SELECT Id, OldField__c FROM Account WHERE OldField__c = NULL];

    // Create a list to store updates
    List<Account> accountsToUpdateList = new List<Account>();

    for (Account acc : accountsToUpdate) {
        // Assign a random Opportunity Id
        Integer randomIndex = Math.floor(Math.random() * allOpportunities.size()).intValue();
        acc.OldField__c = allOpportunities[randomIndex].Id;
        accountsToUpdateList.add(acc);
    }

    // Perform the update if there are records to process
    if (!accountsToUpdateList.isEmpty()) {
        update accountsToUpdateList;
        System.debug(accountsToUpdateList.size() + ' Account records updated successfully.');
    } else {
        System.debug('No Accounts needed updating.');
    }
}
