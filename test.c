int main(){
    float x = 0.9;
    int y = 86;
    int z = 90e78;
    int toto, mim = 5;  

    if (x > 0.6){
        y = 5;
        printf("LOL");
    } else {
        y = 6;
    }

    int a = 0;
    while (!a){
        if (y <= 0){
            a = 1;
        } else {
            y = y - 1;
        }
    }
    printf("Ouais");
    int x = add(5, 6);

    return 0;
}

int add(int a, int b){
    return a + b;
}