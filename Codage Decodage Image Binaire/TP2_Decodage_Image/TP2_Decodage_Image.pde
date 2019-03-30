final String READ_FROM = "coded_image.dat";
final String IMAGE_NAME = "uncoded.bmp";

String input_text;

PrintWriter output;

String uncoded = null;
boolean drawn = false;

void setup() {  
  size(512,512);
}

PImage decoderImage() {
  final byte[] bytes = loadBytes(READ_FROM);
  color black = color(0,0,0);
  color white = color(255,255,255);
  color activeColor;
  PImage img = createImage(512, 512, RGB);
  img.loadPixels();
  int i = 0, j = 0, pix = 0;
  int repetition, value;
  
  while (i < bytes.length) {
    repetition = getRepetition(bytes[i], bytes[i+1]);
    if (repetition > 32768) {
      repetition = repetition - 32768;
      value = byteToInt(bytes[i+2]);
      activeColor = (value == 255) ? white : black;
      for (j = 0; j < repetition; j++) {
         img.pixels[pix+j] = activeColor;
      }
      pix = pix + repetition;
      i += 3;
    } else {
      i += 2;
      j = i;
      i += repetition;
      while (j < i) {
        value = byteToInt(bytes[j]);
        activeColor = (value == 255) ? white : black;
        img.pixels[pix] = activeColor;
        pix++;
        j++;
      }
    }
  }
  
  img.updatePixels();
  image(img, 0, 0);
  return img;
}

int getRepetition(byte byte1, byte byte0) {
  int value = (byte1 & 0xff) << 8;
  return value + (byte0 & 0xff); 
}

int byteToInt(byte b) {
  return b & 0xff;
}

void draw() {
  if (!drawn) {
    drawn = true;
    background(decoderImage());
    saveFrame(IMAGE_NAME);
  }
}
