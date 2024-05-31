import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:trackofyapp/constants.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2e2e2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe2e2e2),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
          padding:
              const EdgeInsets.only(top: 15.0, bottom: 10, left: 5, right: 5),
          child: SizedBox(
            height: Get.size.height * 0.9,
            child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRACKOFY USER AGREEMENT',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'PLEASE READ THE FOLLOWING USER AGREEMENT CAREFULLY',
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                        Text(
                          "The following demonstrates User Agreement (here-in-after referred to as an Agreement) between TRACKOFY (hereinafter referred to as TRACKOFY) and the users of the App (You, Your, User/Users). Before you subscribe to and/or begin participating in or using web site, TRACKOFY believes that user(s) have fully read, understood and accept the Agreement. If you do not agree to or wish to be bound by Agreement, you may not access to or otherwise use the app.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'USER AGREEMENT',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        Text(
                          "Your use of a TRACKOFY app - (hereinafter referred to as the TRACKOFY app) and services available on a website is governed by the following terms and conditions. This User Agreement for the website shall come into effect on June 3, 2013.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'AMENDMENT TO USER(S) AGREEMENT',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        Text(
                          "TRACKOFY may change, modify, amend, or update this agreement from time to time without any prior notification to user(s) and the amended and restated terms and conditions of use shall be effective immediately on posting. You are advised to regularly check for any amendments or updates to the terms and conditions contained in this User Agreement. If you do not adhere to the changes, you must stop using the service. Your continuous use of the service will signify your acceptance of the changed terms.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'USER(S) ELIGIBILITY',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        Text(
                          "User(s) means any individual or business entity/organization that legally operates in India or in other countries, uses and has the right to use the services provided by TRACKOFY. Our services are available only to those individuals or companies who can form legally binding contracts under the applicable law i.e. Indian Contract Act, 1872. As a minor if you wish to purchase or sell an item on the app such purchase or sale may be made by your legal guardian or parents who have registered as users of the app. TRACKOFY advises its users that while accessing the app, they must follow/abide by the related laws. TRACKOFY is not responsible for the possible consequences caused by your behavior during use of app. TRACKOFY may, in its sole discretion, reserve the right to terminate your membership and refuse to provide you with access to the app at any time."
                          "If you are registering as a business entity, you represent that you are duly authorized by the business entity to accept this User Agreement and you have the authority to bind that business entity to this User Agreement.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ELECTRONIC COMMUNICATIONS',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        Text(
                          "When You use the app or send emails or other data, information or communication to TRACKOFY, You agree and understand that You are communicating with TRACKOFY through electronic records and You consent to receive communications via electronic records from TRACKOFY periodically and as and when required.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'USE OF THE TRACKOFY APP',
                          style:
                              TextStyle(color: Colors.blue[500], fontSize: 20),
                        ),
                        Text(
                          "You understand and agree that TRACKOFY and the app merely provide hosting services to its Registered Users and persons browsing/visiting the app. All items advertised/listed and the contents therein are advertised and listed by Registered Users and are third party user generated contents. TRACKOFY has no control over the third party user generated contents."
                          "Please note that in accordance with applicable laws in case of non-compliance with user agreement and privacy policy for access or usage of intermediary computer resource, the Intermediary has the right to immediately terminate the access or usage rights of the users to the computer resource of Intermediary and remove non-compliant information.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'You shall not host, display, upload, modify, publish, transmit, update or share any information or share/list(s) any information or item that:',
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "1. Belongs to another person and to which you does not have any right to;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "2. Is grossly harmful, harassing, blasphemous, defamatory, obscene, pornographic, pedophilic, libelous, invasive of anothers privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever; or unlawfully threatening or unlawfully harassing including but not limited to 'indecent representation of women' within the meaning of the Indecent Representation of Women (Prohibition) Act, 1986;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "3. Harm minors in any way;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "4. Infringes any patent, trademark, copyright or other proprietary rights or third party’s trade secrets or rights of publicity or privacy or shall not be fraudulent or involve the sale of counterfeit or stolen items;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "5. Violates any law for the time being in force;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "6. Deceives or misleads the addressee/ users about the origin of such messages or communicates any information which is grossly offensive or menacing in nature;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "7. Impersonate another person;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "8. Contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer resource; or contains any Trojan horses, worms, time bombs, or other computer programming routines that may damage, detrimentally interfere with, diminish value of, surreptitiously intercept or expropriate any system, data or personal information;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "9. Threatens the unity, integrity, defense, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting any other nation.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "10. Shall not be false, inaccurate or misleading;",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "11. Shall not, directly or indirectly, offer, attempt to offer, trade or attempt to trade in any item, the dealing of which is prohibited or restricted in any manner under the provisions of any applicable law, rule, regulation or guideline for the time being in force.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "12. Shall not create liability for us or cause us to lose (in whole or in part) the services of our ISPs or other suppliers; and",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "13. Shall not link directly or indirectly to or include descriptions of items, goods or services that are prohibited under the User Agreement or any other applicable law for the time being in force including but not limited to the Drugs and Cosmetics Act, 1940, the Drugs And Magic Remedies (Objectionable Advertisements) Act, 1954, the Indian Penal Code, 1860, Information Technology Act 2000 as amended time to time and rules there under."
                          "You shall at all times ensure full compliance with the applicable provisions of the Information Technology Act, 2000 and rules there under as applicable and as amended from time to time and also all applicable Domestic laws, rules and regulations (including the provisions of any applicable Exchange Control Laws or Regulations in Force) and International Laws, Foreign Exchange Laws, Statutes, Ordinances and Regulations (including, but not limited to Sales Tax/ VAT, Income Tax, Octroi, Service Tax, Central Excise, Custom Duty, Local Levies) regarding your use of our services. You shall not engage in any transaction in an item or service, which is prohibited by the provisions of any applicable law including exchange control laws or regulations for the time being in force. In particular you shall ensure that if any of your items listed on the Website qualifies as an 'Antiquity' or 'Art treasure' as defined in the Act ('Artwork'), you shall indicate that such Artwork is 'non-exportable' and sold subject to the provisions of the Arts and Antiquities Act."
                          "User(s) hereby grant an irrevocable, perpetual, worldwide and royalty-free, sub-licensable (through multiple tiers) license to TRACKOFY to display and use all information provided by them in accordance with the purposes set forth in agreement and to exercise the copyright, publicity, and database rights you have in such material or information, in any form of media, third party copyrights, trademarks, trade secret rights, patents and other personal or proprietary rights affecting or relating to material or information displayed on the web site, including but not limited to rights of personality and rights of privacy, or affecting or relating to products that are offered or displayed on the app. TRACKOFY will only use Your Information in accordance with the User Agreement and TRACKOFY Privacy Policy. You represent and confirm that you shall have absolute right, title and authority to deal in and offer for sale such items, goods or products."
                          "From time to time, you shall be responsible for providing information relating to the items or services proposed to be sold by you. In this connection, you undertake that all such information shall be accurate in all respects. You shall not exaggerate or over emphasize the item-specifics of such items or services so as to mislead other Users in any manner.",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )),
          )),
    );
  }
}
