# print-0723

# account info
* org : 985566b6-0c57-4e90-be5c-3671df64b0ef
  * id : 2dc37f034e034e0da8a6df9169b1c4c8
  * secret : 9953a594bA3b4ba08133B9DAA40c9D4c

* ca.exchange viewer
  * id : e46779727c3a48d2b84fdbb901e9f858
  * secret : 7600B882B0334d5faE3d1087d8E9e81b

```
mvn -B -f bom/pom.xml archetype:generate -DarchetypeGroupId=org.mule.extensions -DarchetypeArtifactId=mule-extensions-xml-archetype -DarchetypeVersion=1.2.0 -DgroupId=985566b6-0c57-4e90-be5c-3671df64b0ef -DartifactId=resilience-mule-extension -DmuleConnectorName=resilience-mule-extension -DextensionName=resilience -Dpackage=. -DoutputDirectory=../
```

```
mvn -B -f bom/pom.xml archetype:generate -DarchetypeGroupId=org.mule.tools -DarchetypeArtifactId=api-gateway-custom-policy-archetype -DarchetypeVersion=1.2.0 -DgroupId=985566b6-0c57-4e90-be5c-3671df64b0ef -DartifactId=custom-message-logging-policy -Dversion=1.0.0-SNAPSHOT -Dpackage=mule-policy -DpolicyDescription="Policy for logging messages" -DpolicyName="Custom Message Logging" -DoutputDirectory=../
```