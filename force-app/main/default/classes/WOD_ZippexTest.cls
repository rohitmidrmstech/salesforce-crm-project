/**********************************************************************
Name:  WOD_CTUtilTest
===============================================================
Purpose: Test data set up class                                                                                                               
===============================================================
===============================================================
History                                                            
-------                                                            
  AUTHOR        DATE            DETAIL                        
  Tavant     28/05/2021      INITIAL DEVELOPMENT            
***********************************************************************/
@isTest
public class WOD_ZippexTest {
	 @isTest static void testHexUtil() 
    {

        String testData = 'This is a test';  //test data
        Integer expectedCRC32 = (Integer)(3229261618L);
        wod_Zippex w= new wod_Zippex();
        w.getFileInfo('test');
        wod_Zippex.getLastModDateTime(10,10);
        System.assertEquals(wod_HexUtil.CRC32Table(Blob.valueOf(testData)) , expectedCRC32);
        System.assertEquals(wod_HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , expectedCRC32);

        testData = 'test two';
        expectedCRC32 = 1542186603;
        System.assertEquals(wod_HexUtil.CRC32Table(Blob.valueOf(testData)) , expectedCRC32);
        System.assertEquals(wod_HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , expectedCRC32);

        testData = '';
        expectedCRC32 = 0;
        System.assertEquals(wod_HexUtil.CRC32Table(Blob.valueOf(testData)) , expectedCRC32);
        System.assertEquals(wod_HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , expectedCRC32);

        // public static Integer hexToIntLE(String hexString)
        System.assertEquals(wod_HexUtil.hexToIntLE('ffffffff'),(Integer)(4294967295L));
        System.assertEquals(wod_HexUtil.hexToIntLE('feffffff'),(Integer)(4294967294L));
        System.assertEquals(wod_HexUtil.hexToIntLE('ffffff7f'),(Integer)(2147483647 ));
        System.assertEquals(wod_HexUtil.hexToIntLE('00000080'),(Integer)(2147483648L));
        System.assertEquals(wod_HexUtil.hexToIntLE('00000000'),0);

        // public static String intToHexLE(Integer decNumber, Integer sizeInBytes)
        System.assertEquals(wod_HexUtil.intToHexLE((Integer)(4294967295L),4),'ffffffff');
        System.assertEquals(wod_HexUtil.intToHexLE((Integer)(4294967294L),4),'feffffff');
        System.assertEquals(wod_HexUtil.intToHexLE((Integer)(2147483647 ),4),'ffffff7f');
        System.assertEquals(wod_HexUtil.intToHexLE((Integer)(2147483648L),4),'00000080');
        System.assertEquals(wod_HexUtil.intToHexLE(0,4),'00000000');
        System.assertEquals(wod_HexUtil.intToHexLE(878678,4),'56680d00');
        System.assertEquals(wod_HexUtil.intToHexLE(878678,2),'5668');
        System.assertEquals(wod_HexUtil.intToHexLE(878678,0),'');

    }
    
    @isTest static void zipTest() 
    {
        Blob tinyZip = EncodingUtil.convertFromHex('504B030414000800080096BC7A4700000000000000000000000008001000746578742E74787455580C0055EC5756ECEB5756262ABF22F3C8E40200504B07089A3C22D50500000003000000504B0102150314000800080096BC7A479A3C22D5050000000300000008000C000000000000000040A48100000000746578742E7478745558080055EC5756ECEB5756504B05060000000001000100420000004B0000000000');
        wod_Zippex testZippex = new wod_Zippex(tinyZip);
        System.assert(testZippex.containsFile('text.txt'));
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'text.txt'});
        System.assertEquals(testZippex.getFile('text.txt').toString(), 'Hi\n');
        
        testZippex.addFile('newDir/added.txt',Blob.valueOf('new data\n'), null);
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'text.txt','newDir/added.txt'});
        System.assertEquals(testZippex.getFile('newDir/added.txt').toString(), 'new data\n');
        
        testZippex.renameFile('text.txt','newDir/changedName.txt');
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'newDir/changedName.txt','newDir/added.txt'});
        
        testZippex.removePrefix('newDir/');
        System.assert(!testZippex.containsFile('text.txt'));
        System.assert(!testZippex.containsFile('newDir/added.txt'));
        System.assert(testZippex.containsFile('changedName.txt'));
        System.assert(testZippex.containsFile('added.txt'));

        testZippex.addFile('added.txt',Blob.valueOf('even newer data\n'), null);
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'changedName.txt','added.txt'});
        System.assertEquals(testZippex.getFile('added.txt').toString(), 'even newer data\n');
        
        testZippex.removeFile('notHere.txt');
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'changedName.txt','added.txt'});

        testZippex.addFile('secondAdd.txt',Blob.valueOf('important\n'), null);
        testZippex.addFile('thirdAdd.txt',Blob.valueOf('less important\n'), null);
        testZippex.removeFile('changedName.txt');
        System.assert(!testZippex.containsFile('changedName.txt'));
        System.assertEquals(testZippex.getFileNames(), new Set<String>{'added.txt','secondAdd.txt', 'thirdAdd.txt'});

        Blob newTinyZip = testZippex.getZipArchive();
        wod_Zippex newTestZippex = new wod_Zippex(newTinyZip);
        System.assertEquals(newTestZippex.getFileNames(), new Set<String>{'added.txt','secondAdd.txt', 'thirdAdd.txt'});
        System.assertEquals(testZippex.getFile('added.txt').toString(), 'even newer data\n');
        
        newTestZippex.removeFile('added.txt');
        System.assertEquals(newTestZippex.getFileNames(), new Set<String>{'secondAdd.txt', 'thirdAdd.txt'});

        Try {
            Lead l = new Lead(LastName='Test', Company='Test');
            insert l;

            Attachment att = new Attachment(
                Name = 'archive.zip',
                Body = tinyZip,
                ParentId = l.Id);
            insert att;
            
            Test.StartTest();
            wod_Zippex.unzipAttachment(att.Id, null, null, true);
            Test.stopTest();
            
            Attachment[] atts = [SELECT Id FROM Attachment];
            
            System.assertEquals(atts.size(), 2);
        }
        catch(Exception e){}
    }
    
}