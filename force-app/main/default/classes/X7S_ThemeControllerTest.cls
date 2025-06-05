/*
 * Licensed Materials - Property of IBM
 * 6949-84J
 * © Copyright IBM Corp. 2022 All Rights Reserved
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

@IsTest
public class X7S_ThemeControllerTest {
  @IsTest
  static void test_UberTheme() {
    Profile adminProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];

    User admin = new User(
      LastName = 'test user 1',
      Username = 'test.user.1@example.com',
      Email = 'test.1@example.com',
      Alias = 'testu1',
      TimeZoneSidKey = 'GMT',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'ISO-8859-1',
      ProfileId = adminProfile.Id,
      LanguageLocaleKey = 'en_US'
    );

    System.runAs(admin) {
      Test.startTest();

      // call method to get Site Prefix
      String strSitePathPrefix = X7S_ThemeController.getSiteName();
      System.assertEquals(strSitePathPrefix, System.Site.getPathPrefix());
      System.assertEquals('', X7S_ThemeController.getSiteNameInternal('0'));

      Test.stopTest();
    }
  }
}