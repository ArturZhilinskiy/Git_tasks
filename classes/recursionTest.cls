/**
 * Created by User on 21.05.2019.
 */

public with sharing class recursionTest {
    public static  void myRecursion(Integer n){
        if(n > 0 ){
            n--;
            myRecursion(n);
        }
        System.debug(n);
    }
}