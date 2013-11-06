program rusclear4;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils;

{
rus 168, 184, 192-255
eng 65-90, 97-122, [48-57]
# 35
( 40
) 41
{ 123
} 125
, 44
- 45
. 46
: 58
; 59
! 33
? 63
\ 92
/ 47
  32
0 48
1 49
2 50
3 51
4 52
5 53
6 54
7 55
8 56
9 57
}
  procedure commadelimeter(var sost3, sost4, sost5: integer);
  begin
    if sost5 = 0 then
    begin
      writeln('=CommaDelimeter=');
      sost5 := 1;
      sost4 := 0;
      sost3 := 0;
    end;
  end;

  procedure delimeter(var sost4: integer);
  begin
    writeln('=Delimeter=');
    sost4 := 0;
  end;

  procedure output(line: integer; p: string; var sost4: integer);
  var
    s: string;
    i, n: integer;
  begin

    if sost4 = 1 then
    begin
      s := '';
      n := length(p);
      writeln('=bl=');
      writeln(line, '-', p);
      for i := 1 to n do
      begin
        if p[i] = '-' then
        begin
          writeln(line, '-', s);
          s := '';
        end
        else
        begin
          s := s + p[i];
        end;
      end;
      writeln(line, '-', s);
      writeln('=el=');
    end
    else
    begin
      writeln(line, '-', p);
    end;
    sost4 := 0;
  end;

const
  fulllog =false;
var
  k, sost, n, i, l: integer;
  sost2: integer;//language-control
  sost3: integer;//prev=delimeter
  sost4: integer;//has(-)
  sost5: integer;//prev=commadelimeter
  //bp1,bp2:boolean;
  s, p: string;
begin
  sost := 0;
  sost3 := 0;
  sost4 := 0;
  sost5 := 0;
  p := '';
  sost2 := 0;
  l := 0;
  while not (EOF()) do
  begin
    Inc(l);
    k := 0;
    readln(s);
    //Utf8ToUnicode
    n := length(s);
    if sost <> 10 then
    begin
      if (sost2 = 1) then
        output(l - 1, p, sost4);
      sost := 0;
      sost2 := 0;
      p := '';
      sost4 := 0;
      sost5:=0;
    end;
    for i := 1 to n do
    begin
      k := Ord(s[i]);
      if fulllog then
        writeln('!', s[i], '|', Ord(s[i]), '|', p, '|', sost, '|', sost2,'|',sost5);
      case sost of
        0:
        begin //empty
          //writeln(sost,'|',k);
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            p := p + s[i];
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            sost := 2;
            p := p + s[i];
          end
          else
          if (k = 46) or (k = 58) or (k = 40) or (k = 41) or (k=123) or (k=125)or (k = 59) or
            (k = 33) or (k = 63) then
          begin
            if sost3 = 0 then
              delimeter(sost4);
            sost3 := 1;
            sost5 := 0;

          end
          else
          if (k = 44) then
          begin
            commadelimeter(sost3, sost4, sost5);
          end
          else
          if (k = 92) then
          begin
            sost := 11;
          end;
        end;
        1:
        begin   //russian
          sost2 := 1;
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            p := p + s[i];
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            if (sost2 = 1) then
              output(l, p, sost4);
            sost := 2;
            sost2 := 0;
            sost3 := 0;
            sost5 := 0;
            p := s[i];
          end
          else
          if (k = 46) or (k = 40) or (k = 41)  or (k=123) or (k=125)or (k = 58) or (k = 59) or
            (k = 33) or (k = 63) or (k = 44) then
          begin
            if (sost2 = 1) then
            begin
              output(l, p, sost4);
              sost3 := 0;
              sost5 := 0;
            end;
            if (k = 44) then
            begin
              commadelimeter(sost3, sost4, sost5);
            end
            else if sost3 = 0 then
            begin
              delimeter(sost4);
              sost5 := 0;
              sost3 := 1;
              sost4 := 0;
              end;
            sost := 0;
            sost2 := 0;
            p := '';
          end
          else
          if (k = 45) then
          begin
            sost := 10;
          end
          else
          if (k = 32) then
          begin
            sost := 3;
          end
          else
          if (k = 92) then
          begin
            sost := 11;
          end;
          //else writeln('!',s[i],'!');
        end;
        2:
        begin   //english
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            if (sost2 = 1) then
              output(l, p, sost4);
            sost3 := 0;
            sost5 := 0;
            p := s[i];
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            sost := 2;
            p := p + s[i];
          end
          else
          if (k = 46) or (k = 40) or (k = 41) or (k=123) or (k=125) or (k = 58) or (k = 59) or
            (k = 33) or (k = 63) or (k = 44) then
          begin
            if (sost2 = 1) then
            begin
              output(l, p, sost4);
              sost3 := 0;
              sost5 := 0;
            end;
            if (k = 44) then
            begin
              commadelimeter(sost3, sost4, sost5);
            end
            else if sost3 = 0 then
            begin
              delimeter(sost4);
              sost5 := 0;
              sost3 := 1;
              sost4 := 0;
              end;
            p := '';
            sost := 0;
            sost2 := 0;
          end
          else
          if (k = 44) then
          begin
            commadelimeter(sost3, sost4, sost5);
          end //======================================================================================
          else
          if (k = 45) then
          begin
            sost := 10;
          end
          else
          if (k = 32) then
          begin
            sost := 3;
          end
          else
          if (k = 92) then
          begin
            sost := 11;
          end;
        end;
        3:
        begin   //space
          if (k = 45) then
          begin
            sost := 10;
          end
          else
          if (k = 32) then
          begin
            sost := 3;
          end
          else
          begin
            sost := 0;
            if (sost2 = 1) then
            begin
              output(l, p, sost4);
              sost3 := 0;
              sost5 := 0;
            end;
            sost2 := 0;
            if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
            begin
              sost := 1;
              p := s[i];
            end
            else
            if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
              ((k > 47) and (k < 58)) then
            begin
              sost := 2;
              p := s[i];
            end
            else
            if (k = 92) then
            begin
              sost := 11;
            end
            else
            begin
              sost := 0;
              p := '';
              sost4 := 0;
            end;
          end;
        end;
        10:
        begin   //-
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            sost4 := 1;
            p := p + '-' + s[i];
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            sost := 2;
            p := p + '-' + s[i];
            sost4 := 1;
          end
          else
          if (k = 44) then
          begin
            commadelimeter(sost3, sost4, sost5);
          end //====================================================================================
          else
          if (k = 46) or (k = 40) or (k = 41)  or (k=123) or (k=125)or (k = 58) or (k = 59) or
            (k = 33) or (k = 63) then
          begin
            if (sost2 = 1) then
            begin
              output(l, p, sost4);
              sost3 := 0;
              sost5 := 0;
            end;
            if sost3 = 0 then
              delimeter(sost4);
            sost := 0;
            sost2 := 0;
            sost3 := 1;
            sost5 := 0;
          end;
        end;
        11:
        begin     //\
          if (k = 45) then
          begin
            sost := 12;
          end
          else
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            p := p + s[i];
          end
          else if (k=32) then
          begin
            p:='';
            sost:=0;
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            sost := 2;
            p := p + '\' + s[i];
          end
          else
          if (k = 44) then
          begin
            commadelimeter(sost3, sost4, sost5);
            p:='';
            sost:=0;
          end;

        end;
        12:
        begin   //\-
          if (k = 168) or (k = 184) or ((k > 191) and (k < 256)) then
          begin
            sost := 1;
            p := p + s[i];
          end
          else
          if ((k > 64) and (k < 91)) or ((k > 96) and (k < 123)) or
            ((k > 47) and (k < 58)) then
          begin
            sost := 2;
            p := p + s[i];
          end;
        end;
      end;
      //writeln(s[i],'|',ord(s[i]),'|',p,'|',sost);
    end;
  end;
end.

