program dictionary_manipulator_s3;
//compatible with rusclear4 & morph_cleaner5 (ind002.sh)
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
  //причастие {плм} 235 236 239
  //краткое причастие {c} 241
  //, 44
const
  biginteger = 50001;
  { outputsize = 100;}
type
  s30 = string

    [100];
  ar15 = array[0..biginteger - 1] of s30;

{  element = record
    word: s30;
    wtype: char;
  end;}

 { ar8 = record
    term: array[0..outputsize] of element;
    size: integer;
  end;}

var
  kio, all: ar15;
  alld: ar15;
  //outar: ar8;

  function cash(s: s30): integer;
  var
    i, l, a: integer;
  begin
    l := length(s);
    a := 0;
    for i := 1 to l do
    begin
      a := (a + Ord(s[i]) * i) mod biginteger;
    end;
    cash := a mod biginteger;
  end;

  procedure clear_table(var a: ar15);
  var
    i: integer;
  begin
    for i := 0 to biginteger - 1 do
    begin
      a[i] := '';
    end;
  end;

  procedure add_table(var a: ar15; word: s30);
  var
    k: integer;
  begin
    k := cash(word);
    while a[k] <> '' do
      k := (k + 1) mod biginteger;
    a[k] := word;
  end;

  function find_table(var a: ar15; word: s30): boolean;
  var
    k: integer;
  begin
    k := cash(word);
    while (a[k] <> '') and (a[k] <> word) do
    begin
      k := (k + 1) mod biginteger;
    end;
    find_table := (a[k] = word);
  end;

  procedure parseinput(s: s30; var s2: s30; var c: char);
  var
    a: integer;
  begin
    if s[1] = '=' then
    begin
      s2 := s;
      c := '=';
    end
    else
    begin
      a := pos(' ', s);
      s2 := copy(s, 1, a - 1);
      c := s[a + 1];
    end;
  end;

  procedure main(fulldic, gendic, termsdic: string);
  var
    dic_f, out_f, inp_f: textfile;
    s, s2: s30;
    c: char;
    //k,a,o:integer;
    sost: integer;
    vbp, halt0: boolean;
    //termlength:integer;
  begin
    //writeln('dms2 started');
    clear_table(kio);
    clear_table(all);
    clear_table(alld);
    assignfile(dic_f, fulldic);
    reset(dic_f);
    while not (EOF(dic_f)) do
    begin
      readln(dic_f, s);
      add_table(all, s);
    end;
    closefile(dic_f);
    assignfile(dic_f, termsdic);
    reset(dic_f);
    while not (EOF(dic_f)) do
    begin
      readln(dic_f, s);
      add_table(alld, s);
    end;
    closefile(dic_f);
    assignfile(dic_f, gendic);
    reset(dic_f);
    while not (EOF(dic_f)) do
    begin
      readln(dic_f, s);
      add_table(kio, s);
    end;
    closefile(dic_f);
    //writeln('dictionaries loaded');
    //termlength:=0;
    while True do
    begin
      readln(s);
      //writeln('Processing: |'+s+'|');
      if (length(s) > 1) then
      begin
        assignfile(inp_f, s);
        //writeln('Manipulation with ' + params[i]);
        assignfile(out_f, s + '.708');
        reset(inp_f);
        rewrite(out_f);
        sost := 0;
        vbp := False;
        halt0 := False;
        //s2:='';
        c := '-';
        while ((not (EOF(inp_f))) and (not (halt0))) do
        begin
          readln(inp_f, s2);
          parseinput(s2, s, c);
          //writeln(s2);
          //writeln(s,'|',c,'|',sost);
          if c = '=' then
          begin
            if (s = '=DELIMETER=') then
            begin
              if (sost = 0) and vbp then
                Writeln(out_f, s);
              if (sost = 0) then
                vbp := False;
            end;
            if (copy(s, 1, 6) = '==GL==') then
              Writeln(out_f, s2);
            if (s = '=BL=') and (sost = 0) then
            begin
              sost := 2;
              vbp := False;
            end;
            if (s = '=EL=') and (sost = 2) then
            begin
              sost := 0;
              if vbp then
                Writeln(out_f, '=DELIMETER=');
              vbp := False;
            end;
          end
          else
          begin
            if (find_table(all, s)) then             //esli ne mysor
            begin
              if not (find_table(kio, s)) then         //esli ne general lexic
              begin
                if (find_table(alld, s)) then
                begin
                  writeln(out_f, s);
                  vbp := True;
                end;
              end
              else
              begin
                if sost = 0 then
                begin
                  closefile(out_f);
                  rewrite(out_f);
                  Writeln(out_f, '==GL== ' + s);
                  //closefile(out_f);
                  halt0 := True;
                end;
              end;
            end;
          end;
        end;
        closefile(inp_f);
        closefile(out_f);
      end;
    end;
  end;


  procedure TMyApplication.DoRun;
  var
    ErrorMsg: string;
    //var
    //i: integer;
    //pampam: array[0..100000] of string;
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('h', 'help');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Halt;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Halt;
    end;
    if ParamCount <> 3 then
    begin
      writehelp;
      halt;
    end;

    main(params[1], params[2], params[3]);
    //sleep(1000);
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
    { add your help code here }
    writeln('Usage: ', ExeName,
      ' [-h] full_dictionary general_dictionary terms_dictionary');

  end;

var
  Application: TMyApplication;
begin
  Application := TMyApplication.Create(nil);
  Application.Title := 'My Application';
  Application.Run;
  Application.Free;
end.

