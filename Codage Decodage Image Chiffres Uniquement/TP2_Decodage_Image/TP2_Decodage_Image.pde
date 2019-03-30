final String READ_FROM = "coded_text.txt";
final String IMAGE_NAME = "uncoded.bmp";

String input_text;

PrintWriter output;

String uncoded = null;
boolean drawn = false;

void setup() {
  input_text = parseFile(READ_FROM);
  println("Input : " + input_text);
  size(512,512);
}

String parseFile(final String FILE_NAME) {
  // Open the file from the createWriter() example
  BufferedReader reader = createReader(FILE_NAME);
  String line = null;
  String result = "";
  try {
    while ((line = reader.readLine()) != null) {
      result = result + line;
    }
    reader.close();
  } catch (Exception e) {
    e.printStackTrace();
    return "An error occured.";//default stirng
  }
  return result;
}

PImage decoderImage(final String INPUT) {
  color black = color(0,0,0);
  color white = color(255,255,255);
  color activeColor;
  PImage img = createImage(512, 512, RGB);
  img.loadPixels();
  int i = 0, j = 0, pix = 0;
  int repetition, value;
  while (i < INPUT.length()) {
    repetition = valueHexa(INPUT.substring(i,i+4));
    if (repetition > 32768) {
      repetition = repetition - 32768;
      value = valueHexa(INPUT.substring(i+4,i+6));
      activeColor = (value == 255) ? white : black;
      for (j = 0; j < repetition; j++) {
         img.pixels[pix+j] = activeColor;
      }
      pix = pix + repetition;
      i = i + 6;
    } else {
      i = i + 4;
      j = i + repetition * 2;
      while (i < j) {
        value = valueHexa(INPUT.substring(i,i+2));
        activeColor = (value == 255) ? white : black;
        img.pixels[pix] = activeColor;
        pix++;
        i = i + 2;
      }
    }
  }
  
  img.updatePixels();
  image(img, 0, 0);
  return img;
}

int valueHexa(final String HEX_INPUT) {
  return Integer.parseInt(HEX_INPUT, 16);
}

void draw() {
  if (!drawn) {
    drawn = true;
    background(decoderImage(input_text));
    saveFrame(IMAGE_NAME);
  }
}
