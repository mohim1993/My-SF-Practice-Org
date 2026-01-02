trigger CarOrderExecutionTrigger on Car__c (
    before insert,
    after insert
) {

    // -----------------------------------
    // BEFORE TRIGGER
    // -----------------------------------
    if (Trigger.isBefore) {
        for (Car__c car : Trigger.new) {
            system.debug('BEFORE TRIGGER');
            // Avoid recursion — do nothing if flagged
           

            car.Order_of_Execution__c = 'Before Trigger Executed';
            //car.Tested__c = true; // mark to stop recursion
        }
    }

    // -----------------------------------
    // AFTER TRIGGER
    // -----------------------------------
    if (Trigger.isAfter) {
        
        List<Car__c> carsToUpdate = new List<Car__c>();

        for (Car__c car : Trigger.new) {
			 system.debug('AFTER TRIGGER');
            // Skip records already processed
           

            // Must create a new instance in AFTER trigger
            Car__c carUpdate = new Car__c(
                Id = car.Id,
                Order_of_Execution__c = 'After Trigger Executed'
                //Tested__c = true // prevent recursion
            );

            carsToUpdate.add(carUpdate);
        }

        if (!carsToUpdate.isEmpty()) {
            update carsToUpdate;
        }
    }
}