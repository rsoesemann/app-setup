@IsTest
private class SetupBackendConnection_Test {

    @IsTest
    private static void execute() {

        // Setup
        Exception unexpectedException = null;

        Test.setMock(WebServiceMock.class, new MdApiMock());
        Test.setMock(HttpCalloutMock.class, new ToolingApiMock());

        SetupBackendConnection step = new SetupBackendConnection();

        // Exercise
        try {
            step.doRun();
        }
        catch(Exception ex) {
            unexpectedException = ex;
        }


        // Verify
        System.assertNotEquals(null, step.getStatus());
        System.assertNotEquals(null, step.getMessage());
        System.assertNotEquals(null, step.buttonLabel());
        System.assertEquals(null, unexpectedException);
    }
}