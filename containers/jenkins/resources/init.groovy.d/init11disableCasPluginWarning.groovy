// disable cas security warning SECURITY-488
// the version of the cas plugin which is deployed to the ces jenkins
// does not contain the problem, because we have removed the cas protocol 1.0

import hudson.ExtensionList;
import jenkins.security.UpdateSiteWarningsConfiguration;
import net.sf.json.JSONObject;

ExtensionList<UpdateSiteWarningsConfiguration> configurations = ExtensionList.lookup(UpdateSiteWarningsConfiguration.class);
if (!configurations.isEmpty()) {
  UpdateSiteWarningsConfiguration configuration = configurations.get(0);
  Set<String> ignoredWarnings = configuration.getIgnoredWarnings();

  if (!ignoredWarnings.contains("SECURITY-488")) {
    JSONObject json = new JSONObject();
    json.put("SECURITY-488", Boolean.FALSE);
    for ( String ignoredWarning : ignoredWarnings ) {
      json.put(ignoredWarning, Boolean.FALSE);
    }

    configuration.configure(null, json);
  }
}