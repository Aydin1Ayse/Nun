clear all;
% v=videoinput(winvideo')
% I=getsnapshot(v),

HareketEsik=20; % Fark resminde dikkate alýnmamasý gereken farklar için eþik 

BG = imread('Nilufer.jpg');
I = imread('Nilufer2.jpg'); % orjinal
In = imnoise(I,'salt & pepper',0); % gurultu eklenmis
%imwrite(I)
%% Webcamdan renkli görüntü alýndýðýnda gri resme çevirmek için 
% kullanabilirsiniz.
% RGB renkli görüntü formatýndan gri resim formatýna geçilmeli
% RGB görüntü matrisi nxmx3 boyutludur. Gri resim formatý nxm boyutludur.
BGg=rgb2gray(BG); % gri imgeye dönüþtür.
Ig=rgb2gray(In); % gri imgeye dönüþtür.

%% Görüntünün renk daðýlýmý iyileþtirmesi
% Anlýk ýþýk deðiþimlerinin olumsuz etkilerini azaltmak için intensity
% ayarlanabilir.
% BGg = imadjust(BGg);
% Ig = imadjust(Ig);
BGg = histeq(BGg);
Ig = histeq(Ig);

%% Fark resminin hesaplanmasý
%unsigned integer BGg ve Ig double yapýlmalý. Aksi halde negatif deðerler
%alýnmýyor
MutlakFark=abs(double(BGg)-double(Ig)); 
% Mutlak fardaki random gürültü median filtre ile temizlenir.
MutlakFarkFilt=medfilt2(MutlakFark,[10 10]);
% H = fspecial('gaussian',5);
% MutlakFarkFilt=imfilter(MutlakFark,H);
%% Farkýn resminin eþiklenmesi
[m n]=size(MutlakFarkFilt);
for i=1:m
    for j=1:n
        % Mutlak fark deðeri hareket eþikten büyük olan noktalar için
        % hareket bölgesi matrisine 1 deðeri ver
        if MutlakFarkFilt(i,j)>HareketEsik
           HareketliBolge(i,j)=1;
        else
           HareketliBolge(i,j)=0;
        end
    end
end

%% Hareketli bölgenin analiz edilen resimede iþaretlenmesi
%BolgeKenari = edge(HareketliBolge,'sobel');
[m n]=size(HareketliBolge);
Ih=0.6*In;
for i=1:m-1
    for j=1:n-1
        % Mutlak fark deðeri hareket eþikten büyük olan noktalar için
        % hareket bölgesi matrisine 1 deðeri ver
        
        if HareketliBolge(i,j)>0
           Ih(i,j,1:3)=In(i,j,1:3);% Hareketli bölgenin maviliði artýrýlýr
        end  
        if abs(HareketliBolge(i,j)-HareketliBolge(i+1,j))>0 ||abs(HareketliBolge(i,j)-HareketliBolge(i,j+1))>0 
           Ih(i,j,1)=255; Ih(i,j,2)=255; Ih(i,j,3)=255;  % Kenar bölge beyaz yapýlýr
        end
    end
end
%
% BW1 = edge(BG,'canny');
% BW2 = edge(I,'canny');
%% Hesaplama adýmlarýndaki matrislerin çizimleri
f1=figure(1);
set(f1,'Position',[30 600 400 300],'Name','Geriplan Imge')
imagesc(BGg);colormap(gray);
f2=figure(2);
set(f2,'Position',[450 600 400 300],'Name','Alýnan Imge')
imagesc(Ig);colorbar;
f3=figure(3);
set(f3,'Position',[30 200 400 300],'Name','Mutlak Fark')
imagesc(MutlakFark);colorbar;
f4=figure(4);
set(f4,'Position',[450 200 400 300],'Name','Ýkili Hareketli Bolge')
imagesc(HareketliBolge);colorbar;
f5=figure(5);
set(f5,'Position',[870 200 400 300],'Name','Imge Üzerinde Bölge')
imagesc(abs(Ih));colormap(gray); 
pause(0.1);
