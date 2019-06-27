public abstract class BatchSetupStep extends SetupStep implements Database.Batchable<SObject> {

	// PUBLIC

	public virtual override ApexPages.Message getStatus() {
		String status = batchStatus();
System.debug(LoggingLevel.ERROR, status);

		if((new List<String>{'Failed', 'Aborted'}).contains(status)) {
			return new ApexPages.Message(ApexPages.Severity.ERROR, 'Execution ' + status + '. Check the ' + logsLink() + '.');
		}
		else if((new List<String>{'Holding', 'Queued', 'Preparing', 'Processing'}).contains(status)) {
			return new ApexPages.Message(ApexPages.Severity.INFO, 'Execution is ' + status + ' : Check the ' + logsLink());
		}

		return null;
	}


	public override String getButtonLabel() {
		return 'Run';
	}


	public override PageReference run() {
		Database.executeBatch(this, 1);

		return null;
	}


	// PRIVATE

	private String batchStatus() {
		String result = null;

		String className = String.valueOf(this).split(':')[0];
		for(AsyncApexJob job : [SELECT Status FROM AsyncApexJob  WHERE ApexClass.Name LIKE :className LIMIT 1]) {
			result = job.Status;
		}

		return result;
	}


	private String logsLink() {
		return '<b><a href="/apexpages/setup/listAsyncApexJobs.apexp">Apex Jobs</a></b>';
	}
}
