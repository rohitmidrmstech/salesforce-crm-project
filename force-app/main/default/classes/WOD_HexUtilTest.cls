/**
 * @description Test class for wod_HexUtil
*/
@isTest
public class WOD_HexUtilTest {
  /**
   * @description data set up and execution
  */
	public static testmethod void TestOne(){
        wod_HexUtil objHex = new wod_HexUtil();
        wod_HexUtil.CRC32Table(blob.valueOf('rwerrwfs'));
        wod_HexUtil.CRC32Table('sdhfkshf');
        wod_HexUtil.hexToIntLE('hhasdkashd');
        wod_HexUtil.intToHexLE(4, 5);
    }
}