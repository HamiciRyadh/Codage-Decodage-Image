import java.io.FileOutputStream;

final String WRITE_TO = "coded_image.dat";

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
  coder();
}


void draw() {
  background(img);
}

byte getColor(final color c) {
  if (red(c) == 255 && green(c) == 255 && blue(c) == 255) return intTo2ByteArray(255)[1];
  return 0;
}

void coder() {
  try {
    File file = new File(dataPath("/"+WRITE_TO));
    file.createNewFile();
    OutputStream outputStream = new FileOutputStream(file);
    
    img.loadPixels();
    int repetition = 1, difference = 1;
    color c, previousC;
    ArrayList<Byte> differentChars = new ArrayList<Byte>();
    byte[] bytes;
    c = img.get(0,0);
    previousC = c;
    for (int x = 1; x < w; x++ ) {
      for (int y = 0; y < h; y++ ) {
        previousC = c;
        c = img.get(y,x);
        if (c == previousC) {
          if (repetition >= 32767) {
            outputStream.write(coderRepetition(repetition));
            outputStream.write(getColor(previousC));
            differentChars.clear();
            difference = 1;
            repetition = 1;
          } else if (repetition >= 3) {
            if (difference > 3) {
              bytes = new byte[differentChars.size()];
              for (int i = 0; i < differentChars.size()-3; i++) {
                bytes[i] = differentChars.get(i);
              }
              outputStream.write(coderDifference(difference-3));
              outputStream.write(bytes);
            }
            difference = 1;
            differentChars.clear();
          } else {
            if (difference >= 32767) {
                bytes = new byte[differentChars.size()];
                for (int i = 0; i < differentChars.size()-3; i++) {
                  bytes[i] = differentChars.get(i);
                }
                outputStream.write(coderDifference(difference-3));
                outputStream.write(bytes);
                difference = 1;
                differentChars.clear();
            }
            difference++;
            differentChars.add(getColor(previousC));
          }
          
          repetition++;
        } else {
          if (repetition >= 32767) {
            outputStream.write(coderRepetition(repetition));
            outputStream.write(getColor(previousC));
            differentChars.clear();
            difference = 1;
            repetition = 1;
          } else if (repetition >= 3) {
            if (difference > 3) {
                bytes = new byte[differentChars.size()];
                for (int i = 0; i < differentChars.size()-3; i++) {
                  bytes[i] = differentChars.get(i);
                }
                outputStream.write(coderDifference(difference-3));
                outputStream.write(bytes);
            }
            outputStream.write(coderRepetition(repetition));
            outputStream.write(getColor(previousC));
            differentChars.clear();
            difference = 1;
          } else {
            if (difference >= 32767) {
                 bytes = new byte[differentChars.size()];
                for (int i = 0; i < differentChars.size(); i++) {
                  bytes[i] = differentChars.get(i);
                }
                outputStream.write(coderDifference(difference));
                outputStream.write(bytes);
               difference = 1;
               differentChars.clear();
            }
            difference++;
            differentChars.add(getColor(previousC));
          }
          repetition = 1;
        }
      }
    }
    if (repetition >= 32767) {
      outputStream.write(coderRepetition(repetition));
      outputStream.write(getColor(previousC));
      differentChars.clear();
      difference = 1;
      repetition = 1;
    } else if (repetition >= 3) {
      outputStream.write(coderRepetition(repetition));
      outputStream.write(getColor(previousC));
    } else {
      if (difference >= 32767) {
         bytes = new byte[differentChars.size()];
         for (int i = 0; i < differentChars.size(); i++) {
           bytes[i] = differentChars.get(i);
         }
         outputStream.write(coderDifference(difference));
         outputStream.write(bytes);
         difference = 1;
         differentChars.clear();
      }
      differentChars.add(getColor(c));
      bytes = new byte[differentChars.size()];
      for (int i = 0; i < differentChars.size(); i++) {
        bytes[i] = differentChars.get(i);
      }
      outputStream.write(coderDifference(difference));
      outputStream.write(bytes);
    }
    outputStream.flush();
    outputStream.close();
  } catch (Exception e) {
    e.printStackTrace();
  }
}

byte[] coderDifference(int difference) {
  return intTo2ByteArray(difference);
}

byte[] coderRepetition(int repetition) {
  repetition = repetition + 32768;
  return intTo2ByteArray(repetition);
}

byte[] intTo2ByteArray(int value) {
  final byte[] bytes = new byte[2];
  
  bytes[0] = byte((value >> 8) & 0xff);
  bytes[1] = byte((value >> 0) & 0xff);
  
  return bytes;
}
