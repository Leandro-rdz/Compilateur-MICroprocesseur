int main(){
    int a = 7;
    int b = &a;
    a = a * *b;
    printf("a");
    *a = 2; 
}