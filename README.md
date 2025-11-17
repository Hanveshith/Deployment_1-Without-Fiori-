
# Step By Step Proccess to deploy CAPM ODATA along with XSUAA.


## Prerequisites

* Create your CAPM with schema, data and expose the enities in your srv folder.
* Create a HANA Database instace in your BTP.

###### **Note** : Writing the required access roles in the srv file helps in automatically adding them in the [**xs-security.json**](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/xs-security.json).





## Deployment

#### Step-1 : Add HANA Database configuration
```bash
cds add hana --for production
```
* This creates a key-value pair in you package.json.

#### Step-2 : Add the xs-security.json file
```bash
cds add xsuaa --for production
```
* This creates the xs-security.json file with the scopes, attributes and role-templets.
* Now you need to add the following to configure properly

```json
"xsappname": "<AnyName>",
"tenant-mode": "dedicated",
```
```json
"authorities": [
    "$ACCEPT_GRANTED_AUTHORITIES"
  ],
  "oauth2-configuration": {
    "token-validity": 9000,
    "redirect-uris": [
      "https://*.cfapps.us10-001.hana.ondemand.com/login/callback"
    ]
  },
  "xsenableasyncservice": "true"
  ```
Refer - [xs-security.json](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/xs-security.json)

#### Step-3 : Add the mta.yaml file.
```bash
cds add mta
```
* Creates an mta.yaml file.
* Changes to be made in this file are :
```ymal
memory: 512M
disk-quota: 512M
```
**Note**: Add this under the parameter section of "<appname>-srv" named module under modules section.

#### Checks
```Notepad
1. Check your package.json for hana, xsuaa under cds in production object.
2. Ensure these following two dependecies are present
        ->  "@sap/xssec": "^4",
        ->  "@cap-js/hana": "^2",
3. Run "npm i" before you build your .mtar file.

```

#### Step-4 : 
    1. Right click on the .yaml file and click on "Build MTA Project" or execute "mbt build -p cf".
    2. Wait for the creation of the "mta_archives" folder. Once the .mtar file is available.
    3. execute "cf deploy mta_archives/*.mtar" to deploy you project.


### After Successful Deployment.
    1. You will find two instances created under the instances section in your BTP account.
        ->  *-auth
        ->  *-db
    2. Before you access the srv URL you must assign the roles to the user.
    3. Go to role collection in your BTP platform. In here you will find the role collections that are generated automatically based on your "xs-security.json" file.
    4. Assign that role to the user under the user section of you BTP account.
    5. Open your spaces in BTP where you can find the URL of the srv.
    6. Opening it will display your inital page (contains services, metadata...).
    7. If the intial page is not shown, please refer the possible erros section.

**Note**: Mostly your will get the **403-forbidden** error because of xsuaa.

### Testing
1. Copy the "*-srv" URL and paste it in your postman and select the "OAuth 2.0" under Authorization.    
    ![1](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/images/1.png?raw=true)
2. Open the "*-auth" instance from your BTP instances and find the following and store them in notepad.
    ![2](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/images/3.png?raw=true)


    ![3](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/images/4.png?raw=true)
    2. Scroll down and provide 

        -> Token Name
        -> Access Token URL (from step 2)
        Note: ADD "/oauth/token" AT THE END OF ABOVE URL
        -> Client ID (from step 2)
        -> Username (BTP Account Username)
        -> Password (BTP Account Password)
        
3. Click on "Get New Access Token". This generates a new access token. click on the "Use Token" Button as shown.

    ![4](https://github.com/Hanveshith/Deployment_1-Without-Fiori-/blob/main/images/2.png?raw=true)
4. Now send the GET request, which will Successfully gets the data from HANA Database.


### Possible Errors:
1. "CANNOT GET" - Run your project in your local environment and copy the /<service-name>/<entity>, and at the end of the URL.
2. You might run out of space while deploying so make sure you increase the space of your "dev" before deploying.
3. If you want to see the generated webpage containing the information of your service. Add this to your package.json.
    -> "server": {
           "index": true
        },

    


