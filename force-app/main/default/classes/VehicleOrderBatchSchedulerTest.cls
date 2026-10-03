@isTest
private class VehicleOrderBatchSchedulerTest {

    @isTest
    static void testScheduler() {

        Test.startTest();

        String cronExp = '0 0 0 1 1 ? 2099';

        System.schedule(
            'Test Vehicle Order Scheduler',
            cronExp,
            new VehicleOrderBatchScheduler()
        );

        Test.stopTest();
    }
}