





/**
 * @author sierhum
 * @version $Revision:$ $Date:$ $Author:$
 */
agent Patient memberof SystemGroup {
	attributes:
		public map m_Measurements; // an HashMap of measurement notification
		
	activities:
		primitive_activity evaluateCareplan(int i, Measurement measure) {
			max_duration: i;
		} //evaluateCareplan
	
	workframes:
	/*
		This is the worframe that is the problem in the Brahms Agent Service code:
		
    		workframe wf_NewBloodPressureData {
          repeat: true;
          when((current.newBloodPressureAvailable = true))
          do {
            java(BloodPressureFeatureNotification) latestBloodPressure = current.latestBloodPressureFeature;
            evaluateCareplan(latestBloodPressure);
            conclude((current.newBloodPressureAvailable = false), bc:100, fc:0);
          }
        }
        
		This workframe loops over all new measurements in the m_Measurements map once and only once.
		This solves the bug that exists in the current Ejenta Agent Service Brahms code.
		We need to change the Agent Service code to pass the array of measurements to the Brahms agent.
	*/
		workframe wf_NewMeasurementData {
			repeat: true; // this is by default false, but we want to fire the wf for the same alert more than once.
			variables:
				foreach(Measurement) o_Measurement; // this makes the wf fire for each measurement belief the agent gets as part of the array (i.e. map)
				foreach(int) i; // this makes the wf loop over all measurements in the array (i.e. map)
			when ((current.m_Measurements(i) = o_Measurement))
			do {				
				println_c("Evaluate %1 ", o_Measurement); // just print the measurement name being processed.
				println_n("from index [%1]", i);
				println("");
				evaluateCareplan(1, o_Measurement); // just to take some simulation time, in this case 1 sec simulated time;
				retractBelief(current, "m_Measurements", i); //delete this belief, so the wf won't fire again and also to keep the belief set constant
			} //do
		} //wf_NewMeasurementData
		
} //Patient
