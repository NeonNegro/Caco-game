unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  StdCtrls, Buttons, MPlayer, Math, jpeg, inifiles;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    MediaPlayer1: TMediaPlayer;
    TmrTempoJogo: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure desenhaPassando();
    procedure desenhaComendo();
    procedure desenhaBatendo();
    procedure MediaPlayer1Exit(Sender: TObject);
    procedure iniciaFase;
    procedure inicioDurIEE(Nivel : Integer);
    procedure inicioNivel;
    procedure inicioCiclo;
    procedure gravaResposta;
    procedure botaocimaClick();
    procedure botaobaixoClick();
    function  calculaResposta:Boolean;
    procedure exibeRespostaVisual(Acertou: Boolean);
    procedure exibeResposta();
    procedure desenhaTarjaEsquerda();
    procedure desenhaTarjaDireita();
    procedure desenhaTarjaNormal();
    procedure desenhaTarjaSom();
    procedure exemploFase();
    procedure contaAcertos();
    procedure TmrTempoJogoTimer(Sender: TObject);
    procedure validaSons();
    procedure redesenhaTarjaInicialCanvasVidas();
  private
    { Private declarations }
  public
    { Public declarations }
    arraySom : array of String;
    arrayResp : array of Integer;
    clickbotaocima : Boolean;
    clickbotaobaixo : Boolean;
    bmpsetacima : TBitmap;

    faseAtual : Integer;
    questaoAtual : Integer;
    tentativaAtual : Integer;
    totalTentativas : Integer;
    resposta0 : Integer;
    resposta1 : Integer;
    resposta2 : Integer;
    qtdAcerto : Integer;
    pontos    : Integer;
    qtdCiclos : Integer;// Frequencia
    qtdNiveis : Integer;
    qtdDurIEE: Integer;
    cicloAtual: Integer;
    nivelAtual: Integer;
    durIEEAtual:Integer;
    arrayFase : array of String;
    arrayCiclos: array of String;
    arrayNiveis: array of String;
    arrayDurIEE: array of String;

    nomeDoUsuario : String;
    nomeArqResultado : String;
    arqConfiguracao : String;

    backgroundImage : TImage;
    spriteImage : TImage;
    tarjaInicial : TImage;
    imgSair : TImage;
    tarjaSom : TImage;
    tarjaEsquerda : TImage;
    tarjaDireita : TImage;
    arrayImgCacoPassando : array of TImage;
    arrayImgCacoBatendo : array of TImage;
    arrayImgCacoComendo : array of TImage;
    arrayImgVida : array of TImage;
    cacoAtual : Integer;
    totalCacoPassando : Integer;
    totalCacoBatendo : Integer;
    totalCacoComendo : Integer;
    totalVidas : Integer;
    totalCenarioBananaPassando : Integer;
    vidaAtual : Integer;
    backgroundCanvas : TCanvas;
    workCanvas : TCanvas;
    tarjaNormalCanvas : TCanvas;
    tarjaRect :TRect;
    backgroundRect, spriteRect, changeRect, paddleRect, changePaddleRect :TRect;
    x, y, xDir, yDir, paddleX, paddleY, paddleCenter, Angle : integer;
    som : Boolean;
    acao : Integer;
    tipoJogo : Integer;
    qtdRsp : Integer;
    exemplo : Boolean;
    exibeSomAtual : Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses MMSystem, Unit2, Unit3, Unit4, Unit5;

procedure TForm1.FormActivate(Sender: TObject);
var
  backgrounddc, workdc, tarjaNormaldc : HDC;
  bkbmp, bmp, tnbmp : HBITMAP;
  imagemCacoPassado : String;
  i : Integer;
  ini: TIniFile;
  data : String;
  hora : String;
  passouTempo : Boolean;
  dataUltimoDia : String;
begin
  arqConfiguracao := '.\Configuracao.ini';
  ListaUsuarioInicio.ShowModal;
  nomeDoUsuario := ListaUsuarioInicio.CmbBxUsuario.Items.Strings[ListaUsuarioInicio.CmbBxUsuario.ItemIndex];
  if (nomeDoUsuario = 'Sem nome') or (Trim(nomeDoUsuario) = '') then
    Application.Terminate;
  ini := TIniFile.Create( arqConfiguracao );
  try
    passouTempo := ini.ReadBool( nomeDoUsuario+'-Caco', 'passouTempo', false );
    dataUltimoDia := ini.ReadString( nomeDoUsuario+'-Caco', 'ultimoDia', '' );
  finally
    ini.Free;
  end;
  if (dataUltimoDia = DateToStr(Now)) and ( passouTempo = true ) then
    FimForm.ShowModal
  else
  begin
    ini := TIniFile.Create( arqConfiguracao );
    try
      ini.WriteBool( nomeDoUsuario+'-Caco', 'passouTempo', false );
      ini.WriteString( nomeDoUsuario+'-Caco', 'ultimoDia', DateToStr(Now));
    finally
      ini.Free;
    end;
  end;
  data := DateToStr(Now);
  data := StringReplace(data,'/','', [rfReplaceAll, rfIgnoreCase]);
  hora := TimeToStr(Now);
  hora := StringReplace(hora,':','',[rfReplaceAll, rfIgnoreCase]);
  if (not DirectoryExists('.\rsp\'+nomeDoUsuario)) then
    CreateDir('.\rsp\'+nomeDoUsuario);
  nomeArqResultado := '.\rsp\'+nomeDoUsuario+'\caco-'+ nomeDoUsuario+'-'+data+'-'+hora +' '+'.rsp';
  pontos := 0;
  SetLength(arrayFase,4);
  arrayFase[0] := 'IGUAL DIFERENTE';
  arrayFase[1] := 'SETA DOIS      ';
  arrayFase[2] := 'SETA TRES      ';
  cacoAtual := 1;
  totalCacoPassando := 16;
  totalCacoBatendo := 20;
  totalCacoComendo := 22;
  totalCenarioBananaPassando := 25;
  som := false;
  acao := 4;
  //Inicio
  ini := TIniFile.Create( arqConfiguracao );
  try
    faseAtual := Ini.ReadInteger( nomeDoUsuario+'-Caco', 'faseAtual', 1 );
    nivelAtual := Ini.ReadInteger( nomeDoUsuario+'-Caco', 'nivelAtual', 1 );
    cicloAtual := Ini.ReadInteger( nomeDoUsuario+'-Caco', 'cicloAtual', 1 );
    durIEEAtual := Ini.ReadInteger( nomeDoUsuario+'-Caco', 'durIEEAtual', 1 );
    exibeSomAtual := Ini.ReadBool( nomeDoUsuario+'-Caco', 'exibeSomAtual', false );
  finally
    ini.Free;
  end;
  qtdNiveis := 6;
  qtdCiclos := 3;
  totalVidas := 3;
  totalTentativas := 12;
  exemplo := false;
  iniciaFase;
//  validaSons;

  SetLength(arrayImgCacoPassando, totalCacoPassando);
  SetLength(arrayImgCacoBatendo, totalCacoBatendo);
  SetLength(arrayImgCacoComendo, totalCenarioBananaPassando+totalCacoComendo);
  SetLength(arrayImgVida, totalVidas);
  backgroundImage := TImage.Create( Self );

  workCanvas := TCanvas.Create;
  backgroundCanvas := TCanvas.Create;
  tarjaNormalCanvas := TCanvas.Create;
  for i := 1 to totalCacoPassando do
  begin
    arrayImgCacoPassando[i-1] := TImage.Create( Self );
  end;

  for i := 1 to totalCacoBatendo do
  begin
    arrayImgCacoBatendo[i-1] := TImage.Create( Self );
  end;

  for i := 1 to totalCenarioBananaPassando + totalCacoComendo do
  begin
    arrayImgCacoComendo[i-1] := TImage.Create( Self );
  end;

  for i := 1 to totalVidas do
  begin
    arrayImgVida[i-1] := TImage.Create( Self );
  end;

  for i := 1 to totalCacoPassando do
  begin
    imagemCacoPassado := '.\caco\passando\caco_passando'+IntToStr(i)+'.jpg';
    arrayImgCacoPassando[i-1].Picture.LoadFromFile(imagemCacoPassado);
  end;
  for i := 1 to totalCacoBatendo do
  begin
    imagemCacoPassado := '.\caco\batendo\caco_batendo'+IntToStr(i)+'.jpg';
    arrayImgCacoBatendo[i-1].Picture.LoadFromFile(imagemCacoPassado);
  end;
  for i := 1 to totalCenarioBananaPassando do
  begin
    imagemCacoPassado := '.\caco\cenario_passando_banana\cenario_passando_banana'+IntToStr(i)+'.jpg';
    arrayImgCacoComendo[i-1].Picture.LoadFromFile(imagemCacoPassado);
  end;

  for i := 1 to totalCacoComendo do
  begin
    imagemCacoPassado := '.\caco\comendo\caco_comendo'+IntToStr(i)+'.jpg';
    arrayImgCacoComendo[totalCenarioBananaPassando+i-1].Picture.LoadFromFile(imagemCacoPassado);
  end;

  for i := 1 to totalVidas do
  begin
    imagemCacoPassado := '.\caco\tarja\vida'+IntToStr(i)+'.bmp';
    arrayImgVida[i-1].Picture.Bitmap.Mask(clWhite);
    arrayImgVida[i-1].Picture.Bitmap.Transparent := true;
    arrayImgVida[i-1].Picture.Bitmap.TransparentColor := clWhite;
    arrayImgVida[i-1].Picture.Bitmap.TransparentMode := tmAuto;
    arrayImgVida[i-1].Transparent := true;
    arrayImgVida[i-1].Picture.LoadFromFile(imagemCacoPassado);
  end;

  backgroundImage.Picture.LoadFromFile('.\caco\cenarios\cenario_parado.bmp');


  WindowState := wsMaximized;

  backgroundRect.Top := 0;
  backgroundRect.Left := 0;
  backgroundRect.Right :=  ClientWidth;
  backgroundRect.Bottom :=  ClientHeight;


  //Set up backgroundCanvas
  backgrounddc := CreateCompatibleDC(Canvas.Handle);
  bkbmp := CreateCompatibleBitmap(Canvas.Handle, ClientWidth, ClientHeight);
  SelectObject(backgrounddc, bkbmp);
  SelectPalette(backgrounddc, backgroundImage.Picture.Bitmap.Palette, false);
  backgroundCanvas.Handle := backgrounddc;
  backgroundCanvas.StretchDraw( backgroundRect, backgroundImage.Picture.Bitmap);


  //Set up workCanvas
  workdc := CreateCompatibleDC(Canvas.Handle);
  bmp := CreateCompatibleBitmap(Canvas.Handle, ClientWidth, ClientHeight);
  SelectObject(workdc, bmp);
  SelectPalette(workdc, backgroundImage.Picture.Bitmap.Palette, false);
  workCanvas.Handle := workdc;
  workCanvas.CopyRect(backgroundRect,  backgroundCanvas, backgroundRect);
  if som then
    workCanvas.StretchDraw( backgroundRect, tarjaSom.Picture.Bitmap)
  else
    workCanvas.StretchDraw( backgroundRect, tarjaInicial.Picture.Bitmap);

  workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  //Set up tarjaNormaldc
  tarjaNormaldc := CreateCompatibleDC(Canvas.Handle);
  tnbmp := CreateCompatibleBitmap(Canvas.Handle, ClientWidth, ClientHeight);
  SelectObject(tarjaNormaldc, tnbmp);
  SelectPalette(tarjaNormaldc, backgroundImage.Picture.Bitmap.Palette, false);
  tarjaNormalCanvas.Handle := tarjaNormaldc;
  tarjaNormalCanvas.CopyRect(backgroundRect,  backgroundCanvas, backgroundRect);
  tarjaNormalCanvas.StretchDraw( backgroundRect, tarjaInicial.Picture.Bitmap);
  tarjaNormalCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  RealizePalette(tarjaNormalCanvas.Handle);
  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  workCanvas.Brush.Style := bsClear;
  workCanvas.Font.Name := 'Century';
  workCanvas.Font.Style := [fsBold];
  Canvas.CopyRect(backgroundRect, workCanvas, backgroundRect);
  Timer1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //Assign idle time function
      ShowCursor(true);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  changeRect := spriteRect;
  spriteRect.Left := 0;
  spriteRect.Top := 0;
  spriteRect.Right := 0 + ClientWidth;
  spriteRect.Bottom := 0 + ClientHeight;

  workCanvas.CopyRect(spriteRect, backgroundCanvas, spriteRect);
  if acao = 1 then
    desenhaPassando()
  else if acao = 2 then
    desenhaBatendo()
  else if acao = 3 then
    desenhaComendo();

//  workCanvas.StretchDraw( backgroundRect, tarjaInicial.Picture.Bitmap);
  //desenhaVidas
//  if (vidaAtual > 0) then
//    workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  tarjaRect.Left := 0;
  tarjaRect.Top := Floor(ClientHeight*0.83);
  tarjaRect.Right := 0 + ClientWidth;
  tarjaRect.Bottom := 0 + ClientHeight;
  workCanvas.CopyRect(tarjaRect, tarjaNormalCanvas, tarjaRect);

  workCanvas.Font.Size := 20;
  workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.85),'PONTOS '+IntToStr(pontos));
  if exibeSomAtual then
    workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.92),'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]);
//  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  Canvas.CopyRect(changeRect, workCanvas, changeRect);

end;



procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ( acao = 0) then
  begin
    if ((x/ClientWidth) > 0.4) and ((x/ClientWidth) < 0.56) and ((y/ClientHeight) > 0.75) then
    begin
      if (tentativaAtual <= totalTentativas) and
         (resposta1 <> -1) and (resposta2 <> -1)then
        begin
          acao := 0;
          tentativaAtual := tentativaAtual +1;
          //LabelQuestao.Caption := IntToStr(tentativaAtual);
          Randomize;
          questaoAtual := RandomRange(1,(qtdRsp)*100);
          questaoAtual := Floor(questaoAtual/100);
          desenhaTarjaSom();
          MediaPlayer1.FileName := arraySom[questaoAtual];
          MediaPlayer1.Wait := true;
          MediaPlayer1.Notify := true;
          MediaPlayer1.Open;
          MediaPlayer1.Play;
          Sleep(800);
          desenhaTarjaNormal();

         if (faseAtual = 1) then
           begin
            resposta0 := 0;
            resposta1 := 0;
            resposta2 := -1;
           end
         else if (faseAtual = 2) then
           begin
            resposta0 := 0;
            resposta1 := -1;
            resposta2 := -1;
           end
         else
           begin
            resposta0 := -1;
            resposta1 := -1;
            resposta2 := -1;
           end;
        end
      else if tentativaAtual = totalTentativas+1 then
        begin
{          if (cicloAtual < qtdCiclos) then
          begin
            cicloAtual := cicloAtual+1;
            inicioCiclo;
            desenhaTarjaNormal();
          end
          else if (nivelAtual < qtdNiveis) then
          begin
            nivelAtual := nivelAtual+1;
            inicioNivel;
            desenhaTarjaNormal();
          end
          else
          begin
            faseAtual := faseAtual+1;
            iniciaFase;
            desenhaTarjaNormal();
            exemploFase;
          end;
}
          if (durIEEAtual < qtdDurIEE) then
          begin
            durIEEAtual := durIEEAtual+1;
            inicioCiclo;
            FormMouseDown(Sender,Button,Shift,X,Y);
          end
          else if (faseAtual < 3) then
          begin
            faseAtual := faseAtual+1;
            durIEEAtual := 1;
            iniciaFase;
            desenhaTarjaNormal();
            exemploFase;
          end
          else if (cicloAtual < qtdCiclos) then
          begin
            cicloAtual := cicloAtual+1;
            durIEEAtual := 1;
            faseAtual := 1;
            iniciaFase;
            desenhaTarjaNormal();
            exemploFase;
          end
          else if (nivelAtual < qtdNiveis) then
          begin
            nivelAtual := nivelAtual+1;
            durIEEAtual := 1;
            cicloAtual := 1;
            faseAtual := 1;
            iniciaFase;
            desenhaTarjaNormal();
            exemploFase;
          end;
        end;
    end
    else if ((x/ClientWidth) > 0.26875) and ((x/ClientWidth) < 0.3625)
        and ((y/ClientHeight) > 0.75) then
    begin // esquerda
      botaobaixoClick();
      desenhaTarjaEsquerda();
      Sleep(80);
      desenhaTarjaNormal();
    end
    else if ((x/ClientWidth) > 0.63125) and ((x/ClientWidth) < 0.73125)
        and ((y/ClientHeight) > 0.75) then
    begin // Direita
      botaocimaClick();
      desenhaTarjaDireita();
      Sleep(80);
      desenhaTarjaNormal();
    end;
  end
  else if (acao = 4) then
  begin
    Timer1.Enabled := false;
    exemploFase();
  end;
end;

procedure TForm1.desenhaPassando();
begin
  if cacoAtual = 7 then
  begin
    MediaPlayer1.FileName := '.\caco\acerto.wav';
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
  //Perform dirty rectangle animation on memory and Form canvas
  workCanvas.StretchDraw(spriteRect, arrayImgCacoPassando[cacoAtual-1].Picture.Graphic);
  if cacoAtual = totalCacoPassando then
    begin
      cacoAtual := 1;
      if (tentativaAtual = totalTentativas+1) then
      begin
        pontos := pontos + qtdAcerto*10;
        qtdAcerto := 0;
        vidaAtual := totalVidas;
        redesenhaTarjaInicialCanvasVidas;
        if (durIEEAtual = qtdDurIEE) then
          acao := 3
        else
          acao := 0;
      end
      else
      begin
        acao := 0;
        Timer1.Enabled := false;
        desenhaTarjaNormal();
      end;
    end
  else
     cacoAtual := cacoAtual+1;
end;

procedure TForm1.desenhaComendo();
begin
  //Perform dirty rectangle animation on memory and Form canvas
    if cacoAtual = 26 then
  begin
    MediaPlayer1.FileName := '.\caco\proxima.wav';
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
  workCanvas.StretchDraw(spriteRect, arrayImgCacoComendo[cacoAtual-1].Picture.Graphic);

  if cacoAtual = totalCacoComendo+totalCenarioBananaPassando then
    begin
      cacoAtual := 1;
      acao := 0;
      Timer1.Enabled := false;
    end
  else
     cacoAtual := cacoAtual+1;
end;

procedure TForm1.desenhaBatendo();
begin
  //Perform dirty rectangle animation on memory and Form canvas
  if cacoAtual = 10 then
  begin
    MediaPlayer1.FileName := '.\caco\erro.wav';
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
  workCanvas.StretchDraw(spriteRect, arrayImgCacoBatendo[cacoAtual-1].Picture.Graphic);
  if cacoAtual = totalCacoBatendo then
    begin
      cacoAtual := 1;
      vidaAtual := vidaAtual -1;
      redesenhaTarjaInicialCanvasVidas;
      if vidaAtual >= 0 then
        begin
          if (tentativaAtual = totalTentativas+1) then
          begin
            pontos := pontos + qtdAcerto*10;
            qtdAcerto := 0;
            vidaAtual := totalVidas;
            redesenhaTarjaInicialCanvasVidas;
            if (durIEEAtual = qtdDurIEE) then
              acao := 3
            else
              acao := 0;
          end
        else
          begin
            acao := 0;
            Timer1.Enabled := false;
            desenhaTarjaNormal();
          end;
        end
      else
        begin
          acao := 0;
          Timer1.Enabled := false;
          MediaPlayer1.FileName := '.\caco\gameover.wav';
          MediaPlayer1.Wait := true;
          MediaPlayer1.Notify := true;
          MediaPlayer1.Open;
          MediaPlayer1.Play;
          FrmGameOver.ShowModal;
          vidaAtual := totalVidas;
          redesenhaTarjaInicialCanvasVidas;
          if durIEEAtual > 1 then
            durIEEAtual := durIEEAtual-1;
          pontos := 0;
          qtdAcerto := 0;
          tentativaAtual := 0;
          iniciaFase();
          exemploFase();
        end;
    end
  else
     cacoAtual := cacoAtual+1;
end;

procedure TForm1.MediaPlayer1Exit(Sender: TObject);
begin
   som := false;
end;

procedure TForm1.iniciaFase;
var
  ini: TIniFile;
begin
//  LabelFase.Caption := arrayFase[faseAtual];
//  tentativaAtual := 0;
//  qtdAcerto := 0;
//  vidaAtual := totalVidas;
//  LabelPontos.Caption := '0';
  ini := TIniFile.Create( arqConfiguracao );
  try
    ini.WriteInteger( nomeDoUsuario+'-Caco', 'faseAtual', faseAtual );
  finally
  ini.Free;
  end;
  tarjaInicial := TImage.Create( Self );
  tarjaSom := TImage.Create( Self );
  tarjaEsquerda := TImage.Create( Self );
  tarjaDireita := TImage.Create( Self );

  if (faseAtual = 1) or (faseAtual = 2 ) then
    qtdRsp := 4
  else
    qtdRsp := 8;

  SetLength(arraySom,qtdRsp);
  SetLength(arrayResp,qtdRsp);
  SetLength(arrayCiclos,qtdCiclos);

  arrayCiclos[0] := '500';
  arrayCiclos[1] := '1000';
  arrayCiclos[2] := '2000';

  if (faseAtual = 1) then
  begin
    arrayResp[0] := 1;
    arrayResp[1] := 0;
    arrayResp[2] := 0;
    arrayResp[3] := 1;
  end
  else if (faseAtual = 2) then
  begin
    arrayResp[0] := 0;
    arrayResp[1] := 1;
    arrayResp[2] := 2;
    arrayResp[3] := 3;
  end
  else
  begin
    arrayResp[0] := 0;
    arrayResp[1] := 1;
    arrayResp[2] := 2;
    arrayResp[3] := 3;
    arrayResp[4] := 4;
    arrayResp[5] := 5;
    arrayResp[6] := 6;
    arrayResp[7] := 7;
  end;

  if ( faseAtual = 2) or (faseAtual = 3) then
  begin
    tarjaInicial.Picture.Bitmap.Mask(clWhite);
    tarjaInicial.Picture.Bitmap.Transparent := true;
    tarjaInicial.Picture.Bitmap.TransparentColor := clWhite;
    tarjaInicial.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaInicial.Transparent := true;
    tarjaInicial.Picture.LoadFromFile('.\caco\tarja\seta1.bmp');

    tarjaSom.Picture.Bitmap.Mask(clWhite);
    tarjaSom.Picture.Bitmap.Transparent := true;
    tarjaSom.Picture.Bitmap.TransparentColor := clWhite;
    tarjaSom.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaSom.Transparent := true;
    tarjaSom.Picture.LoadFromFile('.\caco\tarja\seta1som.bmp');

    tarjaEsquerda.Picture.Bitmap.Mask(clWhite);
    tarjaEsquerda.Picture.Bitmap.Transparent := true;
    tarjaEsquerda.Picture.Bitmap.TransparentColor := clWhite;
    tarjaEsquerda.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaEsquerda.Transparent := true;
    tarjaEsquerda.Picture.LoadFromFile('.\caco\tarja\seta2.bmp');

    tarjaDireita.Picture.Bitmap.Mask(clWhite);
    tarjaDireita.Picture.Bitmap.Transparent := true;
    tarjaDireita.Picture.Bitmap.TransparentColor := clWhite;
    tarjaDireita.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaDireita.Transparent := true;
    tarjaDireita.Picture.LoadFromFile('.\caco\tarja\seta3.bmp');
  end
  else
  begin
    tarjaInicial.Picture.Bitmap.Mask(clWhite);
    tarjaInicial.Picture.Bitmap.Transparent := true;
    tarjaInicial.Picture.Bitmap.TransparentColor := clWhite;
    tarjaInicial.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaInicial.Transparent := true;
    tarjaInicial.Picture.LoadFromFile('.\caco\tarja\igual1.bmp');

    tarjaSom.Picture.Bitmap.Mask(clWhite);
    tarjaSom.Picture.Bitmap.Transparent := true;
    tarjaSom.Picture.Bitmap.TransparentColor := clWhite;
    tarjaSom.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaSom.Transparent := true;
    tarjaSom.Picture.LoadFromFile('.\caco\tarja\igual1som.bmp');

    tarjaEsquerda.Picture.Bitmap.Mask(clWhite);
    tarjaEsquerda.Picture.Bitmap.Transparent := true;
    tarjaEsquerda.Picture.Bitmap.TransparentColor := clWhite;
    tarjaEsquerda.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaEsquerda.Transparent := true;
    tarjaEsquerda.Picture.LoadFromFile('.\caco\tarja\igual2.bmp');

    tarjaDireita.Picture.Bitmap.Mask(clWhite);
    tarjaDireita.Picture.Bitmap.Transparent := true;
    tarjaDireita.Picture.Bitmap.TransparentColor := clWhite;
    tarjaDireita.Picture.Bitmap.TransparentMode := tmAuto;
    tarjaDireita.Transparent := true;
    tarjaDireita.Picture.LoadFromFile('.\caco\tarja\igual3.bmp');
  end;

  inicioNivel;

end;

procedure TForm1.inicioDurIEE(Nivel : Integer);
begin
  if (Nivel >= 1) and (Nivel <= 4) then
    qtdDurIEE := 3
  else
    qtdDurIEE := 5;

  SetLength(arrayDurIEE,qtdDurIEE);
  if(Nivel = 1) then
    begin
      arrayDurIEE[0] := 'd200e500';
      arrayDurIEE[1] := 'd200e450';
      arrayDurIEE[2] := 'd200e400';
    end
  else if(Nivel = 2) then
    begin
      arrayDurIEE[0] := 'd150e400';
      arrayDurIEE[1] := 'd150e350';
      arrayDurIEE[2] := 'd150e300';
    end
  else if(Nivel = 3) then
    begin
      arrayDurIEE[0] := 'd100e300';
      arrayDurIEE[1] := 'd100e250';
      arrayDurIEE[2] := 'd100e200';
    end
  else if(Nivel = 4) then
    begin
      arrayDurIEE[0] := 'd80e200';
      arrayDurIEE[1] := 'd80e150';
      arrayDurIEE[2] := 'd80e100';
    end
  else if(Nivel = 5) then
    begin
      arrayDurIEE[0] := 'd60e100';
      arrayDurIEE[1] := 'd60e80';
      arrayDurIEE[2] := 'd60e60';
      arrayDurIEE[3] := 'd60e40';
      arrayDurIEE[4] := 'd60e20';
    end
  else if(Nivel = 6) then
    begin
      arrayDurIEE[0] := 'd40e100';
      arrayDurIEE[1] := 'd40e80';
      arrayDurIEE[2] := 'd40e60';
      arrayDurIEE[3] := 'd40e40';
      arrayDurIEE[4] := 'd40e20';
    end;
end;

procedure TForm1.inicioNivel;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create( arqConfiguracao );
  try
    ini.WriteInteger( nomeDoUsuario+'-Caco', 'nivelAtual', nivelAtual );
  finally
  ini.Free;
  end;

  inicioDurIEE(nivelAtual);

  inicioCiclo;

end;

procedure TForm1.inicioCiclo;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create( arqConfiguracao );
  try
    ini.WriteInteger( nomeDoUsuario+'-Caco', 'cicloAtual', cicloAtual );
    ini.WriteInteger( nomeDoUsuario+'-Caco', 'durIEEAtual', durIEEAtual );
  finally
  ini.Free;
  end;

  tentativaAtual := 1;
  qtdAcerto := 0;
  vidaAtual := totalVidas;
  redesenhaTarjaInicialCanvasVidas;

  if (faseAtual = 1) then
  begin
    arraySom[0] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'aa.wav';
    arraySom[1] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'ag.wav';
    arraySom[2] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'ga.wav';
    arraySom[3] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'gg.wav';
  end
  else if (faseAtual = 2) then
  begin
    arraySom[0] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'aa.wav';
    arraySom[1] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'ag.wav';
    arraySom[2] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'ga.wav';
    arraySom[3] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'gg.wav';
  end
  else
  begin
    arraySom[0] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'aaa.wav';
    arraySom[1] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'aag.wav';
    arraySom[2] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'aga.wav';
    arraySom[3] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'agg.wav';
    arraySom[4] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'gaa.wav';
    arraySom[5] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'gag.wav';
    arraySom[6] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'gga.wav';
    arraySom[7] := '.\caco\som\f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+'ggg.wav';
  end;

end;



procedure TForm1.gravaResposta;
var
   F: TextFile;
   questao : String;
   fileHandler : Integer;
begin
  if (not FileExists(nomeArqResultado)) then
  begin
    fileHandler := FileCreate(nomeArqResultado);
    FileClose(fileHandler);
  end;

  AssignFile(F,nomeArqResultado);
  Append(F);
  if (calculaResposta) then
    questao := DateToStr(Now)+ ' '+TimeToStr(Now)+' '+
    arrayFase[faseAtual-1]+ ' '+
    'f'+ arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+
    ' '+IntToStr(tentativaAtual-1)+ ' -  V '
  else
    questao := DateToStr(Now)+ ' '+TimeToStr(Now)+' '+
    arrayFase[faseAtual-1]+ ' '+
    'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]+
    ' '+IntToStr(tentativaAtual-1)+' -  F ' ;
  Writeln(F,questao);
  CloseFile(F);

end;


procedure TForm1.botaocimaClick();
begin
  if resposta0 = -1 then
    resposta0 := 0
  else if resposta1 = -1 then
    resposta1 := 0
  else if resposta2 = -1 then
    begin
      resposta2 := 0;
      exibeResposta;
      gravaResposta;
      contaAcertos;
    end;
end;

procedure TForm1.botaobaixoClick();
begin
  if resposta0 = -1 then
    resposta0 := 1
  else if resposta1 = -1 then
    resposta1 := 1
  else if resposta2 = -1 then
    begin
      resposta2 := 1;
      exibeResposta;
      gravaResposta;
      contaAcertos;
    end;
end;

function TForm1.calculaResposta:Boolean;
var respostaEsperada, respostaObtida : Integer;
begin
  respostaEsperada := arrayResp[questaoAtual];
  respostaObtida := resposta2 + 2*resposta1+4*resposta0;
  if respostaEsperada = respostaObtida then
    calculaResposta := true
  else
    calculaResposta := false;
end;


procedure TForm1.exibeResposta;
begin
  exibeRespostaVisual(calculaResposta);
end;

procedure TForm1.contaAcertos;
begin
  if(calculaResposta) then
    qtdAcerto := qtdAcerto+1;
end;

procedure TForm1.exibeRespostaVisual(Acertou: Boolean);
begin
  if Acertou then
    acao := 1
  else
    acao := 2;
  Timer1.Enabled := true;
end;

procedure TForm1.desenhaTarjaEsquerda();
begin
  changeRect := spriteRect;
  spriteRect.Left := 0;
  spriteRect.Top := 0;
  spriteRect.Right := 0 + ClientWidth;
  spriteRect.Bottom := 0 + ClientHeight;

  workCanvas.CopyRect(spriteRect, backgroundCanvas, spriteRect);

  workCanvas.StretchDraw( backgroundRect, tarjaEsquerda.Picture.Bitmap);

  //desenhaVidas
  if (vidaAtual > 0) then
    workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  workCanvas.Font.Size := 20;
  workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.85),'PONTOS '+IntToStr(pontos));
  if exibeSomAtual then
    workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.92),'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]);

  if (exemplo) then
  begin
    workCanvas.Font.Size := 133;
    workCanvas.TextOut(Trunc(ClientWidth*0.05),Trunc(ClientHeight*0.2),'EXEMPLO...');
  end;

  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  Canvas.CopyRect(changeRect, workCanvas, changeRect);
end;

procedure TForm1.desenhaTarjaDireita();
begin
  changeRect := spriteRect;
  spriteRect.Left := 0;
  spriteRect.Top := 0;
  spriteRect.Right := 0 + ClientWidth;
  spriteRect.Bottom := 0 + ClientHeight;

  workCanvas.CopyRect(spriteRect, backgroundCanvas, spriteRect);

  workCanvas.StretchDraw( backgroundRect, tarjaDireita.Picture.Bitmap);

  //desenhaVidas
  if (vidaAtual > 0 ) then
    workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  workCanvas.Font.Size := 20;
  workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.85),'PONTOS '+IntToStr(pontos));
  if exibeSomAtual then
    workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.92),'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]);

  if (exemplo) then
  begin
    workCanvas.Font.Size := 133;
    workCanvas.TextOut(Trunc(ClientWidth*0.05),Trunc(ClientHeight*0.2),'EXEMPLO...');
  end;

  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  Canvas.CopyRect(changeRect, workCanvas, changeRect);
end;

procedure TForm1.desenhaTarjaNormal();
begin
  changeRect := spriteRect;
  spriteRect.Left := 0;
  spriteRect.Top := 0;
  spriteRect.Right := 0 + ClientWidth;
  spriteRect.Bottom := 0 + ClientHeight;

  workCanvas.CopyRect(spriteRect, backgroundCanvas, spriteRect);

  workCanvas.StretchDraw( backgroundRect, tarjaInicial.Picture.Bitmap);

  //desenhaVidas
  if (vidaAtual > 0) then
    workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  workCanvas.Font.Size := 20;
  workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.85),'PONTOS '+IntToStr(pontos));
  if exibeSomAtual then
    workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.92),'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]);

  if (exemplo) then
  begin
    workCanvas.Font.Size := 133;
    workCanvas.TextOut(Trunc(ClientWidth*0.05),Trunc(ClientHeight*0.2),'EXEMPLO...');
  end;

  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  Canvas.CopyRect(changeRect, workCanvas, changeRect);
end;

procedure TForm1.desenhaTarjaSom();
begin
  changeRect := spriteRect;
  spriteRect.Left := 0;
  spriteRect.Top := 0;
  spriteRect.Right := 0 + ClientWidth;
  spriteRect.Bottom := 0 + ClientHeight;

  workCanvas.CopyRect(spriteRect, backgroundCanvas, spriteRect);

  workCanvas.StretchDraw( backgroundRect, tarjaSom.Picture.Bitmap);

  //desenhaVidas
  if (vidaAtual > 0) then
    workCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);

  workCanvas.Font.Size := 20;
  workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.85),'PONTOS '+IntToStr(pontos));
  if exibeSomAtual then
    workCanvas.TextOut(Trunc(ClientWidth*0.75),Trunc(ClientHeight*0.92),'f'+arrayCiclos[cicloAtual-1]+arrayDurIEE[durIEEAtual-1]);

  if (exemplo) then
  begin
    workCanvas.Font.Size := 133;
    workCanvas.TextOut(Trunc(ClientWidth*0.05),Trunc(ClientHeight*0.2),'EXEMPLO...');
  end;

  RealizePalette(backgroundCanvas.Handle);
  RealizePalette(workCanvas.Handle);
  Canvas.CopyRect(changeRect, workCanvas, changeRect);
end;

procedure TForm1.exemploFase();
begin
  exemplo := true;
  desenhaTarjaNormal();
  if (faseAtual = 1) then
  begin
    MediaPlayer1.FileName := arraySom[0];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(1000);
    desenhaTarjaEsquerda();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(1000);
    MediaPlayer1.FileName := arraySom[1];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(1000);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
  end
  else if (faseAtual = 2) then
  begin
    MediaPlayer1.FileName := arraySom[0];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(1000);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(1000);
    MediaPlayer1.FileName := arraySom[1];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(1000);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaEsquerda();
    Sleep(1000);
    desenhaTarjaNormal();
  end
  else if (faseAtual = 3) then
  begin
    MediaPlayer1.FileName := arraySom[0];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(2000);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(1000);
    MediaPlayer1.FileName := arraySom[5];
    MediaPlayer1.Wait := true;
    MediaPlayer1.Notify := true;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    Sleep(2000);
    desenhaTarjaEsquerda();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaDireita();
    Sleep(1000);
    desenhaTarjaNormal();
    Sleep(400);
    desenhaTarjaEsquerda();
    Sleep(1000);
    desenhaTarjaNormal();
  end;
  acao := 0;
  exemplo := false;
  desenhaTarjaNormal();  
end;


procedure TForm1.TmrTempoJogoTimer(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create( arqConfiguracao );
  try
    ini.WriteBool( nomeDoUsuario+'-Caco', 'passouTempo', true );
  finally
  ini.Free;
  end;
  FimForm.ShowModal;
end;

procedure TForm1.validaSons();
var
  i, j, k, l : Integer;
begin
  faseAtual := 1;
  durIEEAtual := 1;
  nivelAtual := 1;
  cicloAtual := 1;
  iniciaFase;


  for i := 1 to qtdNiveis do
    begin
    nivelAtual := i;
    inicioNivel;
    for j := 1 to qtdCiclos do
      begin
      cicloAtual := j;
      for k := 1 to qtdDurIEE do
      begin
        durIEEAtual := k;
        inicioCiclo;
        for l := 1 to 4 do
          if not (FileExists(arraySom[l-1])) then
          begin
            FrmGameOver.Width := 600;
            FrmGameOver.Label1.Font.Size := 10;
            FrmGameOver.Label1.Caption := arraySom[l-1];
            FrmGameOver.ShowModal;
          end;
        end;
      end;
    end;

  faseAtual := 3;
  durIEEAtual := 1;
  nivelAtual := 1;
  cicloAtual := 1;
  iniciaFase;


  for i := 1 to qtdNiveis do
    begin
    nivelAtual := i;
    inicioNivel;
    for j := 1 to qtdCiclos do
      begin
      cicloAtual := j;
      for k := 1 to qtdDurIEE do
      begin
        durIEEAtual := k;
        inicioCiclo;
        for l := 1 to 8 do
          if not (FileExists(arraySom[l-1])) then
          begin
            FrmGameOver.Width := 600;
            FrmGameOver.Label1.Font.Size := 10;
            FrmGameOver.Label1.Caption := arraySom[l-1];
            FrmGameOver.ShowModal;
          end;
        end;
      end;
    end;

end;

procedure TForm1.redesenhaTarjaInicialCanvasVidas();
begin
  if (tarjaNormalCanvas <> nil) and (backgroundCanvas <> nil) then
  begin
    tarjaNormalCanvas.CopyRect(backgroundRect,  backgroundCanvas, backgroundRect);
    tarjaNormalCanvas.StretchDraw( backgroundRect, tarjaInicial.Picture.Bitmap);
    if (vidaAtual > 0) then
      tarjaNormalCanvas.StretchDraw(backgroundRect, arrayImgVida[vidaAtual-1].Picture.Bitmap);
  end;
end;

end.