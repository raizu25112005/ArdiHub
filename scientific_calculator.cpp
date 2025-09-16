#include <iostream>
#include <cmath>
using namespace std;

void menu() {
    cout << "\n=== Kalkulator Sains ===\n";
    cout << "1. Penjumlahan\n";
    cout << "2. Pengurangan\n";
    cout << "3. Perkalian\n";
    cout << "4. Pembagian\n";
    cout << "5. Pangkat (x^y)\n";
    cout << "6. Akar Kuadrat\n";
    cout << "7. Sinus\n";
    cout << "8. Cosinus\n";
    cout << "9. Tangen\n";
    cout << "10. Logaritma (basis 10)\n";
    cout << "11. Logaritma Natural (ln)\n";
    cout << "12. Eksponensial (e^x)\n";
    cout << "13. Faktorial\n";
    cout << "14. Modulus (sisa bagi)\n";
    cout << "15. Permutasi (nPr)\n";
    cout << "16. Kombinasi (nCr)\n";
    cout << "17. Sinus Hiperbolik (sinh)\n";
    cout << "18. Cosinus Hiperbolik (cosh)\n";
    cout << "19. Tangen Hiperbolik (tanh)\n";
    cout << "20. Derajat ke Radian\n";
    cout << "21. Radian ke Derajat\n";
    cout << "22. Floor (pembulatan bawah)\n";
    cout << "23. Ceil (pembulatan atas)\n";
    cout << "24. Nilai Mutlak\n";
    cout << "25. Notasi Ilmiah\n";
    cout << "0. Keluar\n";
    cout << "Pilih operasi: ";
}

long long factorial(int n) {
    if (n < 0) return 0;
    long long res = 1;
    for (int i = 2; i <= n; ++i) res *= i;
    return res;
}

long long permutation(int n, int r) {
    if (r > n || n < 0 || r < 0) return 0;
    return factorial(n) / factorial(n - r);
}

long long combination(int n, int r) {
    if (r > n || n < 0 || r < 0) return 0;
    return factorial(n) / (factorial(r) * factorial(n - r));
}

int main() {
    int choice;
    double a, b;
    do {
        menu();
        cin >> choice;
        switch (choice) {
            case 1:
                cout << "Masukkan dua angka: "; cin >> a >> b;
                cout << "Hasil: " << a + b << endl;
                break;
            case 2:
                cout << "Masukkan dua angka: "; cin >> a >> b;
                cout << "Hasil: " << a - b << endl;
                break;
            case 3:
                cout << "Masukkan dua angka: "; cin >> a >> b;
                cout << "Hasil: " << a * b << endl;
                break;
            case 4:
                cout << "Masukkan dua angka: "; cin >> a >> b;
                if (b == 0) cout << "Error: Pembagian dengan nol!" << endl;
                else cout << "Hasil: " << a / b << endl;
                break;
            case 5:
                cout << "Masukkan basis dan pangkat: "; cin >> a >> b;
                cout << "Hasil: " << pow(a, b) << endl;
                break;
            case 6:
                cout << "Masukkan angka: "; cin >> a;
                if (a < 0) cout << "Error: Input negatif!" << endl;
                else cout << "Hasil: " << sqrt(a) << endl;
                break;
            case 7:
                cout << "Masukkan sudut (derajat): "; cin >> a;
                cout << "Hasil: " << sin(a * M_PI / 180) << endl;
                break;
            case 8:
                cout << "Masukkan sudut (derajat): "; cin >> a;
                cout << "Hasil: " << cos(a * M_PI / 180) << endl;
                break;
            case 9:
                cout << "Masukkan sudut (derajat): "; cin >> a;
                cout << "Hasil: " << tan(a * M_PI / 180) << endl;
                break;
            case 10:
                cout << "Masukkan angka: "; cin >> a;
                if (a <= 0) cout << "Error: Input harus positif!" << endl;
                else cout << "Hasil: " << log10(a) << endl;
                break;
            case 11:
                cout << "Masukkan angka: "; cin >> a;
                if (a <= 0) cout << "Error: Input harus positif!" << endl;
                else cout << "Hasil: " << log(a) << endl;
                break;
            case 12:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << exp(a) << endl;
                break;
            case 13:
                cout << "Masukkan bilangan bulat: "; cin >> a;
                if (a < 0 || a != (int)a) cout << "Error: Input tidak valid!" << endl;
                else cout << "Hasil: " << factorial((int)a) << endl;
                break;
            case 14:
                cout << "Masukkan dua bilangan bulat: "; cin >> a >> b;
                if (b == 0) cout << "Error: Pembagian dengan nol!" << endl;
                else cout << "Hasil: " << ((int)a % (int)b) << endl;
                break;
            case 15:
                cout << "Masukkan n dan r (bilangan bulat): "; cin >> a >> b;
                if (a < 0 || b < 0 || a != (int)a || b != (int)b) cout << "Error: Input tidak valid!" << endl;
                else cout << "Hasil: " << permutation((int)a, (int)b) << endl;
                break;
            case 16:
                cout << "Masukkan n dan r (bilangan bulat): "; cin >> a >> b;
                if (a < 0 || b < 0 || a != (int)a || b != (int)b) cout << "Error: Input tidak valid!" << endl;
                else cout << "Hasil: " << combination((int)a, (int)b) << endl;
                break;
            case 17:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << sinh(a) << endl;
                break;
            case 18:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << cosh(a) << endl;
                break;
            case 19:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << tanh(a) << endl;
                break;
            case 20:
                cout << "Masukkan sudut (derajat): "; cin >> a;
                cout << "Radian: " << a * M_PI / 180 << endl;
                break;
            case 21:
                cout << "Masukkan sudut (radian): "; cin >> a;
                cout << "Derajat: " << a * 180 / M_PI << endl;
                break;
            case 22:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << floor(a) << endl;
                break;
            case 23:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << ceil(a) << endl;
                break;
            case 24:
                cout << "Masukkan angka: "; cin >> a;
                cout << "Hasil: " << fabs(a) << endl;
                break;
            case 25:
                cout << "Masukkan angka: "; cin >> a;
                cout.setf(ios::scientific);
                cout << "Hasil: " << a << endl;
                cout.unsetf(ios::scientific);
                break;
            case 0:
                cout << "Keluar dari kalkulator.\n";
                break;
            default:
                cout << "Pilihan tidak valid!\n";
        }
    } while (choice != 0);
    return 0;
}
