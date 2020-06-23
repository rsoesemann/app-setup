# Salesforce App Setup [![Codacy Badge](https://api.codacy.com/project/badge/Grade/fd46a7eaa24c4cf78a5b981327275934)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=rsoesemann/app-setup&amp;utm_campaign=Badge_Grade)

Lean framework to build flexible and modular Setup UI for your Salesforce Lightning and Classic app.

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com)
<a href="https://githubsfdeploy.herokuapp.com?owner=rsoesemann&repo=app-setup">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

<img width="500" src="https://user-images.githubusercontent.com/8180281/85404639-87051800-b55f-11ea-849e-89d0382d2b10.png">

Installing an App using an install link often is not enough for making it work in a subscriber org. If you don't want to rely on flaky Install Scripts you often find yourself writing custom 
Post-Installation Setup UI. To create Remote Sites, initialize Custom Settings or to create other complicated Metadata on behalf of the users. The aim of this small library is to take away the conceptual work of thinking about the UI.
Just plugin you setup code and it will look great and work everywhere.

## Features: ##
 - Uses Visualforce plus <a href="https://www.lightningdesignsystem.com/">SLDS Styling</a> to work and look great in Lightning and Classis
 - Works as single Setup screen/tab that can hold arbitrary modular Setup steps
 - Each step is nicely encapsulated in its own Apex class and UI component
 - For easy steps no need to write UI code.
 - Each step can have arbitrary UI.
 - No need but flexible for using Custom Settings or Custom Metadata to store state.
 - Support for long-running batch steps.
 - Provides a perfect place to mention the Open-Source code you use in your app.
 
## Why Visualforce? ##
I sometime get asked why this is a Visualforce page and not a Lightning tab or a bunch of Aura / LWC components. There are multiple reasons:
- Setup Steps very often need to use APIs to make something happen in Salesforce. E.g. creating a Named Credential requires to make callouts to the Metadata API. [This cannot be done from anything Lightning but from Visualforce](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/apex_api_calls.htm).
- Managed packages currently only allow to package a Visualforce-based Customize/Setup option 
- It's easier to display a VF-based UI in Classic and auto-generate it nicely as Lightning-styled than the other way round.
- Setup pages are not super interactive, so all the Lightning funkyness is not needed, especially as it comes at cost of increased code complexity and maintainance. Just compare a few lines of well tested Apex and Visualforce with a LWC-component.