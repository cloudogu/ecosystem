// finish the jenkins installtion by setting state to ready in etcd
// the state health check will now mark jenkins as healthy

def writeValueToEtcd(String key, String value){
    String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");

	def conn = url.openConnection();
    conn.setRequestMethod("PUT");
    conn.setDoOutput(true);
    conn.setRequestProperty('Content-Type', 'application/x-www-form-urlencoded');
    def writer = new OutputStreamWriter(conn.getOutputStream());
    writer.write("value=${value}");
    writer.flush();
    writer.close();

    def responseCode = conn.getResponseCode();
    if (responseCode != 200) {
        throw new IllegalStateException("etcd returned invalid response code " + responseCode);
    }
}

def writeState(String state) {
    writeValueToEtcd('state/jenkins', state);
}

writeState('ready');