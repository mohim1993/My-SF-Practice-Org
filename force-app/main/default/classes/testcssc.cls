public class testcssc {
    public  String name;
    public static  Integer age;
    
    testcssc(String name, Integer age){
       //system.debug(testcssc.age);
       this.name = name;
    }
    
    public static void test(Integer age){
       
        system.debug(testcssc.age);
    }
	
}