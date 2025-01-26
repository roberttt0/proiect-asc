#include <iostream>
#include <fstream>
using namespace std;
ifstream f("input2_c++.txt");
ofstream g("output2");
long v[1048576], n, x, m=1024;
long nou[1048576];
int main()
{
    for (long i=0; i < 1024; i++)
        for (long j=0; j<1024; j++)
            v[i*1024+j] = 0;
    f >> n;  // Nr de operatii

    for (long i=1; i<=n; i++)
    {
        f >> x;     // Citim o operatie

        if (x==1)   // ADD
        {
            long nr_fisiere=0;
            f >> nr_fisiere;

            for (long j=1; j<=nr_fisiere; j++)
            {
                long descriptor = 0, dimensiune = 0;
                f>>descriptor;
                f>>dimensiune;

                if(dimensiune % 8 == 0)
                    dimensiune = dimensiune / 8;
                else
                    dimensiune = dimensiune / 8 + 1;

                long cntx=0, cnty=0;
                long ok = 0;
                for (long k=0; k < m; k++)      // 1024
                {
                    long nr=0;
                    for (long p=0; p < m; p++)      // 1024
                    {
                        if(v[k*m+p] == 0)
                            nr+=1;
                        else
                            nr=0;
                        
                        if(nr == dimensiune)
                        {
                            cntx = k;
                            cnty = p - dimensiune + 1;
                            p = m;      // 1024
                            k = m;      // 1024
                            ok = 1;
                        }
                    }
                }

                long end = 0;
                if (ok == 1)
                {
                    long nrp = cnty;
                    end = cnty + dimensiune - 1;
                    while (nrp <= end)
                    {
                        v[cntx*m + nrp]=descriptor;
                        nrp+=1;
                    }

                    g<<descriptor<<": (("<<cntx<<", "<<cnty<<"), ("<<cntx<<", "<<end<<"))"<<endl;

                }

                else
                {
                    cntx = 0;
                    cnty = 0;
                    end = 0;
                    g<<"(("<<cntx<<", "<<cnty<<"), ("<<cntx<<", "<<end<<"))"<<endl;
                }
                
            }
        }

        else if (x == 2)    // GET
        {   
            long descriptor = 0;
            long startx = 0, starty=0, endy=0;
            f >> descriptor;
            for (long k=0; k < m; k++)      // 1024
            {
                for (long p=0; p < m; p++)       //1024
                {
                    if(v[k*m+p] == descriptor)
                    {
                        startx = k;
                        starty = p;
                        while (v[k*m+p] == descriptor)
                            p+=1;
                        endy = p-1;
                        k=m;        // 1024
                        p=m;    /// 1024
                    }
                }
            }
            g<<"(("<<startx<<", "<<starty<<"), ("<<startx<<", "<<endy<<"))"<<endl;
        }

        else if (x==3)  // DELETE
        {
            long descriptor = 0;
            f >> descriptor;
            for (long k=0; k<m; k++)
                for (long p=0; p<m; p++)
                    if(v[k*m+p] == descriptor)
                        v[k*m+p]=0;
            
            for (long k=0; k<m; k++)
                for (long p=0; p<m; p++)
                {
                    if (v[k*m+p] != 0)
                    {
                        long numar = v[k*m+p];
                        long startx = k;
                        long starty = p;

                        while (v[k*m+p] == numar)
                            p+=1;
                        p = p-1;
                        long endy = p;
                        g<<numar<<": (("<<startx<<", "<<starty<<"), ("<<startx<<", "<<endy<<"))"<<endl;
                    }
                }
        }

        else if (x==4)// DEFRAG
        {
            for (long k=0; k<m; k++)
                for (long p=0; p<m; p++)
                    nou[k*m + p] = 0;

            long descriptor = 0, dimensiune = 0;
            long linie = 0;

            for (long k=0; k < m; k++)
            {
                for (long p = 0; p < m; p++)
                {
                    if (v[k*m+p]!=0)
                    {
                        descriptor = v[k*m+p];
                        dimensiune = 0;
                        while (v[k*m+p]==descriptor)
                        {
                            dimensiune += 1;
                            p +=1;
                        }
                        p -= 1;
                        long cntx = 0, cnty = 0;
                        for (long y = linie; y < m; y++)
                        {
                            long nr = 0;
                            for (long u = 0; u <m; u++)
                            {
                                if(nou[y*m + u] == 0)
                                    nr+=1;
                                else
                                    nr=0;

                                if (nr==dimensiune)
                                {
                                    cntx=y;
                                    cnty = u-dimensiune+1;
                                    y=m;
                                    u=m;                    
                                }
                            }
                        }
                        long nrp = cnty, end = cnty + dimensiune -1;

                        while (nrp <= end)
                        {
                            nou[cntx * m + nrp] = descriptor;
                            nrp += 1;
                        }
                        linie = cntx;


                    }
                }
            }

            for (long k = 0; k<m; k++)
                for (long p=0; p<m; p++)
                    v[k*m+p] = nou[k*m+p];

            for (long k=0; k<m; k++)        // afisare defrag
                for (long p=0; p<m; p++)
                {
                    if (v[k*m+p] != 0)
                    {
                        long numar = v[k*m+p];
                        long startx = k;
                        long starty = p;

                        while (v[k*m+p] == numar)
                            p+=1;
                        p = p-1;
                        long endy = p;
                        g<<numar<<": (("<<startx<<", "<<starty<<"), ("<<startx<<", "<<endy<<"))"<<endl;
                    }
                }
        }
    }
    f.close();
    g.close();
    return 0;
}