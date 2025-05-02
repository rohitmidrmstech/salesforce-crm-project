public virtual class ChildClass  extends ParentClass {
  protected  integer assignment;
   protected integer totalMarks = mark;
    public  virtual integer case3(integer assign1){
        integer tm = assign1+mark;
        system.debug('case1 '+ mark);
        system.debug('this is child class properties' +tm);   
        return tm;
        
        
        
    }  
}