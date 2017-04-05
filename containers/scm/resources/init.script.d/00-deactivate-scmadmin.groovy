// deactivates the default user scmadmin

import sonia.scm.user.*;

def userManager = injector.getInstance(UserManager.class);
def scmadmin = userManager.get('scmadmin');

if (scmadmin.type == 'xml'){
    scmadmin.setActive(false);
    userManager.modify(scmadmin);
}