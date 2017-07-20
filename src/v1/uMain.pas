unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uZintBarcode, StdCtrls, jpeg,

  IdCoderMIME;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    mmo1: TMemo;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses IdCoder;

{$R *.dfm}

//function CreateBase64String(FileName: string): string;
//var
//  Fs: TFileStream;
//begin
//  try
//    Fs := TFileStream.Create(FileName, fmOpenRead);
//    with TIdEncoderMIME.Create(nil) do
//    begin
//      Result := Encode(Fs);
//      Free;
//    end;
//    FreeAndNil(Fs);
//  except
//    FreeAndNil(Fs);
//    Result := '';
//  end;
//
//end;

{*--------------------------------------------------------------------
create barcode image and save as jpg

@author
@version
----------------------------------------------------------------------}

//function CreateBarcode(const fname: string = ''; const datas: string = '???';
//  const top_text: string =
//  ' '; const bottom_text: string = ' '): Boolean;
//var
//  resx: Boolean;
//  bmpBarcode, bmpAll: TBitmap;
//  jpgx: TJPEGImage;
//  i, txt_w, txt_h: Integer;
//  s0: Cardinal;
//  zintBarcode: TZintBarcode;
//begin
//  try
//    resx := False;
//    bmpBarcode := TBitmap.Create;
//    bmpAll := TBitmap.Create;
//    jpgx := TJPEGImage.Create;
//    zintBarcode := TZintBarcode.Create;
//
//    with zintBarcode do
//    begin
//      Data := datas;
//      BarcodeType := tBARCODE_CODE128;
//      Option1 := 4;
//      Scale := 1;
//      GetBarcode(bmpBarcode);
//
//      //add top text
//      with bmpAll do
//      begin
//        txt_w := Canvas.TextWidth(top_text);
//        txt_h := Canvas.TextHeight(top_text);
//
//        Width := bmpBarcode.Width;
//        Height := bmpBarcode.Height + (2 * txt_h) + 4;
//
//        //        draw top text
//        Canvas.TextOut((Width - txt_w) div 2, 0, top_text);
//
//        //draw barcode
//        Canvas.Draw(0, txt_h + 2, bmpBarcode);
//
//        //        draw bottom_text text
//        txt_w := Canvas.TextWidth(bottom_text);
//        Canvas.TextOut((Width - txt_w) div 2, Height - txt_h - 4, bottom_text);
//      end;
//
//      jpgx.Assign(bmpAll);
//      if fname <> '' then
//        jpgx.SaveToFile(fname)
//      else
//        jpgx.SaveToFile(Data + '.jpg');
//    end;
//
//    zintBarcode.Free;
//    bmpAll.Free;
//    bmpBarcode.Free;
//    jpgx.Free;
//
//    resx := True;
//
//  except
//    begin
//      resx := False;
//      zintBarcode.Free;
//      bmpAll.Free;
//      bmpBarcode.Free;
//      jpgx.Free;
//    end;
//  end;
//  Result := resx;
//end;

{*--------------------------------------------------------------------
text to barcode base64 image html

@author
@version
----------------------------------------------------------------------}

function TextToBarcodeBase64(const fname: string = ''; const datas: string =
  '???';
  const top_text: string =
  ' '; const bottom_text: string = ' '): string;
var
  resx: string;
  bmpBarcode, bmpAll: TBitmap;
  jpgx: TJPEGImage;
  i, txt_w, txt_h: Integer;
  s0: Cardinal;
  zintBarcode: TZintBarcode;
  memstream: TMemoryStream;

begin
  resx := '';
  try
    bmpBarcode := TBitmap.Create;
    bmpAll := TBitmap.Create;
    jpgx := TJPEGImage.Create;
    zintBarcode := TZintBarcode.Create;
    memstream := TMemoryStream.Create;

    with zintBarcode do
    begin
      //      prepare the barcode
      Data := datas;
      BarcodeType := tBARCODE_CODE128;
      Option1 := 4;
      Scale := 1;
      GetBarcode(bmpBarcode);

      //add top text
      with bmpAll do
      begin
        txt_w := Canvas.TextWidth(top_text);
        txt_h := Canvas.TextHeight(top_text);

        Width := bmpBarcode.Width;
        Height := bmpBarcode.Height + (2 * txt_h) + 4;

        //        draw top text
        Canvas.TextOut((Width - txt_w) div 2, 0, top_text);

        //draw barcode
        Canvas.Draw(0, txt_h + 2, bmpBarcode);

        //        draw bottom_text text
        txt_w := Canvas.TextWidth(bottom_text);
        Canvas.TextOut((Width - txt_w) div 2, Height - txt_h - 4, bottom_text);
      end;

      jpgx.Assign(bmpAll);
      if fname <> '' then
        jpgx.SaveToFile(fname)
      else
        jpgx.SaveToFile(Data + '.jpg');

      //save to memstream
      jpgx.SaveToStream(memstream);

      //encode it
      memstream.Position := 0;
      with TIdEncoderMIME.Create(nil) do
      begin
        resx := 'data:image/jpeg;base64,' + Encode(memstream);
        Free;
      end;
    end;

    zintBarcode.Free;
    bmpAll.Free;
    bmpBarcode.Free;
    jpgx.Free;
    memstream.Free;

  except
    begin
      resx := '';
      zintBarcode.Free;
      bmpAll.Free;
      bmpBarcode.Free;
      jpgx.Free;
      memstream.Free;
    end;
  end;
  Result := resx;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
//  ShowMessage(IntToStr(ord(
//    CreateBarcode('', '1234567890', FormatDateTime('ddmmyyyy hhnnss', Now),
//    'Rp 15.000,00')
//    )));
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  mmo1.Text := TextToBarcodeBase64('', '1234567890', 'HELLO WORLD',
    'Rp 1.2345,00');
end;

end.

