<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<casConfiguration>
    <casServerUrl>https://${FQDN}/cas</casServerUrl>
    <casRestTicketUrl>https://${FQDN}/cas/v1/tickets</casRestTicketUrl>
    <casService>https://${FQDN}/nexus</casService>
    <validationProtocol>SAML</validationProtocol>
    <defaultRoles>nx-developer</defaultRoles>
</casConfiguration>
