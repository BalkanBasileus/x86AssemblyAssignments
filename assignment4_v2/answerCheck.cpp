#include <iostream>
using namespace std;

int main(int argc, char const *argv[])
{

    int size = 0;
    int sum = 0;
    int avg = 0;
    int odd, four, oddSum, fourSum;

    int lst[] = {367,  316,  542,  240,  677,
			 635,  426,  820,  146, -333,
			 317, -115,  226,  140,  565,
			 871,  614,  218,  313,  422,	
			-119,  215, -525, -712,  441,
			-622, -731, -729,  615,  724,
			 217, -224,  580,  147,  324,
			 425,  816,  262, -718,  192,
			-432,  235,  764, -615,  310,
			 765,  954, -967,  515,  556,
			 342,  321,  556,  727,  227,
			-927,  382,  465,  955,  435,
			-225, -419, -534, -145,  467,
			 315,  961,  335,  856,  553,
  			-32,  835,  464,  915, -810,
			 465,  554, -267,  615,  656,
			 192, -825,  925,  312,  725,
			-517,  498, -677,  475,  234,
			 223,  883, -173,  350,  415,
			 335,  125,  218,  713,  25};

    int max = lst[0];
    int min = lst[0];

    for (int i = 0; i < 100; i++)
    {
        sum += lst[i];
        size++;

        //Min
        if(min >= lst[i]){
            min = lst[i];
        }
        
        //Four
        if(lst[i] % 4 == 0){
            four++;
            fourSum += lst[i];
        }

        //Odd
        if(lst[i] % 2 != 0){
            odd++;
            oddSum += lst[i];
        }
    }

    //Avg
    avg = sum / size;
    
    cout << "Oddcnt: " << odd << endl;
    cout << "OddSum: " << oddSum << endl;
    cout << "Fourcnt: " << four << endl;
    cout << "FourSum: " << fourSum << endl;
    cout << "Size: " << size << endl;
    cout << "Min: " << min << endl;
    cout << "Sum: " << sum << endl;
    cout << "Avg: " << avg << endl;

    
    return 0;
}

/*
*Sample Output*

Oddcnt: 58
OddSum: 12446
Fourcnt: 21
FourSum: 7108
Size: 100
Min: -967
Sum: 23568
Avg: 235
*/