program dictionary_manipulator_408;
//compatible with rusclear4 & morph_cleaner6 (ind003.sh)
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
  //глагол {к} 234
  //причастие {плм} 235 236 239
  //краткое причастие {c} 241
  //, 44
const
  biginteger = 300001;
  outputsize = 100;
type
  s30 = string

    [80];
  ar15 = array[0..biginteger - 1] of s30;

  element = record
    word: s30;
    wtype1: char;
    wtype2: char;
  end;

  ar8 = record
    term: array[0..outputsize] of element;
    size: integer;
  end;


var
  kio, all: ar15;
  alld: ar15;
  outar: ar8;
  pwd: boolean;

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

  procedure add2output(var a: ar8; w: s30; t1, t2: char);
  var
    b: element;
    i: integer;
  begin
    if a.size + 2 > outputsize then
    begin
      writeln('!dictionary_manipulator exception: too long term');
      for i := 0 to a.size - 1 do
      begin
        Write(a.term[i].word + ' ');
        a.term[i].word := '';
        a.term[i].wtype1 := ' ';
        a.term[i].wtype2 := ' ';
      end;
      writeln();
      a.size := 0;

    end;
    b.word := w;
    b.wtype1 := t1;
    b.wtype2 := t2;
    a.term[a.size] := b;
    a.size += 1;
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

  function min(a, b: integer): integer;
  begin
    if a < b then
      min := a
    else
      min := b;
  end;

  procedure parseinput(s: s30; var s2: s30; var c1, c2: char);
  var
    a: integer;
  begin
    if s[1] = '=' then
    begin
      s2 := s;
      c1 := '=';
      c2 := '=';
    end
    else
    begin
      a := pos(' ', s);
      s2 := copy(s, 1, a - 1);
      c1 := s[a + 1];
      c2 := s[min(length(s), a + 2)];
    end;
  end;

  procedure performOutput(var out_f: textfile; var a: ar8);
  var
    i, k1, k2: integer;
    lc: integer;
    ip: boolean;
  begin
    ip := False;
    lc := -1;
    for i := 0 to a.size - 1 do
    begin
      k1 := Ord(a.term[i].wtype1);
      k2 := Ord(a.term[i].wtype2);
      if (k1 = 44) then
      begin
        if lc >= 0 then
        begin
          a.term[lc].wtype1 := '.';
          a.term[lc].wtype2 := '.';
          a.term[lc].word := '=DELIMETER=';
        end;
        lc := i;
        if ip then
        begin
          ip := False;
          a.term[i].wtype1 := ' ';
          a.term[i].wtype2 := ' ';
          a.term[i].word := '';
          lc := -1;
        end;
      end;
      if ((k1 = 208) and ((k2 = 187) or (k2 = 188) or (k2 = 191))) then
      begin
        ip := True;
        if lc >= 0 then
        begin
          a.term[lc].wtype1 := ' ';
          a.term[lc].wtype2 := ' ';
          a.term[lc].word := '';
          lc := -1;
        end;
      end;
    end;
    if lc >= 0 then
    begin
      a.term[lc].wtype1 := '.';
      a.term[lc].wtype2 := '.';
      a.term[lc].word := '=DELIMETER=';
    end;
    for i := 0 to a.size - 1 do
    begin
      if (length(a.term[i].word) > 0) then
      begin
        if (a.term[i].word = '=DELIMETER=') then
        begin
          if not (pwd) then
          begin
            Write(out_f, a.term[i].word + ' ');
          end;
          pwd := True;
        end
        else
        begin
          Write(out_f, a.term[i].word + ' ');
          pwd := False;
        end;
      end;
      a.term[i].word := '';
      a.term[i].wtype1 := ' ';
      a.term[i].wtype2 := ' ';
    end;
    a.size := 0;
  end;

  procedure main(filecount: integer; fulldic, gendic, termsdic: string;
    params: array of string);
  var
    dic_f, out_f, inp_f: textfile;
    s, s2: s30;
    c1, c2: char;
    //k,a,o:integer;
    k1, k2: integer;
    i, sost, j: integer;
    vbp: boolean;
    //termlength:integer;
  begin
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
    //termlength:=0;
    for i := 0 to filecount - 1 do
    begin
      assignfile(inp_f, params[i]);
      writeln('Manipulation with ' + params[i]);
      assignfile(out_f, params[i] + '.708');
      reset(inp_f);
      rewrite(out_f);
      sost := 0;
      outar.size := 0;
      vbp := False;
      pwd := False;
      for j := 0 to outputsize do
      begin
        outar.term[j].word := '';
        outar.term[j].wtype1 := ' ';
        outar.term[j].wtype2 := ' ';
      end;
      //s2:='';
      c1 := '-';
      c2 := '-';
      while not (EOF(inp_f)) do
      begin
        readln(inp_f, s2);
        parseinput(s2, s, c1, c2);
        k1 := Ord(c1);
        k2 := Ord(c2);
        //writeln(sost, '|', s, '|', c1 + c2, '|', k1, '|', k2);
        if c1 = '=' then
        begin
          if (s = '=DELIMETER=') then
          begin
            //termlength:=0;
            performOutput(out_f, outar);
            if not (pwd) then
              Write(out_f, '=DELIMETER= ');
            pwd := True;
          end;
          if (s = '=COMMADELIMETER=') then
          begin
            //Write(out_f, '=DELIMETER= ');
            //termlength:=0;
            add2output(outar, s, ',', ',');
          end;
          if (s = '==B==') and (sost = 0) then
          begin
            sost := 1;
            vbp := True;
          end;
          if (s = '=BL=') and (sost = 0) then
          begin
            sost := 2;
            vbp := True;
          end;
          if (s = '==E==') and (sost = 1) then
          begin
            sost := 0;
            if vbp then
            begin
              performOutput(out_f, outar);
              if not (pwd) then
                Write(out_f, '=DELIMETER= ');
              pwd := True;
              //termlength:=0;
            end;
          end;
          if (s = '=EL=') and (sost = 2) then
          begin
            sost := 0;
            if vbp then
            begin
              performOutput(out_f, outar);
              if not (pwd) then
                Write(out_f, '=DELIMETER= ');
              //termlength:=0;
            end;
          end;
        end
        else
        begin
          if (((k1 = 208) and (k2 = 186)) or ((k1 = 209) and (k2 = 129))) then
          begin
            if (sost = 0) then
            begin
              performOutput(out_f, outar);
              if not (pwd) then
                Write(out_f, '=DELIMETER= ');
              pwd := True;
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

                  add2output(outar, s, c1, c2);
                  //Write(out_f, s + ' ');
                  vbp := False;
                  //if sost<>0 then
                  //termlength+=1;
                end;
              end
              else
              begin
                if sost = 0 then
                begin
                  performOutput(out_f, outar);
                  if not (pwd) then
                    Write(out_f, '=DELIMETER= ');
                  pwd := True;
                  //termlength:=0;
                end;
              end;
            end;
          end;
        end;
      end;
      performOutput(out_f, outar);
      closefile(inp_f);
      closefile(out_f);
    end;



  {
  while not(eof(all_f)) do
        begin

          readln(all_f,s);
          add_table(all,s);
        end;
  }
  {
    while not (EOF(inp_f)) do
    begin
      readln(inp_f, s);

      if not (find_table(kio, s)) then
      begin
        writeln(out_f, s);
      end
      else
      begin
        writeln(out_f, '=Delimeter=');
      end;

    end;   }

  end;


  procedure TMyApplication.DoRun;
  var
    ErrorMsg: string;
  var
    i: integer;
    pampam: array[0..100000] of string;
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
    if ParamCount < 4 then
    begin
      writehelp;
      halt;
    end;
    for i := 0 to paramcount - 3 do
    begin
      pampam[i] := params[i + 4];
    end;
    main(ParamCount - 3, params[1], params[2], params[3], pampam);
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
      ' [-h] full_dictionary general_dictionary terms_dictionary input_files');

  end;

var
  Application: TMyApplication;
begin
  Application := TMyApplication.Create(nil);
  Application.Title := 'My Application';
  Application.Run;
  Application.Free;
end.

