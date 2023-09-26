program project;
uses crt,dos,graph;
type
    draw = array [1..70] of byte;    { this array keeps the memory requiremest of cursor}
    image = array [1..12800] of byte; { memory  for  image  saving}

var

   imagefile:file of char;
{   numb:array[1..14,1,,14]of}
   point_1 : draw;
   user:image;
   axx,ayy,bxx,qq,byy,gd ,xr,yr,p , gm , x , xx , yy , y , k , z , cx , cy , ax , ay ,i , bx ,by: integer;
   ch : char;
   count,coolour,x1,y1,xxx,yyy:integer;
   colour:char;
   pelette:palettetype;
   tri:array[1..3] of pointtype;


procedure cls;
          begin
               cleardevice;
               putimage(xx,yy,point_1,1);
               putimage(x,y,point_1,0);
               putimage(x,y,point_1,0);
          end;

procedure help;
          begin
               getimage(10,10,430,190,user);
               cls;
               settextstyle(triplexfont,horizdir,1);
               outtextxy(20,2,'* * * * h --> H E L P * * * * * *');
               outtextxy(0,15,'F1 --> HELP  ');
               outtextxy(0,25,'F3 --> capture image  b --> place image  ');
               outtextxy(0,65,'s --> spray paint     ');
               outtextxy(0,85,' re --> rectangle  l --> line   ');
               outtextxy(0,105,' p1 -->xor put');
               ch:=readkey;
               cls;
               putimage(10,10,user,1);
               putimage(xx,yy,point_1,0);
               putimage(x,y,point_1,1);

          end;
procedure save_image;
          begin
               assign(imagefile,'\students\xii\st32\draw_2.img');
               rewrite(imagefile);
               for xxx:=1 to 640 do
                   begin
                        for yyy:=1 to 200 do
                            begin
                                 coolour:=getpixel(xxx,yyy);
                                 if coolour=1 then colour:='w' else colour:='b';
                                 write(imagefile,colour);
                            end;
                   end;
               close(imagefile);
          end;
procedure image_retrive;
          begin
               assign(imagefile,'\students\xii\st32\draw_2.img');
               reset(imagefile);

               begin
               for xxx:=1 to 640 do
                   begin
                        for yyy:=1 to 200 do
                            begin
                                 read(imagefile,colour);
                                 if colour = 'w' then coolour:=1 else coolour:=0;
                                 putpixel(xxx,yyy,coolour);
                            end;
                   end;
               end;
               close(imagefile);
          end;
procedure image_retrive_2;
          begin
               assign(imagefile,'\students\xii\st32\draw.img');
               reset(imagefile);

               begin
               for xxx:=1 to 640 do
                   begin
                        for yyy:=1 to 200 do
                            begin
                                 read(imagefile,colour);
                                 if colour = 'w' then coolour:=1 else coolour:=0;
                                 putpixel(xxx,yyy,coolour);
                            end;
                   end;
               end;
               close(imagefile);

            end;
procedure image_retrive_3;
          begin
               assign(imagefile,'\students\xii\st32\oom.img');
               reset(imagefile);

               begin
               for xxx:=1 to 640 do
                   begin
                        for yyy:=1 to 200 do
                            begin
                                 read(imagefile,colour);
                                 if colour = 'w' then coolour:=1 else coolour:=0;
                                 putpixel(xxx,yyy,coolour);
                            end;
                   end;
               end;
               close(imagefile);

            end;
{procedure zoom;
          var

          begin

          end;}
   { *******************************************************************}

begin  { main }
       assign(imagefile,'\students\xii\st32\draw.img');
       reset(imagefile);
       gd:=1;gm:=4;
       initgraph(gd,gm,'');
       image_retrive_3;
       image_retrive_2;
       delay(1000);

       getpalette(pelette);
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
       circle(10,10,8);
       setfillstyle(2,white);
       line(10,2,10,18);line(0,10,20,10);
       getimage(0,0,20,20,point_1);
       cls;
       x:=320 ; y:=100 ; k:=4 ; z:=1;i:=0;
       repeat
       i:=i+1;
       xx:=x;yy:=y;
       ch:=readkey;
       {if (ch=#0) then}
       begin
       case ord(ch) of
            72:y:=y-k;
            73:begin y:=y-k; x:=x+k ;end;
            77:x:=x+k;
            81:begin y:=y+k;x:=x+k; end;
            80:y:=y+k;
            79:begin y:=y+k; x:=x-k; end;
            75:x:=x-k;
            71:begin y:=y-k; x:=x-k; end;
            129:z:=0;
            120:z:=1;
            121:z:=2;
            122:z:=3;
            123:z:=4;
            19:rectangle(ax,ay,bx,by);
            33:begin ax:=x+9;ay:=y+9;putpixel(ax,ay,1); end;
            35:begin cx:=x+9;cy:=y+9;putpixel(cx,cy,1); end;
            64:begin bx:=x+9;by:=y+9;putpixel(bx,by,1);end;
            31:begin
                     randomize;
                     for count := 1 to 5 do
                         begin
                              X1:=RANDOM(bx-ax);y1:=random(by-ay);
                              putpixel(x1+ax,y1+ay,1);
                         end;
                end;
            38:line(ax,ay,bx,by);
            46:begin {xr := int(sqrt((sqr(bx-ax))+(sqr(by-ay))))} ; circle(ax,ay,(bx-ax)); end;
            33:floodfill(cx,cy,1);
          {  'l':ellipse(ax,ay,360,0,abs(bx-cx),abs(by-cy));}
            3:cls;
            27:halt;
            43:k:=k+1;
            45:k:=k-1;
            61:getimage(ax,ay,bx,by,user);
            62:putimage(cx,cy,user,1);
            59:help;
            67:save_image;
            68:image_retrive;
            end;{of case}
       end;
       putimage(xx,yy,point_1,z);
       putimage(x,y,point_1,z);
       until (1<0);
end. { of main }
  'w':image_retrive;
            '*':begin
                     ch:=readkey;

                     case upcase(ch) of
                     'A':outtextxy(x,y,'A');
                     'B':outtextxy(x,y,'B');
                     'C':outtextxy(x,y,'C');
                     'D':outtextXY(x,y,'D');
                     'E':outtextXY(x,y,'E');
                     'F':outtextxy(x,y,'F');
                     'G':outtextxy(x,y,'G');
                     'H':outtextxy(x,y,'H');
                     'I':outtextxy(x,y,'I');
                     'J':outtextxy(x,y,'J');
                     'K':outtextxy(x,y,'K');
                     'L':outtextxy(x,y,'L');
                     'M':outtextxy(x,y,'M');
                     'N':outtextxy(x,y,'N');
                     'O':outtextxy(x,y,'O');
                     'P':outtextxy(x,y,'P');
                     'Q':outtextxy(x,y,'Q');
                     'R':outtextxy(x,y,'R');
                     'S':outtextxy(x,y,'S');
                     'T':outtextxy(x,y,'T');
                     'U':outtextxy(x,y,'U');
                     'V':outtextxy(x,y,'V');
                     'W':outtextxy(x,y,'W');
                     'X':outtextxy(x,y,'X');
                     'Y':outtextxy(x,y,'Y');
                     'Z':outtextxy(x,y,'Z');
                     end;
