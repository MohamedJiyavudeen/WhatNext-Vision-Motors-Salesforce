trigger VehicleStockValidation on Vehicle_Order__c (before insert, before update) {

    Set<Id> vehicleIds = new Set<Id>();

    for (Vehicle_Order__c ord : Trigger.new) {
        if (ord.Status__c == 'Pending' && ord.Vehicle__c != null) {
            vehicleIds.add(ord.Vehicle__c);
        }
    }

    Map<Id, Vehicle__c> vehicles = new Map<Id, Vehicle__c>([
        SELECT Id, Stock_Quantity__c
        FROM Vehicle__c
        WHERE Id IN :vehicleIds
    ]);

    for (Vehicle_Order__c ord : Trigger.new) {
        if (ord.Status__c == 'Pending') {

            if (ord.Vehicle__c == null) {
                ord.addError('Please select a vehicle.');
            } else if (vehicles.containsKey(ord.Vehicle__c)) {

                if (vehicles.get(ord.Vehicle__c).Stock_Quantity__c <= 0) {
                    ord.addError('Vehicle is out of stock.');
                }
            }
        }
    }
}