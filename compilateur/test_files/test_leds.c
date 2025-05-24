void main() {
    int ledd;
    int ledg;
    int dlcount;
    int dlcount2;
    int dlval;

    ledd = 1;
    ledg = 128;

    while (1) {
        if (ledd == 128) {
            ledd = 1;
        }
        if (ledg == 1) {
            ledg = 128;
        }
	ledd = ledd * 2;
        ledg = ledg / 2;
        writeIO(2, ledd);
        writeIO(1, ledg);

        dlval = readIO(4)*255;
        dlcount = 0;
        dlcount2 = 0;
        while (dlcount < dlval) {
            dlcount = dlcount + 1;
            while (dlcount2 < 255) {
		dlcount2 = dlcount2 + 1;
	    }
        }
    }
}

