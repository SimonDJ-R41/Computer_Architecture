#include <stdio.h>
int main() {
  float x, y, z;
  x = 10;
  y = 10;
  z = x + 3 * x / (y - 4);

  printf("Type a number X: \n" );
  float X, Y;
  float X1 = scanf("%f", &X);
  printf("Type a number Y: \n" );
  float Y1 = scanf("%f", &Y);

  float Z = X + 3 * X / (Y - 4);
  printf("The result for x = %.4f and y = %.4f is %.4f.\n", X, Y, Z);
  return 0;
}
