clear all;
% v=videoinput(winvideo')
% I=getsnapshot(v),

HareketEsik=20; % Fark resminde dikkate al�nmamas� gereken farklar i�in e�ik 

BG = imread('Nilufer.jpg');
I = imread('Nilufer2.jpg'); % orjinal
In = imnoise(I,'salt & pepper',0); % gurultu eklenmis
%imwrite(I)
%% Webcamdan renkli g�r�nt� al�nd���nda gri resme �evirmek i�in 
% kullanabilirsiniz.
% RGB renkli g�r�nt� format�ndan gri resim format�na ge�ilmeli
% RGB g�r�nt� matrisi nxmx3 boyutludur. Gri resim format� nxm boyutludur.
BGg=rgb2gray(BG); % gri imgeye d�n��t�r.
Ig=rgb2gray(In); % gri imgeye d�n��t�r.

%% G�r�nt�n�n renk da��l�m� iyile�tirmesi
% Anl�k ���k de�i�imlerinin olumsuz etkilerini azaltmak i�in intensity
% ayarlanabilir.
% BGg = imadjust(BGg);
% Ig = imadjust(Ig);
BGg = histeq(BGg);
Ig = histeq(Ig);

%% Fark resminin hesaplanmas�
%unsigned integer BGg ve Ig double yap�lmal�. Aksi halde negatif de�erler
%al�nm�yor
MutlakFark=abs(double(BGg)-double(Ig)); 
% Mutlak fardaki random g�r�lt� median filtre ile temizlenir.
MutlakFarkFilt=medfilt2(MutlakFark,[10 10]);
% H = fspecial('gaussian',5);
% MutlakFarkFilt=imfilter(MutlakFark,H);
%% Fark�n resminin e�iklenmesi
[m n]=size(MutlakFarkFilt);
for i=1:m
    for j=1:n
        % Mutlak fark de�eri hareket e�ikten b�y�k olan noktalar i�in
        % hareket b�lgesi matrisine 1 de�eri ver
        if MutlakFarkFilt(i,j)>HareketEsik
           HareketliBolge(i,j)=1;
        else
           HareketliBolge(i,j)=0;
        end
    end
end

%% Hareketli b�lgenin analiz edilen resimede i�aretlenmesi
%BolgeKenari = edge(HareketliBolge,'sobel');
[m n]=size(HareketliBolge);
Ih=0.6*In;
for i=1:m-1
    for j=1:n-1
        % Mutlak fark de�eri hareket e�ikten b�y�k olan noktalar i�in
        % hareket b�lgesi matrisine 1 de�eri ver
        
        if HareketliBolge(i,j)>0
           Ih(i,j,1:3)=In(i,j,1:3);% Hareketli b�lgenin mavili�i art�r�l�r
        end  
        if abs(HareketliBolge(i,j)-HareketliBolge(i+1,j))>0 ||abs(HareketliBolge(i,j)-HareketliBolge(i,j+1))>0 
           Ih(i,j,1)=255; Ih(i,j,2)=255; Ih(i,j,3)=255;  % Kenar b�lge beyaz yap�l�r
        end
    end
end
%
% BW1 = edge(BG,'canny');
% BW2 = edge(I,'canny');
%% Hesaplama ad�mlar�ndaki matrislerin �izimleri
f1=figure(1);
set(f1,'Position',[30 600 400 300],'Name','Geriplan Imge')
imagesc(BGg);colormap(gray);
f2=figure(2);
set(f2,'Position',[450 600 400 300],'Name','Al�nan Imge')
imagesc(Ig);colorbar;
f3=figure(3);
set(f3,'Position',[30 200 400 300],'Name','Mutlak Fark')
imagesc(MutlakFark);colorbar;
f4=figure(4);
set(f4,'Position',[450 200 400 300],'Name','�kili Hareketli Bolge')
imagesc(HareketliBolge);colorbar;
f5=figure(5);
set(f5,'Position',[870 200 400 300],'Name','Imge �zerinde B�lge')
imagesc(abs(Ih));colormap(gray); 
pause(0.1);
