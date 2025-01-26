#include <iostream>
#include <fstream>
using namespace std;
ifstream f("input1_c++.txt");
ofstream g("output1");
long v[1024], n, x, nou[1024];
int main()
{
    for (int i=0; i < 1024; i++)
        v[i] = 0;

    f >> n; // Citim numarul de operatii

    for (int i=1; i <= n; i++)
    {
        f >> x; // Citim o operatie

        if (x == 1) // ADD 
        {
            long nr_fisiere = 0;
            f >> nr_fisiere;

            for (int j=1; j <= nr_fisiere; j++)
            {
                long id = 0, dim = 0;
                long ok=0;
                f >> id;
                f >> dim;
                
                if (dim % 8 == 0)
                    dim = dim / 8;
                else
                    dim = dim / 8 + 1;

                long nr = 0, cnt = 0;
                for (int k = 0; k < 1024; k++)
                {
                    if (v[k] == 0)
                        nr += 1;
                    else
                        nr = 0;
                    if (nr == dim)
                    {
                        cnt = k - dim + 1;
                        k = 2024;
                        ok=1;
                        
                    }
                }
                if (ok==1)
                {
                    long nrp = cnt, end = cnt + dim - 1;
                    while (nrp <= end)
                    {
                        v[nrp] = id;
                        nrp += 1;
                    }
                    g<<id<<": ("<<cnt<<", "<<end<<")"<<endl;
                }
                else
                {
                    long end =0;
                    cnt = 0;
                    g<<"("<<cnt<<", "<<end<<")"<<endl;
                }
            }
        }

        else if (x == 2) // GET
        {
            long id = 0, start = 0, end = 0;
            f >> id;
            for (int j = 0; j < 1024; j++)
            {
                if (v[j] == id)
                {
                    start = j;
                    while (v[j] == id)
                        j += 1;
                    end = j - 1;
                    j = 1024;
                }
            }
            g << "("<<start<<", "<<end<<")"<<endl;
        }

        else if (x == 3) // DELETE
        {
            long id = 0;
            f >> id;
            for (int j = 0; j < 1024; j++)
            {
                if (v[j] == id)
                    v[j] = 0;
            }

            for (int j = 0; j < 1024; j++)
            {
                if (v[j] != 0)
                {
                    long numar = v[j];
                    long start = j;
                    long nrp = v[j];
                    while (v[j] == nrp)
                        j += 1;
                    j = j - 1;
                    long end = j;
                    g << numar << ": ("<<start<<", "<<end<<")"<<endl;
                }
            }
        }

        // else if (x == 4)  // DEFRAGMENTATION
        // {
        //     int stop = 0;
        //     for (int j=0; j < 1023; j++)
        //     {
        //         if (v[j] == 0)
        //         {
        //             stop = j+1;
        //             long c_stop = stop;
        //             while (c_stop < 1024)
        //             {
        //                 if (v[c_stop] != 0)
        //                 {
        //                     stop = c_stop;
        //                     c_stop = 1024;
        //                 }
        //                 else 
        //                     c_stop += 1;
        //             }
        //             if (v[stop] != 0)
        //             {
        //                 int aux = v[j];
        //                 v[j] = v[stop];
        //                 v[stop] = aux;
        //             }
        //         }
        //     }

        //     for (int j = 0; j < 1024; j++)
        //     {
        //         if (v[j] != 0)
        //         {
        //             long element = v[j];
        //             long start = j;
        //             long nrp = v[j];
        //             while (v[j] == nrp)
        //                 j += 1;
        //             j = j - 1;
        //             long end = j;
        //             g << element << ": ("<<start<<", "<<end<<")"<<endl;
        //         }
        //     }
        // }

        else if (x==4)
        {
            for (int j=0; j < 1024; j++)
                nou[j] = 0;

            long id = 0, dim = 0;
            
            for (long j=0; j < 1024; j++)
            {
                if(v[j] != 0)
                {
                    id = v[j];
                    dim = 0;
                    while (v[j] == id)
                    {
                        dim += 1;
                        j +=1;
                    }

                    j -= 1;
                    long start = 0, end = 0;
                    long nr = 0;
                    for (long k = 0; k < 1024; k++)
                    {
                        if (nou[k] == 0)
                            nr += 1;
                        else
                            nr = 0;
                        
                        if (nr == dim)
                        {
                            end = k;
                            start = k-dim+1;
                            k = 1023;
                        }
                    }
                    long nrp = start;

                    while (nrp <= end)
                    {
                        nou[nrp] = id;
                        nrp += 1;
                    }
                }
            }

            for (long j = 0; j < 1024; j++)
                v[j] = nou[j];

            for (int j = 0; j < 1024; j++)
            {
                if (v[j] != 0)
                {
                    long element = v[j];
                    long start = j;
                    long nrp = v[j];
                    while (v[j] == nrp)
                        j += 1;
                    j = j - 1;
                    long end = j;
                    g << element << ": ("<<start<<", "<<end<<")"<<endl;
                }
            }
        }
    }
    
    f.close();
    g.close();
    return 0;

}