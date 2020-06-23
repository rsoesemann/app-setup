# Salesforce App Setup [![Codacy Badge](https://api.codacy.com/project/badge/Grade/fd46a7eaa24c4cf78a5b981327275934)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=rsoesemann/app-setup&amp;utm_campaign=Badge_Grade)

Lean framework to build flexible and modular Setup UI for your Salesforce Lightning and Classic app.

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com)
<a href="https://githubsfdeploy.herokuapp.com?owner=rsoesemann&repo=app-setup">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

<img width="500" alt="Bildschirmfoto_2019-07-02_um_17_06_18_png" src="https://user-images.githubusercontent.com/8180281/60524346-ac649a80-9cec-11e9-8690-eb49622b9b89.png">

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
- It's easier to display a VF-based UI in Classic and auto-generate it nicely as Lightning-styled than the other way round.
- Setup pages are not super interactive, so all the Lightning funkyness is not needed, especially as it comes at cost of increased code complexity and maintainance. Just compare a few lines of well tested Apex and Visualforce with a LWC-component.
 
## Screenshots: ##

<img width="926" alt="Bildschirmfoto_2019-07-02_um_17_06_18_png" src="https://user-images.githubusercontent.com/8180281/60524346-ac649a80-9cec-11e9-8690-eb49622b9b89.png">
---
<img width="928" alt="Bildschirmfoto_2019-07-02_um_16_55_13_png" src="https://user-images.githubusercontent.com/8180281/60524334-a79fe680-9cec-11e9-8b47-998fadd53090.png">
---
<img width="1022" alt="Bildschirmfoto 2019-07-02 um 12 49 56" src="https://user-images.githubusercontent.com/8180281/60524355-af5f8b00-9cec-11e9-9e84-e6e1c2adb45a.png">
