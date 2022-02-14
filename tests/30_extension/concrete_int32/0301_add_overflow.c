{
  int x;
  int y;
  y = 1024; 
  x = y * y * y + 5; // 2^30 + 5
  x = x + x; // overflow > 2^31 - 1
  print(x);
}
