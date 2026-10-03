global class VehicleStockScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(
            new VehicleStockUpdateBatch(),
            200
        );

    }
}