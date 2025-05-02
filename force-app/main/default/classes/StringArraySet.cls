public  class StringArraySet{
    public  void generateStringArray(integer nooffrecord) {

        integer start = 0;
        integer i;
        list<string> lststr = new list<string>();
        for(i = start ; i<=nooffrecord; i++){
            // public string getstring(index i){
            string s1 = getstr(i);
            lststr.add(s1);
        }
        System.debug('Test Result : ' + lststr);
        //Insert lststr;
    }
    public string getstr(integer i){
        list<string> lststrs = new list<string>();
        lststrs.add('testo');
        lststrs.add('test1');
        lststrs.add('test3');
        string testn =  lststrs[i];
        return testn;
    }
}