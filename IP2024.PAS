program IMAGE_PROCESSOR;
uses
  crt, dos, graph;

type
  draw = array [1..70] of byte;    { this array keeps the
                                       memory requirement of cursor }
  image = array [1..12899] of byte; { memory  for  image  saving}

const
  gray50: fillpatterntype = ($aa, $55, $aa, $55, $aa, $55, $aa, $55);

var

  imagefile: file of char;

  point_1: draw;

  user: image;

  gd, gm, X, xx, yy, y, k,
  typ, hig, z, cx, cy, ax, ay, pp, i, bx, by: integer;

  ch: char;


  count, x1, y1: integer;
  pelette:       palettetype;

  tri: array[1..3] of pointtype;
  filename, filenm, path: string;


  procedure cls;
  begin
    cleardevice;
    putimage(xx, yy, point_1, 1);
    putimage(x, y, point_1, 0);
    putimage(x, y, point_1, 0);
  end;
  procedure beep;
  begin
    sound(100);
    delay(80);
    nosound;
  end;

  procedure help;
  begin
    getimage(10, 10, 430, 190, user);
    putimage(xx, yy, point_1, 0);
    cls;
    settextstyle(10, horizdir, 1);
    rectangle(5, 5, 520, 198);
    rectangle(7, 7, 518, 196);
    outtextxy(50, 2, '* * * * *   H E L P   * * * * *');

    settextstyle(8, horizdir, 1);
    pp := 30;
    outtextxy(20, 15 + pp, 'F2 --> save  file    f3 -->  load file');
    outtextxy(20, 30 + pp, 'F9 --> capture image  f10 --> place image  ');
    outtextxy(20, 45 + pp, 'alt + s --> spray paint   alt + c --> circle  ');
    outtextxy(20, 60 + pp, 'alt + r --> rectangle     alt + l --> line   ');
    outtextxy(20, 75 + pp, 'shift + 1  -->  mark first  point ');
    outtextxy(20, 90 + pp, 'shift + 2  -->  mark second  point');
    outtextxy(20, 105 + pp, 'shift + 3  -->  mark third  point');
    outtextxy(20, 120 + pp, 'shift + f  --> set font style');
    outtextxy(20, 135 + pp, 'ctrl + z -->   Z O O M   ');
    ch := readkey;
    ch := readkey;
    cls;
    putimage(10, 10, user, 1);
    putimage(xx, yy, point_1, 0);
    putimage(x, y, point_1, 1);

  end;



  procedure save_image(filename: string);
  var
    xxx, yyy, coolour, currentColorCount: integer;
    colour, currentColor: char;
    cache, compressedCache, currentColorCountStr: string;
  begin
    assign(imagefile, filename);
    rewrite(imagefile);
    cache := '';
    for xxx := 1 to 640 do
    begin
      for yyy := 1 to 200 do
      begin
        coolour := getpixel(xxx, yyy);
        if coolour = 1 then
          colour := 'w' else colour := 'b';
        cache := cache + colour;
      end;
    end;

    {Run Length Encoding}
    currentColorCount := 1;
    currentColor := cache[1];
    compressedCache := '';
    for yyy := 2 to Length(cache) do
    begin
      if cache[yyy] = currentColor then
      begin
        currentColorCount := currentColorCount + 1;
      end
      else
      begin
        str(currentColorCount, currentColorCountStr);
        compressedCache := compressedCache + currentColor + currentColorCountStr + ',';
        currentColor := cache[yyy];
        currentColorCount := 1;
      end;
    end;

    for yyy := 1 to Length(compressedCache) do
    begin
      write(imagefile, compressedCache[yyy]);
    end;

    close(imagefile);beep;
  end;

  procedure image_retrive(filename: string);
  var
    xxx, yyy, coolour: integer;
    colour: char;
  begin
    assign(imagefile, filename);
               {IF IORESULT <> 0 THEN}

    reset(imagefile);

    begin
      for xxx := 1 to 640 do
      begin
        for yyy := 1 to 200 do
        begin
          read(imagefile, colour);
          if colour = 'w' then
            coolour := 1 else coolour := 0;
          putpixel(xxx, yyy, coolour);
        end;
      end;
    end;
    close(imagefile);beep;
  end;

  procedure zoom(x1, y1, x2, y2: integer);
  var
    x_len, y_len, x_ratio, y_ratio, a1x, a2x, a2y, a1y, b1x, b2x, b1y, b2y, count1, count2: integer;
             {image:array[1..9900] of integer;}
    piece: array[1..2640] of integer;
  begin
    getimage(x1, y1, x2, y2, user);
    putimage(0, 0, user, 0);
    x2 := x2 - x1;
    y2 := y2 - y1;
    x_ratio := round(640 / x2);
    Y_ratio := round(200 / y2);
    a1x := x2;a1y := 0;
    a2x := 639;a2y := 0;
    b1x := x2 + 1;
    b1y := y2;
    b2x := 640;
    b2y := y2;
    x_len := x2;
    y_len := y2;
    count1 := 1;count := 1;
    for count1 := 1 to x_len do
    begin
      a1x := a1x - 1; b1x := b1x - 1;
      getimage(a1x, a1y, b1x, b1y, piece);
                        {putimage(a1x,a1y,piece,1);}
      for count2 := 1 to x_ratio do
      begin
        a2x := a2x - 1;
        b2x := b2x - 1;
        putimage(a2x, a2y, piece, 0);
      end;
    end;
    a1x := 1;a1y := 0;b1x := 640;b1y := 1;
    a2x := 1;a2y := 199;b2x := 640;b2y := 200;
    for count1 := 1 to y_len do
    begin
      a1y := a1y + 1;b1y := b1y + 1;
      getimage(a1x, a1y, b1x, b1y, piece);
                            {putimage(a1x,a1y,piece,1);}
      for count2 := 1 to y_ratio do
      begin
        a2y := a2y - 1;b2y := b2y - 1;
        putimage(0, a2y, piece, 0);
      end;
    end;

  end;

   { ****************************************************************** }

begin             {      M A I N       P R O G R A M   }
  clrscr;
  textcolor(15);textbackground(13);
  window(12, 12, 30, 30);
  clrscr;
  gotoxy(10, 10);
  write('ENTER   PATH -->');readln(path);
  gotoxy(10, 30);

  write('ENTER FILE NAME TO BE PROCESSED -->');
  readln(filenm);
  filename := (path + filenm);

        {  G R A P H I C S       S T A R T S       F R O M    H E R E }

  gd := 1;gm := 4;
  InitGraph(gd, gm, 'C:\TP\bgi');

       {     L O A D I N G    I N T R O D U C T I O N     F I L E S    }

{       image_retrive('c:\ip\draw_2.img');
       delay(500);
       image_retrive('c:\ip\draw.img');
       delay(1000);
       image_retrive('c:\ip\oom.img');
       delay(1000);
 }



               {   I N T R O D U C T I O N      C O M P L E T E   }

  cls;
  getpalette(pelette);
       {  T R I A N G L E S   D E S I G N  }
       {
       setfillstyle(3,3);            
       while not keypressed do
             begin
                  setfillstyle(random(13),random(pelette.size)+1);
                  tri[1].x:=random(640);
                  tri[1].y:=random(170);
                  tri[2].x:=random(640);
                  tri[2].y:=random(170);
                  tri[3].x:=random(640);
                  tri[3].y:=random(170);
                  fillpoly(3,tri);
                  delay(50);
                  settextstyle(triplexfont,horizdir,4);
                  outtextxy(1,160,'I M A G E      P R O C E S S O R ');
             end;
       image_retrive('c:\ip\present.img');
       settextstyle(5,horizdir,4);
       outtextxy(140,40,'guided  by');
       outtextxy(180,90,' Mr  M . K .Raha');
       delay(5000);
       }

                   {  C U R S O R     F O R M A T I O N  }
  cls;
  help;
  ch := readkey;
  circle(10, 10, 8);
  setfillstyle(2, white);
  line(10, 2, 10, 18);line(0, 10, 20, 10);
  getimage(0, 0, 20, 20, point_1);

  cls;

  x := 320; y := 100; k := 4; z := 1;i := 0;

  repeat

    i := i + 1;
    xx := x;yy := y;
    ch := readkey;


                   {   G E T S     U S E R    K E Y

                       A N D     T A K E S    A C T I O N }

    begin
      case ord(ch) of

                   {  C U R S O R    M O V E M E N T   }

        72:
          y := y - k;
        73:
        begin y := y - k; x := x + k;end;
        77:
          x := x + k;
        81:
        begin y := y + k;x := x + k; end;
        80:
          y := y + k;
        79:
        begin y := y + k; x := x - k; end;
        75:
          x := x - k;
        71:
        begin y := y - k; x := x - k; end;

                  { * * * * * * * * * * * * * * * * * * * }

                     {    DIFFERENT  TYPES  OF PUTS   }

        129:
          z := 0;
        120:
          z := 1;
        121:
          z := 2;
        122:
          z := 3;
        123:
          z := 4;

                   { * * * * * * * * * * * * * * * * * * }

        19:
          rectangle(ax, ay, bx, by);   {  RECTANGLE  CREATION }



        38:
          line(ax, ay, bx, by);        {   LINE  }



        46:
          circle(ax, ay, (bx - ax));   {   CIRCLE }


        9:
          putimage(x, y, point_1, 1);   {  H I D I N G   C U R S O R }


                          {   DIFFERENT   POINTS  }

        33:
        begin ax := x + 9;ay := y + 9;putpixel(ax, ay, 1); end;
        35:
        begin cx := x + 9;cy := y + 9;putpixel(cx, cy, 1); end;
        64:
        begin bx := x + 9;by := y + 9;putpixel(bx, by, 1);end;

                   { * * * * * * * * * * * * * * * * * * }


                          { S P R A Y   B R U S H }

        31:
        begin
          randomize;
          for count := 1 to 10 do
          begin
            X1 := RANDOM(bx - ax);y1 := random(by - ay);
            putpixel(x1 + ax, y1 + ay, 1);
          end;
        end;

                           {   PATTERN   FILLING  }
        6:
        begin
          setfillstyle(random(13), random(pelette.size) + 1);
          setfillpattern(gray50, white);
          floodfill(cx, cy, 1);
        end;


                                {  Z O O M  }

        26:
          zoom(ax, ay, bx, by);


        43:
          k := k + 1;
        45:
          k := k - 1;
        67:
          getimage(ax, ay, bx, by, user);
        68:
          putimage(cx, cy, user, 1);
        59:
          help;
        3:
          cls;
        27:
          halt;

                         {  SETTING   FONT   TYPE   }

        70:
        begin

          restorecrtmode;
          textcolor(15);textbackground(13);
          window(12, 12, 45, 62);
          gotoxy(13, 13);
          write('ENTER font type & hight-->');readln(typ, hig);
          setgraphmode(getgraphmode);
          settextstyle(typ, horizdir, hig);
          putimage(0, 0, user, 0);
          putimage(xx, yy, point_1, 0);
          putimage(x, y, point_1, 1);
        end;

                             {  SAVING   FILE   }

        60:
        begin
          save_image(filename);
        end;

                           {  LOADING   FILE }
        61:
        begin

          restorecrtmode;
          textcolor(15);textbackground(13);
          window(12, 12, 45, 62);
          gotoxy(13, 13);
          write('ENTER FILE NAME -->');readln(filenm);
          filename := (path + filenm);
          setgraphmode(getgraphmode);
          image_retrive(filename);

        end;

                     {   WRITING   TEXT   }

        97:
          outtextxy(x, y, 'A');
        98:
          outtextxy(x, y, 'B');
        99:
          outtextxy(x, y, 'C');
        100:
          outtextXY(x, y, 'D');
        101:
          outtextXY(x, y, 'E');
        102:
          outtextxy(x, y, 'F');
        103:
          outtextxy(x, y, 'G');
        104:
          outtextxy(x, y, 'H');
        105:
          outtextxy(x, y, 'I');
        106:
          outtextxy(x, y, 'J');
        107:
          outtextxy(x, y, 'K');
        108:
          outtextxy(x, y, 'L');
        109:
          outtextxy(x, y, 'M');
        110:
          outtextxy(x, y, 'N');
        111:
          outtextxy(x, y, 'O');
        112:
          outtextxy(x, y, 'P');
        113:
          outtextxy(x, y, 'Q');
        114:
          outtextxy(x, y, 'R');
        115:
          outtextxy(x, y, 'S');
        116:
          outtextxy(x, y, 'T');
        117:
          outtextxy(x, y, 'U');
        118:
          outtextxy(x, y, 'V');
        119:
          outtextxy(x, y, 'W');
        120:
          outtextxy(x, y, 'X');
        121:
          outtextxy(x, y, 'Y');
        122:
          outtextxy(x, y, 'Z');
      end;{of case}

    end;

    putimage(xx, yy, point_1, z);
    putimage(x, y, point_1, z);
  until (1 < 0);
  restorecrtmode;

end. { of main }