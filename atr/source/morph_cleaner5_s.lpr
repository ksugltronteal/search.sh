program morph_cleaner5_s;
//for FileTestLem3
//for dictionary_manipulator_308
{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  CustApp { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { TMyApplication }
{
 # 35
 - 45
 /n 10?
 к 234
 c
   32

   //причастие {плм} 235 236 239
   //краткое причастие {c} 241
   //глагол {к} 234
 }
 procedure reoutput(var t:textfile; s,s2:string);
 begin
   closefile(t);
   rewrite(t);
   writeln(t,s+' '+s2);
   closefile(t);
 end;
  procedure main(params: array of string);
  var
    end_f, inp_f: textfile;
  var
    nogl:boolean;//not only general lexic
    k, sost: integer;
    s : string;
    c: char;
    banned: boolean;
  begin
    assignfile(inp_f, params[0]);
    assignfile(end_f, params[1]);
    //assignfile(end2_f, params[2]);
    reset(inp_f);
    rewrite(end_f);
    //rewrite(end2_f);
    sost := 1; //-
    //sost2 := 0; //#
    //sost3 := 0; //oneline
    s := '';
    //s2 := '';
    banned := False;
    nogl:=false;
    while not (EOF(inp_f)) do
    begin
      Read(inp_f, c);
      k := Ord(c);
      //writeln(sost,':',k,'/',c,'|',s,'|');
      //sost2:=sost;
      case sost of
        {0:
        begin
          if k = 45 then
          begin
            sost := 1;
            s2 := s2 + c;
          end
          else if k = 32 then
          begin
            writeln(end_f, s2);
            s2 := '';
            sost := 10;
          end
          else
          begin
            s2 := s2 + c;
          end;
        end; }
        1:
        begin
          if (c='=') then
            begin
              readln(inp_f,s);
              k:=pos(' ',s);
              writeln(end_f,c+copy(s,1,k-1));
              s:='';
              nogl:=false;
            end
          else
          if k = 32 then
            sost := 2
          else
          begin
            s := s + c;
            //s2 := s2 + c;
          end;
        end;
        2:
        begin
          if (k = 234)or(k=241) then
          begin
            banned := True;
            //reoutput(end_f,'==GL==',s);
            //halt(0);
            //s := '';
            sost := 3;
          end
          else
            begin
            s:=s+' '+c;
            sost := 3;
            end;
        end;
        3:
        begin
          if k = 35 then
            sost := 4;
        end;
        4:
        begin
          if k = 10 then
          begin
            if not (banned) then
            begin
              writeln(end_f, s);
              writeln(end_f, '=DELIMETER=');
             // writeln(end2_f, s2);
            end
              else
              begin
                reoutput(end_f,'==GL==',s);
                halt(0);
              end;
             banned:=false;
             nogl:=false;
            s := '';
            //s2 := '';
            sost:=1;
          end
          else
          begin
            if not (banned) then
            begin
              //writeln(end_f, '==B==');
              nogl:=true;
              writeln(end_f, s);
              //writeln(end2_f, s2);
            end;
            banned:=false;
            s := '';
            //s2 := '';
            sost:=6;
            s:=s+c;
              //s2 := s2 + c;
          end;
        end;
        6:
        begin
          if k = 32 then
            sost := 7
          else
          begin
            s := s + c;
            //s2 := s2 + c;
          end;
        end;
        7:
        begin
          if (k = 234)or(k=241) then
          begin
            banned := True;
            //reoutput(end_f,'==GL==',s);
            //halt(0);
            //s := '';
            sost := 8;
          end
          else
          begin
            s:=s+' '+c;
            sost := 8;
            end;
        end;
        8:
        begin
          if k = 35 then
            sost := 9;
        end;
        9:
        begin
          if k = 10 then
          begin

            if not(banned) then
            begin
              writeln(end_f, s);
              writeln(end_f, '=DELIMETER=');
              //nogl:=true;
              //writeln(end2_f, s2);
            end
            else
             begin
               if nogl then  writeln(end_f, '=DELIMETER=')
               else
               begin
                reoutput(end_f,'==GL==',s);
                halt(0);
              end;
             end;
            banned:=false;
            nogl:=false;
            s := '';
            //s2 := '';
            sost:=1;
          end
          else
          begin
            if not (banned) then
            begin
              writeln(end_f, s);
              nogl:=true;
              //writeln(end2_f, s2);
            end;
             banned:=false;
            s := '';
            //s2 := '';

              //s2 := s2 + c;
              s:=s+c;
              sost:=6;


          end;
        end;
        10:
        begin
          if k = 10 then
            sost := 0;
        end;
      end;
      //writeln(sost,':',k,'/',c,'|',s,'|');
    end;



    {
    while not (EOF(inp_f)) do
    begin
      Read(inp_f, c);
      k := Ord(c);
      if k = 10 then
      begin
        if not (banned) then
        begin
          writeln(end2_f, s2);
        end;
        if sost3 = 1 then
          if not (banned) then
          begin
            writeln(end_f, s);
          end;
        if sost3 = 2 then
        begin
          if not (banned) then
          begin
            writeln(end_f, s);
          end;
          writeln(end_f, '==E==');
        end;

        banned := False;
        s := '';
        s2 := '';
        sost3 := 0;
        sost2 := 0;
      end
      else
        case sost of
          0:
          begin
            if k = 32 then
            begin
              sost := 2;
            end
            else
            begin
              if k = 35 then
              begin
                if not (banned) then
                begin
                  writeln(end_f, s);
                  writeln(end2_f, s2);
                end;
                banned := False;
                s := '';
                s2 := '';
              end
              else
              begin
                if sost3 = 1 then
                begin
                  sost3 := 2;
                  writeln(end_f, '==B==');
                end;
                if sost3 = 2 then
                begin
                  if not (banned) then
                  begin
                    writeln(end_f, s);
                  end;
                  banned := False;
                  s := '';
                  sost3 := 3;
                end;
                s := s + c;
                //s2:=s2+c;
              end;
              if k = 45 then
              begin
                sost := 1;
                s2 := s;//Write(end2_f, s);
                s := '';
                sost2 := 1;
              end;
            end;
          end;
          1:
          begin
            if k = 32 then
            begin
              sost := 2;
              s2 := '';
              if sost3 = 0 then
                sost3 := 1;
              if sost3 = 3 then
                sost3 := 2;
            end
            else
            begin
              if k = 35 then
              begin
                writeln(end2_f, s2);
                s2 := '';
                sost := 0;
                if sost3 = 0 then
                  sost3 := 1;
                if sost3 = 3 then
                  sost3 := 2;
              end
              else
              begin
                S := s + c;
                s2 := s2 + c;//Write(end2_f, c);
              end;
            end;
          end;
          2:
          begin
            if k = 195 then
            begin
              banned := True;
              s := '';
              sost := 0;
              writeln(end_f, '=DELIMETER=');
            end;
            if k = 35 then
            begin
              if not (banned) then
              begin
                writeln(end_f, s);
                writeln(end2_f, s2);
              end;
              banned := False;
              s := '';
              s2 := '';
              sost := 0;
            end;
          end;
        end;
    end;      }
    closefile(inp_f);
    closefile(end_f);
    //closefile(end2_f);
  end;


  procedure TMyApplication.DoRun;
  var
    ErrorMsg: string;
  var
    i: integer;
    pampam: array[1..4] of string;
  begin
    ErrorMsg := CheckOptions('h', 'help');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Halt;
    end;
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Halt;
    end;
    if ParamCount <> 2 then
    begin
      writehelp;
      halt;
    end;
    for i := 1 to 2 do
    begin
      pampam[i] := params[i];
    end;
    main(pampam);
    Terminate;
  end;

  constructor TMyApplication.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TMyApplication.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TMyApplication.WriteHelp;
  begin
    writeln('Usage: ', ExeName, ' [-h] cp1251-lem-file end-file ');

  end;

var
  Application: TMyApplication;
begin
  Application := TMyApplication.Create(nil);
  Application.Run;
  Application.Free;
end.

