___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Proxy - gtm.js",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Proxy gtm.js from the Google servers and optionally adjust the request path of gtm.js.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "pathnameGtm",
    "displayName": "Custom pathname gtm.js",
    "simpleValueType": true,
    "defaultValue": "/gtm.js",
    "help": "Pathname, start with /"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "allowedContainerIds",
    "displayName": "Allowed GTM Container-IDs",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "",
        "name": "gtm_container_id",
        "type": "TEXT"
      }
    ],
    "help": "Enter GTM-Container-IDs that are allowed to fetched fromt the Google servers and returned to the browser."
  }
]


___SANDBOXED_JS_FOR_SERVER___

const claimRequest = require('claimRequest');
const getGoogleScript = require('getGoogleScript');
const getRequestHeader = require('getRequestHeader');
const getRequestPath = require('getRequestPath');
const getRequestQueryParameters = require('getRequestQueryParameters');
const setResponseBody = require('setResponseBody');
const setResponseHeader = require('setResponseHeader');
const returnResponse = require('returnResponse');

const pathname = data.pathnameGtm || '/gtm.js';

// Check the configured requestpath for the gtm.js library
if (getRequestPath() == pathname) {
  
	// Claim the requst
	claimRequest();

	const allowedContainerIds = data.allowedContainerIds;
	const allowedContainerIdsArray = [];
	const queryParameters = getRequestQueryParameters();
	const gtmContainerId = queryParameters.id;
	
	for (let i=0; i < allowedContainerIds.length; i++) {
		allowedContainerIdsArray.push(allowedContainerIds[i].gtm_container_id);
	}

	if (allowedContainerIdsArray.indexOf(gtmContainerId)  !== -1) {

		getGoogleScript('GTM', (script, metadata) => {

			// Pass headers
			for (let header in metadata) {
				setResponseHeader(header, metadata[header]);
			}
			
			setResponseHeader('content-type', 'text/javascript');
			setResponseBody(script);

			// Handle CORS
			const origin = getRequestHeader('Origin');
			if (origin) {
				setResponseHeader('Access-Control-Allow-Origin', origin);
				setResponseHeader('Access-Control-Allow-Credentials', 'true');
			}
	
			// Return the response
			returnResponse();
			
		}, {'id': gtmContainerId});
	}
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "pathAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "return_response",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "allowGoogleDomains",
          "value": {
            "type": 8,
            "boolean": true
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 19-8-2022 10:15:18


