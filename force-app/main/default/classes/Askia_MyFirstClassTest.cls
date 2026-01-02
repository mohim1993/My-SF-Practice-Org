@isTest
private class Askia_MyFirstClassTest {
    @isTest
    static void testAddNumbers() {
        Integer a = 2;
        Integer b = 3;
        
        Askia_MyFirstClass Askia_MyFirstClass = new Askia_MyFirstClass();
        Integer result = Askia_MyFirstClass.addNumbers(a, b);
         
        System.assertEquals(5, result, 'Expected result is incorrect');
    }
}