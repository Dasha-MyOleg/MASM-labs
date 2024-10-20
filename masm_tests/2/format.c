#include <stdio.h>
#include <windows.h>

// Декларація функції для експорту
__declspec(dllexport) void ShowValues() {
    char buffer[512];
    // Форматування чисел
    sprintf(buffer, "A: %d, -A: %d\nB: %d, -B: %d\nC: %d, -C: %d\nD: %f, -D: %f\nE: %f, -E: %f\nF: %lf, -F: %lf",
        4, -4, 402, -402, 4022005, -4022005, 0.001f, -0.001f, 0.078f, -0.078f, 781.555, -781.555);
    MessageBoxA(NULL, buffer, "Values of A, B, C, D, E, F", MB_OK);
}
