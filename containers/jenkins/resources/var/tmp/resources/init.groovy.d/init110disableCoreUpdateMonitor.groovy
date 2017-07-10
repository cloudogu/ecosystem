// this script will disable the administration monitor that shows up the new jenkins version
// available message in the ui.

import jenkins.model.*;

def coreUpdateMonitorID = 'hudson.model.UpdateCenter$CoreUpdateMonitor';

def coreUpdateMonitor = Jenkins.instance.getAdministrativeMonitor(coreUpdateMonitorID);
if ( coreUpdateMonitor.isEnabled() ) {
    coreUpdateMonitor.disable(true);
    Jenkins.instance.save();
}
