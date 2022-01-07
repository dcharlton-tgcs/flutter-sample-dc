# Production Release

This workflow is used to create a production ready version of the MobilePOS application and share this in Sharepoint.  This version is directed to the production environment within the ecp environment: production.platform.toshibacommerce.eu


---

## Running the workflow

The workflow is triggered manually from within the GitHub respository.  

* Select **Actions** from the menu 
* Highlight **Create Production Release**
* From the Run workflow dropdown, enter the **Approved version for release**
    * Note: This must match a tag that already exists within the repository


## Output

Once the workflow has run successfully, a GitHub release will be created with the new apk, and the apk file will also be published to the following location:
* [ECP-Team/UI and UX/ecp-mobilepos/Release/vX.X.X](https://tecglobal.sharepoint.com/:f:/s/TGCS-NGP-EU-Grooming/EupEJBDnqa9LuvIkLyi1nC4BMxxdrzydHvO5Gxg5ATcrTQ?e=LqVHpm)
    * Where vX.X.X is the release number
