

/**
 * @author sierhum
 * @version $Revision:$ $Date:$ $Author:$
 */
agent Agent_Service memberof SystemGroup {
		
	activities:
		communicate sendMeasurement(int i) {
			max_duration: i;
			with: Patient;
			about:
				send(Patient.m_Measurements = unknown);
		} //sendAlert
		
	workframes:
	/*
		This workframe simulates that 4 measurements come in to the Ejenta Agent Service at once.
		This workframe shows that we need to add each alert to a Brahms map attribute, which is an array of measurements.
		This solves the bug that exists in the current Ejenta Agent Service Brahms code.
		We need to change the Agent Service code to pass the array of measurements to the Brahms agent.
	*/
		workframe wf_sendAlert {
			do {
			// These 4 conclude statements is representing the Hashmap (array) of 4 measurements in the Agent Service
				conclude((Patient.m_Measurements(0) = Measurement_1), bc:100, fc:0);				
				conclude((Patient.m_Measurements(1) = Measurement_2), bc:100, fc:0);
				conclude((Patient.m_Measurements(2) = Measurement_3), bc:100, fc:0);
				conclude((Patient.m_Measurements(3) = Measurement_4), bc:100, fc:0);				
				sendMeasurement(0); // This models the Agent Service creating the Array of 4 measuments in the Brahms Patient agent
			} //do		
		} //wf_sendAlert
	
} //Agent_Service
