final String WRITE_TO = "coded_text.txt";

PrintWriter output;
PImage img;
int tour, drawPath;
int i,j, w, h;
boolean code = false;

void setup() {
  size(512, 512);
  img = loadImage("data.bmp");
  w=img.width;
  h=img.height;
  loadPixels();
  final String CODED_INPUT = coder();
  output = createWriter(WRITE_TO);
  output.print(CODED_INPUT);
  output.flush();
  output.close();
}

void draw() {
  background(img);
}

String getColorString(final color c) {
  if (red(c) == 255 && green(c) == 255 && blue(c) == 255) return "FFH";
  return "00H";
}

String coder() {
  img.loadPixels();
  int repetition = 1, difference = 1;
  color c, previousC;
  String output = "", differentChars = "";
  c = img.get(0,0);
  previousC = c;
  for (int x = 1; x < w; x++ ) {
    for (int y = 0; y < h; y++ ) {
    previousC = c;
    c = img.get(y,x);
    if (c == previousC) {
      if (repetition >= 32767) {
        output = output + coderRepetition(repetition) + getColorString(previousC);
        differentChars="";
        difference = 1;
        repetition = 1;
      } else if (repetition >= 3) {
        if (difference > 3) {
          //Coder difference en H
          output = output + coderDifference(difference-3) + differentChars.substring(0, differentChars.length()-9);
        }
        difference = 1;
        differentChars="";
      } else {
        if (difference >= 32767) {
           output = output + coderDifference(difference) + differentChars;
           difference = 1;
           differentChars = "";
        }
        difference++;
        differentChars = differentChars + getColorString(previousC);
      }
      
      repetition++;
    } else {
      if (repetition >= 32767) {
        output = output + coderRepetition(repetition) + getColorString(previousC);
        differentChars="";
        difference = 1;
        repetition = 1;
      } else if (repetition >= 3) {
        if (difference > 3) {
          //Coder difference en H
          output = output + coderDifference(difference-3) + differentChars.substring(0, differentChars.length()-9);
        }
        //Calculer la valeur de repetition en H
        output = output + coderRepetition(repetition) + getColorString(previousC);
        differentChars="";
        difference = 1;
      } else {
        if (difference >= 32767) {
           output = output + coderDifference(difference) + differentChars;
           difference = 1;
           differentChars = "";
        }
        difference++;
        differentChars = differentChars + getColorString(previousC);
      }
      repetition = 1;
    }
  }
  }
  if (repetition >= 32767) {
    output = output + coderRepetition(repetition) + getColorString(previousC);
    differentChars="";
    difference = 1;
    repetition = 1;
  } else if (repetition >= 3) {
    //Calculer la valeur de repetition en H
    output = output + coderRepetition(repetition) + getColorString(previousC);
  } else {
    if (difference >= 32767) {
       output = output + coderDifference(difference) + differentChars;
       difference = 1;
       differentChars = "";
    }
    differentChars = differentChars + getColorString(c);
    output = output + coderDifference(difference) + differentChars;
  }
  return output;
}

String coderDifference(int difference) {
  String value = "";
  value = Integer.toString(difference + 65536, 16);
  String tValue = "";
  for (int i = 1; i < value.length(); i++) {
    tValue = tValue + value.charAt(i);
  }
  return "("+tValue.toUpperCase()+"H)";
}

String coderRepetition(int repetition) {
  String value = "";
  value = Integer.toString(repetition + 32768, 16);
  return "("+value.toUpperCase()+"H)";
}
