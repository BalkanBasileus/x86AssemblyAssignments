#include <iostream>
using namespace std;

int main(int argc, char const *argv[])
{

    //Arrays
    int aSides[] = {10,    14,    13,    37,    54,
		   31,    13,    20,    61,    36,
		   14,    53,    44,    19,    42,
		   27,    41,    53,    62,    10,
		    9,     8,     4,    10,    15,
		    5,    11,    22,    33,    70,
		   15,    23,    15,    63,    26,
		   24,    33,    10,    61,    15,
		   14,    34,    13,    71,    81,
		   38,    73,    29,    17,    93};

    int bSides[] = {133,   114,   173,   131,   115,
			  164,   173,   174,   123,   156,
			  144,   152,   131,   142,   156,
			  115,   124,   136,   175,   146,
			  113,   123,   153,   167,   135,
			  114,   129,   164,   167,   134,
			  116,   113,   164,   153,   165,
			  126,   112,   157,   167,   134,
			  117,   114,   117,   125,   153,
			  123,   173,   115,   106,    13};

    int cSides[]= {1145,  1135,  1123,  1123,  1123,
			 1254,  1454,  1152,  1164,  1542,
			 1353,  1457,   182,  1142,  1354,
			 1364,  1134,  1154,  1344,   142,
			 1173,  1543,  1151,  1352,  1434,
			 1355,  1037,   123,  1024,  1453,
			 1134,  2134,  1156,  1134,  1142,
			 1267,  1104,  1134,  1246,   123,
			 1134,  1161,  1176,  1157,  1142,
			 1153,  1193,  1184,   142,  2034};

    long volumes[50];

    for (int i = 0; i < 50; i++)
    {
        if(i % 4 == 0){
            cout << endl;
        }

        volumes[i] = ( (aSides[i] * bSides[i]) * cSides[i] );
        
        cout << volumes[i] << " ";

    }
    cout << endl;
    
    //Volume Variables
    long vSum;
    int vMin = volumes[0];
    int vMax = volumes[0];
    int vAvg;
    int length = 50;

    for (int i = 0; i < 50; i++)
    {
        vSum += volumes[i];

        if(vMin > volumes[i]){
            vMin = volumes[i];
        }

        if(vMax < volumes[i]){
            vMax = volumes[i];
        }
    }

    //Volume Average
    vAvg = vSum / length;

    cout << endl;
    cout << "Sum: " << vSum << endl;
    cout << "Min: " << vMin << endl;
    cout << "Max: " << vMax << endl;
    cout << "Avg: " << vAvg << endl;


    long surfaceAreas[50];

    for (int i = 0; i < 50; i++)
    {
        if(i % 4 == 0){
            cout << endl;
        }

        surfaceAreas[i] = 2 * ( (aSides[i]*bSides[i]) + 
                                (aSides[i]*cSides[i]) + 
                                (bSides[i]*cSides[i]) );
        
        cout << surfaceAreas[i] << " ";

    }
    cout << endl;
    
    //Volume Variables
    long saSum;
    int saMin = surfaceAreas[0];
    int saMax = surfaceAreas[0];
    int saAvg;

    for (int i = 0; i < 50; i++)
    {
        saSum += surfaceAreas[i];

        if(saMin > surfaceAreas[i]){
            saMin = surfaceAreas[i];
        }

        if(saMax < surfaceAreas[i]){
            saMax = surfaceAreas[i];
        }
    }

    //Volume Average
    saAvg = saSum / length;

    cout << endl;
    cout << "saSum: " << saSum << endl;
    cout << "saMin: " << saMin << endl;
    cout << "saMax: " << saMax << endl;
    cout << "saAvg: " << saAvg << endl;

    return 0;
}
