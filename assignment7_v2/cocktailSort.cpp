// C++ implementation of Cocktail Sort 
#include <iostream> 
using namespace std; 
  
// Sorts arrar a[0..n-1] using Cocktail sort 
void CocktailSort(int a[], int n) 
{ 
    bool swapped = true; 
    int start = 0; 
    int end = n - 1; 
  
    while (swapped) { 
        // reset the swapped flag on entering 
        // the loop, because it might be true from 
        // a previous iteration. 
        swapped = false; 
  
        // loop from left to right same as 
        // the bubble sort 
        for (int i = start; i < end; ++i) { 
            if (a[i] > a[i + 1]) { 
                swap(a[i], a[i + 1]); 
                swapped = true; 
            } 
        } 
  
        // if nothing moved, then array is sorted. 
        if (!swapped) 
            break; 
  
        // otherwise, reset the swapped flag so that it 
        // can be used in the next stage 
        swapped = false; 
  
        // move the end point back by one, because 
        // item at the end is in its rightful spot 
        --end; 
  
        // from right to left, doing the 
        // same comparison as in the previous stage 
        for (int i = end - 1; i >= start; --i) { 
            if (a[i] > a[i + 1]) { 
                swap(a[i], a[i + 1]); 
                swapped = true; 
            } 
        } 
  
        // increase the starting point, because 
        // the last stage would have moved the next 
        // smallest number to its rightful spot. 
        ++start; 
    } 
} 
  
/* Prints the array */
void printArray(int a[], int n) 
{ 
    for (int i = 0; i < n; i++) 
        cout << a[i] << " "; 
    cout << endl; 
} 
  
// Driver code 
int main() 
{ 
    int arr[] = { 123,  42, 146,  76, 120,  56, 164,  65, 155,  57,
		111, 188,  33,  05,  27, 101, 115, 108,  13, 115,
		 17,  26, 129, 117, 107, 105, 109,  30, 150,  14,
		147, 123,  45,  40,  65,  11,  54,  28,  13,  22,
		 69,  26,  71, 147,  28,  27,  90, 177,  75,  14,
		181,  25,  15,  22,  17,  11,  10, 129,  12, 134,
		 61,  34, 151,  32,  12,  29, 114,  22,  13, 131,
		127,  64,  40, 172,  24, 125,  16,  62,   8,  92,
		111, 183, 133,  50,   2,  19,  15,  18, 113,  15,
		 29, 126,  62,  17, 127,  77,  89,  79,  75,  14,
		114,  25,  84,  43,  76, 134,  26, 100,  56,  63,
		 24,  16,  17, 183,  12,  81, 320,  67,  59, 190,
		193, 132, 146, 186, 191, 186, 134, 125,  15,  76,
		 67, 183,   7, 114,  15,  11,  24, 128, 113, 112,
		 24,  16,  17, 183,  12, 121, 320,  40,  19,  90,
		135, 126, 122, 117, 127,  27,  19, 127, 125, 184,
		 97,  74, 190,   3,  24, 125, 116, 126,   4,  29,
		104, 124, 112, 143, 176,  34, 126, 112, 156, 103,
		 69,  26,  71, 147,  28,  27,  39, 177,  75,  14,
		153, 172, 146, 176, 170, 156, 164, 165, 155, 156,
		 94,  25,  84,  43,  76,  34,  26,  13,  56,  63,
		147, 153, 143, 140, 165, 191, 154, 168, 143, 162,
		 11,  83, 133,  50,  25,  21,  15,  88,  13,  15,
		169, 146, 162, 147, 157, 167, 169, 177, 175, 144,
		 27,  64,  30, 172,  24,  25,  16,  62,  28,  92,
		181, 155, 145, 132, 167, 185, 150, 149, 182,  34,
		 81,  25,  15,   9,  17,  25,  37, 129,  12, 134,
		177, 164, 160, 172, 184, 175, 166,  62, 158,  72,
		 61,  83, 133, 150, 135,  31, 185, 178, 197, 185,
		147, 123,  45,  40,  66,  11,  54,  28,  13,  22,
		 49,   6, 162, 167, 167, 177, 169, 177, 175, 164,
		161, 122, 151,  32,  70,  29,  14,  22,  13, 131,
		 84, 179, 117, 183, 190, 100, 112, 123, 122, 131,
		123,  42, 146,  76,  20,  56,  64,  66, 155,  57,
		 39, 126,  62,  41, 127,  77, 199,  79, 175,  14, }; 
    
    int n = sizeof(arr) / sizeof(arr[0]); 
    CocktailSort(arr, n); 
    cout << "Sorted array :\n" << endl; 
    printArray(arr, n); 
    
    //Stat Variables
    int sum = 0;
    int min = arr[0];
    int max = arr[349];
    int avg = 0;
    int med = 0;

    //Calculate Stats and display
    for(int i = 0; i < 349; i++){

        sum += arr[i];

    }

    //avg
    avg = sum / 349;

    //Display
    cout << endl;
    cout << "Stats: " << endl;
    cout << "Min: " << min << endl;
    cout << "Max: " << max << endl;
    cout << "Avg: " << avg << endl;
    cout << "Sum: " << sum << endl;

    return 0; 
} 