void main() {
   int a;
   int b;
   int c;
   int d;
   
   while (1) {
      a = readIO(3);
      b = readIO(4);
      c = a+b;
      d = a-b;
      writeIO(1, c);
      writeIO(2, d);
   }

   return 0;
}
